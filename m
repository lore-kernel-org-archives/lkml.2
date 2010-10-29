Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0J2FRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:17:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58019 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab0J2FRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:17:06 -0400
Date: Fri, 29 Oct 2010 06:17:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] fs: Clean up documentation references to inode_lock
Message-ID: <20101029051706.GP19804@ZenIV.linux.org.uk>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
 <1288322620-8566-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288322620-8566-9-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 02:23:40PM +1100, Dave Chinner wrote:
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3d4df44..ae5b156 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -80,7 +80,7 @@
>   *  ->i_mutex
>   *    ->i_alloc_sem             (various)
>   *
> - *  ->inode_lock
> + *  ->inode_wb_list_lock
Huh?  Please, kill -> in these two lines, while we are at it.
>   *    ->sb_lock			(fs/fs-writeback.c)
>   *    ->mapping->tree_lock	(__sync_single_inode)
>   *
> @@ -98,8 +98,10 @@
>   *    ->zone.lru_lock		(check_pte_range->isolate_lru_page)
>   *    ->private_lock		(page_remove_rmap->set_page_dirty)
>   *    ->tree_lock		(page_remove_rmap->set_page_dirty)
> - *    ->inode_lock		(page_remove_rmap->set_page_dirty)
> - *    ->inode_lock		(zap_pte_range->set_page_dirty)
> + *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
> + *    ->inode_wb_list_lock	(page_remove_rmap->set_page_dirty)
> + *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
> + *    ->inode_wb_list_lock	(zap_pte_range->set_page_dirty)

Again, bogus ->
