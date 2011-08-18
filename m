Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1HRQ7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:59:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1HRQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:59:21 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=6-3U9yaARtIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=padm9Ysyf1aMKPbWuSwA:9 a=sqX1MiIBQfUU3ogLKwoA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/8] perf: Separate out trace-cmd parse-events
 from perf files
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <4E4D3FE2.8000504@gmail.com>
References: <20110805205921.909038487@goodmis.org>
	 <20110805211300.324726820@goodmis.org> <4E4945F8.2080004@gmail.com>
	 <1313425364.15704.9.camel@gandalf.stny.rr.com> <4E4B0667.8090107@gmail.com>
	 <20110818135112.GB10441@somewhere>  <4E4D3FE2.8000504@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 12:59:17 -0400
Message-ID: <1313686757.15704.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 10:37 -0600, David Ahern wrote:
> On 08/18/2011 07:51 AM, Frederic Weisbecker wrote:

> I guess to be more specific about next steps:
> - should trace-cmd be moved to the tools directory in the kernel repo?

Nah, I rather keep it out of the kernel for now.

> that would allow code movement to a lib directory and work to be done on
> both trace-cmd and perf
> - what's the conclusion about the name and path for the common parsing
> code? seems like libtraceevent or libtraceparse had the fewest collisions

I guess libtraceparse is fine. Or maybe even libtraceparser.


> - should the plugin code be moved into its own directory - e.g.,
> tools/lib/trace-plugins. I am working on plugin changes too (eg.,
> resolving guest RIPs to symbols in the kvm plugin).

I think it should have its own directory. Or maybe even have it within
the kernel proper itself?  Have it install like modules:

/lib/modules/v3.0-rc2/plugins/

??


> 
> The current patch set from Steve needs some updates (in addition to what
> is needed for perf to use the plugins) to handle trace-cmd and perf
> differences, but this is getting far down the path.

I'm currently working on other things, and I'm waiting for consensus
before I waste more time on it.

Don't worry about trace-cmd. If libtraceparser becomes an installed
library, I'll have trace-cmd use it directly. As long as the library
stays generic (which it should) this should not cause any issues. For
now, trace-cmd will keep its original libparsevents, and I can update
that until we have this library in distributions.

Thanks!

-- Steve


