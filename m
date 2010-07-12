Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0GLKgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:36:10 -0400
Received: from www.tglx.de ([62.245.132.106]:33738 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0GLKgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:36:08 -0400
Date: Mon, 12 Jul 2010 12:35:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        John Kacur <jkacur@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 3/4] futex: free_pi_state outside of hb->lock sections
In-Reply-To: <1278714780-788-4-git-send-email-dvhltc@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1007121231290.2798@localhost.localdomain>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-4-git-send-email-dvhltc@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Darren Hart wrote:

> free_pi_state() calls kfree() and might sleep. To prepare for raw hb->locks,
> get the calls to free_pi_state() out of the hb->lock() sections.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/futex.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index a6cec32..b217972 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -114,7 +114,7 @@ struct futex_q {
>  	struct plist_node list;
>  
>  	struct task_struct *task;
> -	spinlock_t *lock_ptr;
> +	raw_spinlock_t *lock_ptr;

 How is this related to the changelog ?

Thanks,

	tglx
