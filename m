Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1KNU5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:57:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55080 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1KNU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:57:43 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=-rl4_mJXG9gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=zzEaY4sKGXaW7yldqj4A:9 a=QH92jgijWTZ5qVNdh-8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/2] v3.2-rc1-52e4c2a05-rt1 fix for compile break
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 15:57:40 -0500
Message-ID: <1321304260.5011.12.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 02:44 +0100, John Kacur wrote:
> kernel/rcutorture.c:492: error: ‘synchronize_rcu_bh’ undeclared here (not in a function)
> 
> In CONFIG_PREEMPT_RT_FULL
> doesn't cover function pointer assignment unless we remove the brackets.

John,

Please write better change logs. Do not assume that people are looking
at the patch while looking at the logs. I mostly read change logs as
"git log" which doesn't include the changes, and most other developers
do this too. The above sentence does not make any real sense.

Something like:

synchronize_rcu_bh() is not just called as a normal function, but can
also be referenced as a function pointer. When CONFIG_PREEMPT_RT_FULL is
enabled, synchronize_rcu_bh() is defined as synchronize_rcu(), but needs
to be defined without the parenthesis because the compiler will complain
when synchronize_rcu_bh is referenced as a function pointer and not a
function.

-- Steve



> 
> Compile-tested.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  include/linux/rcutree.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 800b840..6e503a3 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -60,7 +60,7 @@ static inline void exit_rcu(void)
>  #ifndef CONFIG_PREEMPT_RT_FULL
>  extern void synchronize_rcu_bh(void);
>  #else
> -# define synchronize_rcu_bh()	synchronize_rcu()
> +# define synchronize_rcu_bh	synchronize_rcu
>  #endif
>  extern void synchronize_sched_expedited(void);
>  extern void synchronize_rcu_expedited(void);


