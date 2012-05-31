Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab2EaULg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:11:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab2EaULe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:11:34 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=qkk5gtdUeUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=2yOSI_zuPRk3MrtixmEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338495092.13348.419.camel@gandalf.stny.rr.com>
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
Date: Thu, 31 May 2012 16:11:32 -0400
In-Reply-To: <20120531194207.GC16998@aftab.osrc.amd.com>
References: <20120531121741.GB14515@aftab.osrc.amd.com>
	 <4FC7788C.1070405@redhat.com> <20120531142229.GF14515@aftab.osrc.amd.com>
	 <4FC783EA.80704@redhat.com> <20120531145416.GI14515@aftab.osrc.amd.com>
	 <4FC787BF.3020006@redhat.com> <20120531151408.GJ14515@aftab.osrc.amd.com>
	 <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com>
	 <1338492772.13348.388.camel@gandalf.stny.rr.com>
	 <20120531194207.GC16998@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 21:42 +0200, Borislav Petkov wrote:
> On Thu, May 31, 2012 at 03:32:52PM -0400, Steven Rostedt wrote:
> > Just so I understand your point. You are saying things like grain that
> > don't change but are different per device, should just be in some sysfs
> > file somewhere, and things that are dynamic during runtime should go
> > into the tracepoint.
> 
> Right, for the majority of edac drivers, grain is a static value
> assigned once per driver initialization.
> 
> Then there are other drivers which report different grain per error.
> 
> Now, all I'm saying is, the static ones should report grain once when
> the driver inits in dmesg or in sysfs and _not_ report grain in each
> tracepoint invocation - we don't want to waste space in the ring buffer
> for information which never or only very seldom changes.
> 
> For the drivers where grain is per error, they report it in the
> tracepoint (and only they!) as part of the driver-specific char string.
> 
> This way all is fair and no space in the ring buffer gets wasted.
> 
> Makes sense?

Sure, but how noisy is EDAC? Does it actually fill up the ring buffers?

-- Steve



