Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1LAN7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:59:51 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13639
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638Ab1LAN7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:59:49 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371K1432N98dK4015Lzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 1 Dec 2011 08:59:37 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: perf_event self-monitoring overhead regression
In-Reply-To: <CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu> <1322654092.2921.256.camel@twins> <CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, Linus Torvalds wrote:

> On Wed, Nov 30, 2011 at 3:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> So bisect works really well for clear bugs that are 100% repeatable
> and have a very clear "did it happen or not" signature, but I'd be
> very leery indeed of using it with some performance anomaly.

In this case, the bisection case is pretty clean.  I run 1000 of the tests 
and check the median value, and the values are always 7280us for good and 
7440us for bad.

The problem is when it starts bisecting into the merges it drops from a 
post-3.0 kernel into a much earlier 3.0-rc kernel (due to the ARM merge 
history) and suddenly then the test becomes meaningless as it starts 
returning other values such as 6880us.  This is because the problem I am 
tracking has ben gradually getting worse over time, and so I guess by 
going back to a 3.0-rc it gets earlier than some other change that made 
performance worse, and thus it becomes impossible to know if a commit is 
good or not.

> That said, maybe you can get the timings to be unambiguous enough by
> using 'rdtsc' in user space, and try the bisect again.

I'll try but I'm guessing your first thought that this might be 
un-bisectabe is probably true.  

Thanks,

Vince

