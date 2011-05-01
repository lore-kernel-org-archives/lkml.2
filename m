Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab1EAPxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:53:42 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51094 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1EAPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:53:39 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 08:53:18 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 10/86] rcu: eliminate unused boosting
 statistics
Message-ID: <20110501155317.GG14829@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-10-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304256126-26015-10-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:20:50AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> The n_rcu_torture_boost_allocerror and n_rcu_torture_boost_afferror
> statistics are not actually incremented anymore, so eliminate them.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutorture.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 4d256db..62ec8ee6 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1067,7 +1067,7 @@ rcu_torture_printk(char *page)
>  	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
>  	cnt += sprintf(&page[cnt],
>  		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
> -		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
> +		       "rtmbe: %d rtbke: %ld rtbre: %ld "
>  		       "rtbf: %ld rtb: %ld nt: %ld",
>  		       rcu_torture_current,
>  		       rcu_torture_current_version,
> @@ -1078,8 +1078,6 @@ rcu_torture_printk(char *page)
>  		       atomic_read(&n_rcu_torture_mberror),
>  		       n_rcu_torture_boost_ktrerror,
>  		       n_rcu_torture_boost_rterror,
> -		       n_rcu_torture_boost_allocerror,
> -		       n_rcu_torture_boost_afferror,
>  		       n_rcu_torture_boost_failure,
>  		       n_rcu_torture_boosts,
>  		       n_rcu_torture_timers);

Shouldn't you eliminate the variables entirely, if they no longer track
anything?

- Josh Triplett
