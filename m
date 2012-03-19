Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab2CSRf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:35:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2CSRfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:35:24 -0400
Date: Mon, 19 Mar 2012 18:35:22 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] autonuma: fix typo in blind balance
Message-ID: <20120319173522.GG24602@redhat.com>
References: <CAJd=RBAYQYCaUFUY1xNOFhjLyvoYWUAKJy5Xgk197Z1VH5Q8Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAYQYCaUFUY1xNOFhjLyvoYWUAKJy5Xgk197Z1VH5Q8Tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 08:59:59PM +0800, Hillf Danton wrote:
> Since it is certain that nid is not online in each round of for-loop,
> it is replaced with given node id.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched/numa.c	Sat Mar 17 11:01:40 2012
> +++ b/kernel/sched/numa.c	Mon Mar 19 20:04:00 2012
> @@ -34,7 +34,7 @@ static int autonuma_balance_blind(struct
>  		selected_nid = cpu_nid;
> 
>  		nr_mm_max = 0;
> -		for_each_cpu_and(cpu, cpumask_of_node(nid), allowed) {
> +		for_each_cpu_and(cpu, cpumask_of_node(cpu_nid), allowed) {
>  			struct rq *rq = cpu_rq(cpu);
>  			if (rq->curr->mm == mm)
>  				nr_mm_max++;

Correct! gcc should have spwaned an unintialized warning too? I may
have broke it by accident with the editor after I disabled the
function. AUTONUMA_BALANCE_BLIND is not set so this function isn't
getting built right now.

I tried to keep enabled only the minimum, kind of stuff that if you
remove it, something will degrade significantly. 

With the algorithms I developed before the current
sched_autonuma_balance, having autonuma_balance_blind made huge
difference, not anymore once I had something way better as a core
balancer, so then I considered autonuma_balance_blind more like an
hack and I disabled it.

I'm impressed how fast you found these two bugs, appreciated!

If you've high level opinions on the design, comments welcome.

Thanks,
Andrea
