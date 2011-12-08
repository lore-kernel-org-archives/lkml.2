Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1LHSec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:34:32 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58047 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1LHSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:34:29 -0500
X-SpamScore: -13
X-BigFish: VS-13(zz1432N98dK4015Lzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.36.179.112;KIP:(null);UIP:(null);IPV:NLI;H:kedge2.utk.tennessee.edu;RD:kedge2.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 8 Dec 2011 13:34:04 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <eranian@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_event self-monitoring overhead regression
In-Reply-To: <CAMsRxfL3NVuz0dL-=iTJUsPMBt1frcfQ43fyc8pNoHEM9NXiOg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112081324311.25737@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu> <1322654092.2921.256.camel@twins> <CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com> <alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
 <CAMsRxfJmXXxDrofY3PDOLWRC7E-o6mANiTSJwYbyMTgOT_J0UA@mail.gmail.com> <alpine.DEB.2.00.1112061604040.23414@cl320.eecs.utk.edu> <CAMsRxfL3NVuz0dL-=iTJUsPMBt1frcfQ43fyc8pNoHEM9NXiOg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, stephane eranian wrote:

> Are those the results for surrounding the ioctl() with rdtsc()?
> 
> What do the axis actually represent?
> 

The code looks like this:

   start_before=rdtsc();
   ret1=ioctl(fd[0], PERF_EVENT_IOC_ENABLE,0);
   start_after=rdtsc();

Similar for stop and read.  The events are set up in advance.

I've put up a page with some more graphs (though they're a bit rough yet)
and more background on what the tests are doing here:
   
 http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/rdtsc_overhead/

The overall overhead results I'm seeing with rdtsc() are the same I saw 
using the clock_gettime() calls.

The total overhead of start/stop/read seems to be getting worse with 
each kernel release, but the individual start, stop and read calls don't
follow an obvious pattern.

I'm rebuilding stock kernels with the same compiler/config and I'll re-run
the tests but it might be a few days before I'll have those results.

Thanks,

Vince
vweaver1@eecs.utk.edu

