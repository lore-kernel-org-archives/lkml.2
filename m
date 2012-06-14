Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2FNRav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:30:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38716 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2FNRau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:30:50 -0400
Date: Thu, 14 Jun 2012 10:29:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-kernel@vger.kernel.org, jengelh@medozas.de
Subject: Re: [PATCH] rcu: remove unused __kfree_rcu inline functions
Message-ID: <20120614172948.GM2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339674794-17517-1-git-send-email-ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339674794-17517-1-git-send-email-ablock84@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061417-5112-0000-0000-000009085FE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:53:14PM +0200, Alexander Block wrote:
> Patch "rcu: Make __kfree_rcu() less dependent on compiler choice"
> from Jan Engelhardt intended to replace the inline functions
> __kfree_rcu and __is_kfree_rcu_offset with macros.
> 
> Unfortunately, the patch only added the new macros but did not
> remove the old inline functions. This patch removes them finally.
> 
> With the unused functions still being around, module builds with
> -O0 still fail.

Good stuff, but someone beat you to it.  Please see commmit 3855cf05
(Remove function versions of __kfree_rcu and __is_kfree_rcu_offset) in:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

							Thanx, Paul

> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> ---
>  include/linux/rcupdate.h |   18 ------------------
>  1 file changed, 18 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 26d1a47..0ae2c55 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -906,24 +906,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>  #define RCU_INIT_POINTER(p, v) \
>  		p = (typeof(*v) __force __rcu *)(v)
> 
> -static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
> -{
> -	return offset < 4096;
> -}
> -
> -static __always_inline
> -void __kfree_rcu(struct rcu_head *head, unsigned long offset)
> -{
> -	typedef void (*rcu_callback)(struct rcu_head *);
> -
> -	BUILD_BUG_ON(!__builtin_constant_p(offset));
> -
> -	/* See the kfree_rcu() header comment. */
> -	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
> -
> -	kfree_call_rcu(head, (rcu_callback)offset);
> -}
> -
>  /*
>   * Does the specified offset indicate that the corresponding rcu_head
>   * structure can be handled by kfree_rcu()?
> -- 
> 1.7.10
> 

