Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0JHJtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:49:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60398 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0JHJtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:49:16 -0400
Date: Fri, 8 Oct 2010 10:49:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008094915.GZ19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-12-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:25PM +1100, Dave Chinner wrote:
> -			if (hlist_unhashed(&inode->i_hash))
> +			if (hlist_bl_unhashed(&inode->i_hash))

That, OTOH, begs for (inlined) helper with more readable name.

>  	HFS_I(inode)->rsrc_inode = dir;
>  	HFS_I(dir)->rsrc_inode = inode;
>  	igrab(dir);
> -	hlist_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
> +	hlist_bl_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
>  	mark_inode_dirty(inode);

Lovely.  What protects that list?  Same question for hfsplus...
