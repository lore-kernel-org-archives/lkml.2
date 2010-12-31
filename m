Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0LaOYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:24:44 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:43320
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753528Ab0LaOYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:24:43 -0500
Date: Fri, 31 Dec 2010 14:25:36 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH] fix freeing user_struct in user cache
Message-ID: <20101231142536.GB22593@mail.hallyn.com>
References: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
 <20101224035523.GC25057@suse.de>
 <AANLkTi=PwGXTKKyXDA1sckosbGmeo+D0bGuXt3Jb-ttc@mail.gmail.com>
 <20101224171459.GA31815@suse.de>
 <AANLkTimvjGvoSs2T0BmdaMdKyAsnttSXXRiJp0wB4+bG@mail.gmail.com>
 <20101229030936.GA9275@mail.hallyn.com>
 <AANLkTinD9OUjmYpUwnCX47YeL6-DRwWyw=pwmiiZJQNH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinD9OUjmYpUwnCX47YeL6-DRwWyw=pwmiiZJQNH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Hillf Danton (dhillf@gmail.com):
> When racing on adding into user cache, the new allocated from mm slab
> is freed without putting user namespace.
> 
> Since the user namespace is already operated by getting, putting has
> to be issued.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

which was previously

> Acked-by: Serge Hallyn <serge@hallyn.com>

thanks again, Hillf.

> ---
> 
> --- a/kernel/user.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/kernel/user.c	2010-12-23 20:42:00.000000000 +0800
> @@ -158,6 +158,7 @@ struct user_struct *alloc_uid(struct use
>  		spin_lock_irq(&uidhash_lock);
>  		up = uid_hash_find(uid, hashent);
>  		if (up) {
> +			put_user_ns(ns);
>  			key_put(new->uid_keyring);
>  			key_put(new->session_keyring);
>  			kmem_cache_free(uid_cachep, new);
