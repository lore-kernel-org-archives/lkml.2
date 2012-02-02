Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2BBBrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:47:18 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39503 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2BBBrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:47:16 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 17:46:56 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 13/41] rcu: Make rcutorture flag
 online/offline failures
Message-ID: <20120202014656.GJ29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-13-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-13-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:31AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Make rcutorture check for CPU-hotplug failures and complain if there
> were any.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutorture.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 88f17b8..a94eaef 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1602,6 +1602,10 @@ rcu_torture_cleanup(void)
>  		cur_ops->cleanup();
>  	if (atomic_read(&n_rcu_torture_error))
>  		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
> +	else if (n_online_successes != n_online_attempts ||
> +		 n_offline_successes != n_offline_attempts)
> +		rcu_torture_print_module_parms(cur_ops,
> +					       "End of test: RCU_HOTPLUG");
>  	else
>  		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");

OK, I must admit that when I saw the addition of RCU_HOTPLUG to the
existing cases of FAILURE and SUCCESS, my mind went to
http://thedailywtf.com/Articles/What_Is_Truth_0x3f_.aspx .

More seriously, though, shouldn't this just say FAILURE, perhaps with
further explanation attached?

- Josh Triplett
