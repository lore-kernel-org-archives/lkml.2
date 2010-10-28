Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab0J1OYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:24:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0J1OYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:24:16 -0400
Date: Thu, 28 Oct 2010 10:24:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] fs: move i_hash out from under inode_lock
Message-ID: <20101028142414.GA28390@infradead.org>
References: <1288266161-28897-1-git-send-email-david@fromorbit.com>
 <1288266161-28897-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288266161-28897-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -925,8 +934,8 @@ static struct inode *get_new_inode(struct super_block *sb,
>  			inode->i_state = I_NEW;
>  			spin_unlock(&inode->i_lock);
>  			hlist_add_head(&inode->i_hash, head);
> +			spin_unlock(&inode_hash_lock);
>  			inode_sb_list_add(inode);
> -			spin_unlock(&inode_lock);

Al said he wanted to have the sb lock nest inside the hash lock for now
I think.  Doubt it matters much, but it keeps the behaviour that we
can't look up an inode which is not added to the per-sb list yet.

After that a better patch description might be:

	"rename inode_lock to inode_hash_lock"

as the inode_lock coverage after the previous patches should be 100%
identical to the new hash lock.
