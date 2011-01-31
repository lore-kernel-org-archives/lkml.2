Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1AaH7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:59:06 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55658 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1AaH7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:59:04 -0500
Date: Sun, 30 Jan 2011 23:59:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [Patch] rcupdate: remove dead code
Message-ID: <20110131075900.GC2145@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1296382988-16564-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296382988-16564-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 06:23:08PM +0800, Amerigo Wang wrote:
> DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT, so #ifndef CONFIG_PREEMPT
> is totally useless in kernel/rcupdate.c.

Queued, thank you, Amerigo!

I added a patch on top of this commenting why DEBUG_OBJECTS_RCU_HEAD
is disallowed if !PREEMPT, FYI.

							Thanx, Paul

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> 
> ---
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index a23a57a..afd21d1 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -215,10 +215,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
>  		 * If we detect that we are nested in a RCU read-side critical
>  		 * section, we should simply fail, otherwise we would deadlock.
>  		 */
> -#ifndef CONFIG_PREEMPT
> -		WARN_ON(1);
> -		return 0;
> -#else
>  		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
>  		    irqs_disabled()) {
>  			WARN_ON(1);
> @@ -229,7 +225,6 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
>  		rcu_barrier_bh();
>  		debug_object_free(head, &rcuhead_debug_descr);
>  		return 1;
> -#endif
>  	default:
>  		return 0;
>  	}
