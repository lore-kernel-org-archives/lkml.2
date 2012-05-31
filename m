Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab2EaTcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:32:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab2EaTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:32:54 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=qkk5gtdUeUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=FhTsiWAN-fuJitd0r5AA:9 a=PUjeQqilurYA:10 a=hnJDk0GgsYnuvlWa:21 a=vp01xS_Q1RQbRkSh:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338492772.13348.388.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 31 May 2012 15:32:52 -0400
In-Reply-To: <20120531171337.GN14515@aftab.osrc.amd.com>
References: <20120531100005.GC14074@aftab.osrc.amd.com>
	 <4FC748F5.9070709@redhat.com> <20120531121741.GB14515@aftab.osrc.amd.com>
	 <4FC7788C.1070405@redhat.com> <20120531142229.GF14515@aftab.osrc.amd.com>
	 <4FC783EA.80704@redhat.com> <20120531145416.GI14515@aftab.osrc.amd.com>
	 <4FC787BF.3020006@redhat.com> <20120531151408.GJ14515@aftab.osrc.amd.com>
	 <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 19:13 +0200, Borislav Petkov wrote:

> > 	- No other userspace API provides it;
> 
> Yes, it should.
> 
> > 	- The granularity is a property of the per-error address;
> 
> Not necessarily, as it is shown above.
> 
> > 	- There are well-known cases where the address grain changes are
> > 	  dynamically filled by the error registers (MCA arch on Intel).
> 
> Ok.
> 
> > So, the memory error tracepoint is the proper place to store it, as it is
> > the place where the address and the other memory error information is
> > reported to userspace.
> 
> Yes, but not as a separate field but in driver_detail _only_ on those
> drivers where grain is dynamic. The remaining ones simply don't output
> it all because they have done so in dmesg or sysfs.
> 
> > Also, converting the grain to a string, as you proposed would require
> > at least 26 bytes to store "grain: 0xdeadbeef:deadbeef", while putting
> > it as a u64 will consume only 8 bytes.
> 
> Again, only on those drivers which have dynamic grain. Other drivers
> which keep outputting 'x' (and 'x' doesn't change) on every tracepoint
> invocation don't need to output it all in the tracepoint. Their
> tracepoint records shouldn't be inflated for no reason.

Just so I understand your point. You are saying things like grain that
don't change but are different per device, should just be in some sysfs
file somewhere, and things that are dynamic during runtime should go
into the tracepoint.

Correct?

-- Steve



