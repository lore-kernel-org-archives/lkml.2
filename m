Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1DZIFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:05:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47305 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1DZIE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:04:58 -0400
Date: Tue, 26 Apr 2011 10:04:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [BUG] perf and kmemcheck : fatal combination
Message-ID: <20110426080443.GA806@elte.hu>
References: <1303747731.2747.182.camel@edumazet-laptop>
 <1303803525.20212.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303803525.20212.20.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2011-04-25 at 18:08 +0200, Eric Dumazet wrote:
> > Hi guys
> > 
> > Just got a panic on a kmemcheck kernel, latest linux-2.6 tree.
> > 
> > I forgot I had kmemcheck enabled, and started "perf top" just because my
> > machine was damn slow... Oh well...
> > 
> > Crash in do_nmi -> nmi_enter() -> BUG_ON(in_nmi());
> 
> Hmm,. I bet because kmemcheck triggers faults from nmi context because
> it messes about with the page protection bits a lot to track things.
> 
> Can't really think of anything except not making perf available on
> kmemcheck kernels.
> 
> ---
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 32745bf..94735b4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1125,6 +1125,7 @@ config PERF_EVENTS
>  	bool "Kernel performance events and counters"
>  	default y if (PROFILING || PERF_COUNTERS)
>  	depends on HAVE_PERF_EVENTS
> +	depends on !KMEMCHECK
>  	select ANON_INODES
>  	select IRQ_WORK
>  	help

Eric, does it manage to limp along if you remove the BUG_ON()?

That risks NMI recursion but maybe it allows you to see why things are slow, 
before it crashes ;-)

Thanks,

	Ingo
