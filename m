Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0JRK0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:26:51 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:36253 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0JRK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:26:50 -0400
Date: Mon, 18 Oct 2010 12:26:42 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [sparc build bug] Re: [tip:perf/core] irq: Add tracepoint to
 softirq_raise
Message-ID: <20101018102641.GA2324@osiris.boeblingen.de.ibm.com>
References: <4C724298.4050509@jp.fujitsu.com>
 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
 <20100908112529.GA25931@elte.hu>
 <1287395077.29097.1543.camel@twins>
 <1287396707.29097.1544.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287396707.29097.1544.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:11:47PM +0200, Peter Zijlstra wrote:
> > I could build sparc64_defconfig, but s390 is broken for me by this...
> 
> 
> the below makes s390 build again, not sure its completely safe for all
> configs though...
> 
> Heiko?

We have a similar patch in our git tree to fix this issue:

http://git390.marist.edu/cgi-bin/gitweb.cgi?p=linux-2.6.git;a=commitdiff;h=b722c7e6ce9b52b58a5488aacfd90936a2720dd9

(link valid until the next rebase ;)
 
> ---
>  arch/s390/include/asm/hardirq.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/s390/include/asm/hardirq.h
> b/arch/s390/include/asm/hardirq.h
> index 498bc38..9558a71 100644
> --- a/arch/s390/include/asm/hardirq.h
> +++ b/arch/s390/include/asm/hardirq.h
> @@ -15,7 +15,6 @@
>  #include <linux/threads.h>
>  #include <linux/sched.h>
>  #include <linux/cache.h>
> -#include <linux/interrupt.h>
>  #include <asm/lowcore.h>
>  
>  #define local_softirq_pending() (S390_lowcore.softirq_pending)
> 
