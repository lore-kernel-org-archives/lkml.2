Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0JSLC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:02:59 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44985 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab0JSLC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:02:58 -0400
Subject: Re: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed
 when calling find_lowest_rq
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 13:02:47 +0200
Message-ID: <1287486167.1994.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 16:57 +0600, Rakib Mullick wrote:
> sched_rt: Removes extra checking for nr_cpus_allowed when calling
> find_lowest_rq

Why repeat this subject?

> Remove the check for nr_cpus_allowed of an RT task before calling
> find_lowest_cpu() from select_task_rq_rt function. Cause
> find_lowest_cpu checks for rt.nr_cpus_allowed of a process.
> It would've been nice, if we make the check before calling
> find_lowest_cpu. But its called from other places, so keep the
> nr_cpus_allowed check into find_lowest_cpu().

That's just not explaining anything.. what can go wrong, how does this
fix it.

> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> --- linus-rc8/kernel/sched_rt.c	2010-10-15 05:26:43.000000000 +0600
> +++ rakib-rc8/kernel/sched_rt.c	2010-10-19 16:22:30.000000000 +0600
> @@ -971,8 +971,7 @@ select_task_rq_rt(struct rq *rq, struct
>  	 * that is just being woken and probably will have
>  	 * cold cache anyway.
>  	 */
> -	if (unlikely(rt_task(rq->curr)) &&
> -	    (p->rt.nr_cpus_allowed > 1)) {
> +	if (unlikely(rt_task(rq->curr))) {
>  		int cpu = find_lowest_rq(p);
> 
>  		return (cpu == -1) ? task_cpu(p) : cpu;

