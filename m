Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0JUBmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:42:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0JUBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:45 -0400
Date: Wed, 20 Oct 2010 21:41:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] fs: Clean up inode reference counting
Message-ID: <20101021014143.GA17797@infradead.org>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287622186-1935-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> index 874972d..d1c2f08 100644
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -390,7 +390,7 @@ static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
>  	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
>  	BUG_ON(error);
>  	if (!nfsi->npages) {
> -		igrab(inode);
> +		iref(inode);
>  		if (nfs_have_delegation(inode, FMODE_WRITE))
>  			nfsi->change_attr++;

This still needs to be an unlocked increment, as point out in reply to
the last iteration.

