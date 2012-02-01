Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2BAHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:23:20 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:41117 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2BAHXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:23:19 -0500
Date: Wed, 1 Feb 2012 18:23:07 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 6/6] cls_cgroup: remove redundant rcu_read_lock/unlock
Message-ID: <20120201072307.GA6358@gondor.apana.org.au>
References: <4F28E1D1.900@cn.fujitsu.com> <4F28E22A.703@cn.fujitsu.com> <1328080039.22641.2.camel@edumazet-laptop> <4F28E7A0.6000309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F28E7A0.6000309@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:20:00PM +0800, Li Zefan wrote:
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> >> diff --git a/net/core/sock.c b/net/core/sock.c
> >> index 213c856..c0bab23 100644
> >> --- a/net/core/sock.c
> >> +++ b/net/core/sock.c
> >> @@ -1160,9 +1160,7 @@ void sock_update_classid(struct sock *sk)
> >>  {
> >>  	u32 classid;
> >>  
> >> -	rcu_read_lock();  /* doing current task, which cannot vanish. */
> >>  	classid = task_cls_classid(current);
> >> -	rcu_read_unlock();
> >>  	if (classid && classid != sk->sk_classid)
> >>  		sk->sk_classid = classid;
> > 
> > Yes, this seems fine.
> > 
> > Then, I wonder why we do the "if (classid && classid != sk->sk_classid)"
> > 
> > before the :
> > 
> > 	sk->sk_classid = classid;
> > 
> > This seems unnecessary checks.
> > 
> 
> I was wondering about this too. He who added this may provide us with an
> answer.

Well writing a cache-line unnecessarily is bad.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
