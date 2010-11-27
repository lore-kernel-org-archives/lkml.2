Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0K0PAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:00:52 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41321 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752607Ab0K0PAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:00:51 -0500
Date: Sat, 27 Nov 2010 10:00:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 05/10] x86: Use this_cpu_inc_return for nmi
	counter
Message-ID: <20101127150049.GF15365@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210951.874368925@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126210951.874368925@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:00:37 up 3 days, 20:03,  3 users,  load average: 0.03, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> this_cpu_inc_return() saves us a memory access there.
> 

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> Reviewed-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/x86/kernel/apic/nmi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/nmi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/nmi.c	2010-11-23 16:35:19.000000000 -0600
> +++ linux-2.6/arch/x86/kernel/apic/nmi.c	2010-11-23 16:38:29.000000000 -0600
> @@ -432,8 +432,7 @@ nmi_watchdog_tick(struct pt_regs *regs,
>  		 * Ayiee, looks like this CPU is stuck ...
>  		 * wait a few IRQs (5 seconds) before doing the oops ...
>  		 */
> -		__this_cpu_inc(alert_counter);
> -		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
> +		if (__this_cpu_inc_return(alert_counter) == 5 * nmi_hz)
>  			/*
>  			 * die_nmi will return ONLY if NOTIFY_STOP happens..
>  			 */
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
