Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1ESLWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:22:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13734 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab1ESLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:22:47 -0400
Date: Thu, 19 May 2011 13:15:24 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: samsonov@krista.ru
cc: linux-kernel@vger.kernel.org
Subject: Re: Some patches for ppp_generic.c and proc/base.c
In-Reply-To: <20110519143213.094da1eb@wks1198.krista.ru>
Message-ID: <alpine.LNX.2.00.1105191313390.22490@swampdragon.chaosbits.net>
References: <20110519143213.094da1eb@wks1198.krista.ru>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, samsonov@krista.ru wrote:

> Good day!
> I mean that /proc file permission for process information must be
> secure:
> 

I'm not going to comment on whether or not changing the mode is 
appropriate, but there are a few other details I will comment on:

[...]
> --- ./linux-2.6.33.4.orig/drivers/net/ppp_generic.c	2010-05-13 02:04:27.000000000 +0400
> +++ ./linux-2.6.33.4/drivers/net/ppp_generic.c	2011-05-10 13:51:11.909607463 +0400
> @@ -366,8 +366,8 @@
>  	/*
>  	 * This could (should?) be enforced by the permissions on /dev/ppp.
>  	 */
> -	if (!capable(CAP_NET_ADMIN))
> -		return -EPERM;
> +//	if (!capable(CAP_NET_ADMIN))
> +//		return -EPERM;

Don't just comment out lines. If they should go away, just remove them.


[...]
> --- ./linux-2.6.33.4.orig/fs/attr.c	2010-05-13 02:04:27.000000000 +0400
> +++ ./linux-2.6.33.4/fs/attr.c	2011-05-10 14:25:57.727062904 +0400
> @@ -35,11 +35,10 @@
>  
>  	/* Make sure caller can chgrp. */
>  	if ((ia_valid & ATTR_GID) &&
> -	    (current_fsuid() != inode->i_uid ||
> -	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
> -	    !capable(CAP_CHOWN))
> +	    !(in_group_p(attr->ia_gid) && is_owner_or_cap(inode)))
>  		goto error;
>  
> +
Why are you adding an extra blank line here? Seems rather pointless.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

