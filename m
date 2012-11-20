Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2KTR5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:57:51 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46640 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2KTR5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:57:50 -0500
Date: Tue, 20 Nov 2012 09:57:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/58] RCU: Make rcu_is_cpu_rrupt_from_idle helper
 functions static
Message-ID: <20121120175722.GS2829@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
 <1353302917-13995-14-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353302917-13995-14-git-send-email-josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112017-8974-0000-0000-0000117A9FFB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00193011; UDB=6.00043738; UTC=2012-11-20
 17:57:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 09:27:52PM -0800, Josh Triplett wrote:
> Both rcutiny and rcutree define a helper funtion
> rcu_is_cpu_rrupt_from_idle, each used exactly once, later in the same
> file.  Declare these helper functions static.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Hard to argue with this one!  I forward-ported to current -rcu and
queued for v3.9.

							Thanx, Paul

> ---
>  kernel/rcutiny.c |    2 +-
>  kernel/rcutree.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index e4c6a59..0e506c3 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -193,7 +193,7 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
>   * interrupts don't count, we must be running at the first interrupt
>   * level.
>   */
> -int rcu_is_cpu_rrupt_from_idle(void)
> +static int rcu_is_cpu_rrupt_from_idle(void)
>  {
>  	return rcu_dynticks_nesting <= 0;
>  }
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 74df86b..70d9b6e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -783,7 +783,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
>   * interrupt from idle, return true.  The caller must have at least
>   * disabled preemption.
>   */
> -int rcu_is_cpu_rrupt_from_idle(void)
> +static int rcu_is_cpu_rrupt_from_idle(void)
>  {
>  	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
>  }
> -- 
> 1.7.10.4
> 

