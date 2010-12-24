Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0LXDzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 22:55:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab0LXDzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 22:55:48 -0500
Date: Thu, 23 Dec 2010 19:55:23 -0800
From: Greg KH <gregkh@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix freeing user_struct in user cache
Message-ID: <20101224035523.GC25057@suse.de>
References: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 08:52:34PM +0800, Hillf Danton wrote:
> When racing on adding into user cache, the new allocated from mm slab
> is freed without putting user namespace.
> 
> Since the user namespace is already operated by getting, putting has
> to be issued.
> 
> btw, it could be freed out of lock?
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
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

Hm, are you sure about this?  Also, why send this to me, did I last
touch this?

confused,

greg k-h
