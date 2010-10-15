Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0JOO0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:26:33 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43425 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab0JOO0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:26:31 -0400
Subject: Re: [PATCH 3/8] Add a PF flag for ksoftirqd identification
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1286237003-12406-4-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1286237003-12406-4-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 16:26:09 +0200
Message-ID: <1287152769.29097.1519.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 17:03 -0700, Venkatesh Pallipadi wrote:
> @@ -1234,6 +1234,7 @@ struct task_struct {
>  
>         /* Revert to default priority/policy when forking */
>         unsigned sched_reset_on_fork:1;
> +       unsigned sched_thread_bound:1;  /* Thread bound to specific cpu */
>  
>         pid_t pid;
>         pid_t tgid;
> @@ -1708,7 +1709,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
>  #define PF_SWAPWRITE   0x00800000      /* Allowed to write to swap */
>  #define PF_SPREAD_PAGE 0x01000000      /* Spread page cache over cpuset */
>  #define PF_SPREAD_SLAB 0x02000000      /* Spread some slab caches over cpuset */
> -#define PF_THREAD_BOUND        0x04000000      /* Thread bound to specific cpu */
> +#define PF_KSOFTIRQD   0x04000000      /* I am ksoftirqd */ 

No need to do that, there's two free bits, 0x1 and 0x1000 (although this
latter is pending in Andrew's tree).
