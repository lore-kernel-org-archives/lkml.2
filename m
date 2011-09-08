Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1IICCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:02:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34664 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1IICCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:02:03 -0400
Date: Thu, 8 Sep 2011 10:26:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] cleanup: no need to call rcu_lock in
 sock_update_classid()
Message-ID: <20110908172635.GK2671@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1315276536-10910-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315276536-10910-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11090902-5112-0000-0000-00000035310E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 11:35:36PM -0300, Glauber Costa wrote:
> There is no need to protect
> 
> According to the all-knowing git log, this was inserted here to prevent a
> warning in commit 1144182a. But 3fb5a991 also does that in a different place.
> >From reading it, I believe they are fixing the same warning, so no need
> for both.

Good catch!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: David S. Miller <davem@davemloft.net>
> ---
>  net/core/sock.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index bc745d0..3449df8 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1107,9 +1107,7 @@ void sock_update_classid(struct sock *sk)
>  {
>  	u32 classid;
> 
> -	rcu_read_lock();  /* doing current task, which cannot vanish. */
>  	classid = task_cls_classid(current);
> -	rcu_read_unlock();
>  	if (classid && classid != sk->sk_classid)
>  		sk->sk_classid = classid;
>  }
> -- 
> 1.7.6
> 

