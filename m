Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0IFQOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:14:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44875 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0IFQOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:14:02 -0400
Date: Mon, 6 Sep 2010 09:13:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Triplett <josh@joshtriplett.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 14/14] kernel/: Removing undead ifdef
 CONFIG_DEBUG_LOCK_ALLOC
Message-ID: <20100906161355.GE2463@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <dc92672f508081ee95b603244e992d2f3119c451.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc92672f508081ee95b603244e992d2f3119c451.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 04:37:12PM +0200, Christian Dietrich wrote:
> The CONFIG_DEBUG_LOCK_ALLOC ifdef isn't necessary at this point, because it is
> checked in an outer ifdef level already and has no effect here.

Good catch, queued!

							Thanx, Paul

> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  kernel/srcu.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index 2980da3..c71e075 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -46,11 +46,9 @@ static int init_srcu_struct_fields(struct srcu_struct *sp)
>  int __init_srcu_struct(struct srcu_struct *sp, const char *name,
>  		       struct lock_class_key *key)
>  {
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	/* Don't re-initialize a lock while it is held. */
>  	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
>  	lockdep_init_map(&sp->dep_map, name, key, 0);
> -#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  	return init_srcu_struct_fields(sp);
>  }
>  EXPORT_SYMBOL_GPL(__init_srcu_struct);
> -- 
> 1.7.0.4
> 
