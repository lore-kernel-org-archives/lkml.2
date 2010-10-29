Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0J2Epx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:45:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0J2Eps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:45:48 -0400
Date: Fri, 29 Oct 2010 05:45:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] fs: factor inode disposal
Message-ID: <20101029044547.GN19804@ZenIV.linux.org.uk>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
 <1288322620-8566-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288322620-8566-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 02:23:34PM +1100, Dave Chinner wrote:
>  		/*
> -		 * Move the inode off the IO lists and LRU once I_FREEING is
> -		 * set so that it won't get moved back on there if it is dirty.
> +		 * Move the inode off the LRU once I_FREEING is set so that it
> +		 * won't get moved back on.
>  		 */
>  		list_move(&inode->i_lru, &dispose);
> -		list_del_init(&inode->i_wb_list);

a) OK, so you've killed that list_del_init().  Good.
b) The comment is completely misleading.  We don't put I_FREEING inodes back on
LRU (or IO) lists, no matter where we find them.  What's happening here is
that we are collecting inodes to evict, period.

> -		 * Move the inode off the IO lists and LRU once I_FREEING is
> -		 * set so that it won't get moved back on there if it is dirty.
> +		 * Move the inode off the LRU once I_FREEING is
> +		 * set so that it won't get moved back on.

Ditto.

>  		/*
> -		 * Move the inode off the IO lists and LRU once I_FREEING is
> -		 * set so that it won't get moved back on there if it is dirty.
> +		 * Move the inode off the LRU once I_FREEING is
> +		 * set so that it won't get moved back on.
>  		 */
Ditto.
