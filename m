Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab0J0JGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:06:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760711Ab0J0JGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:06:45 -0400
Date: Wed, 27 Oct 2010 05:06:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] fs: factor inode disposal
Message-ID: <20101027090643.GC16443@infradead.org>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288153384-8878-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (!drop && (sb->s_flags & MS_ACTIVE)) {
> +		inode->i_state |= I_REFERENCED;
> +		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> +			inode_lru_list_add(inode);
> +		spin_unlock(&inode->i_lock);
> +		spin_unlock(&inode_lock);
> +		return;
> +	}
> +
>  	if (!drop) {
> -		if (sb->s_flags & MS_ACTIVE) {
> -			inode->i_state |= I_REFERENCED;
> -			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
> -				inode_lru_list_add(inode);
> -			}
> -			spin_unlock(&inode->i_lock);
> -			spin_unlock(&inode_lock);
> -			return;
> -		}

Btw, I'm really not sure what this change buys us.

