Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1ATUOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:14:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22336 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1ATUOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:14:11 -0500
Date: Thu, 20 Jan 2011 21:14:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <cdhmanning@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 09/10] Add yaffs2 file system: Linux glue code
In-Reply-To: <1294974369-31647-10-git-send-email-cdhmanning@gmail.com>
Message-ID: <alpine.LNX.2.00.1101202111450.11854@swampdragon.chaosbits.net>
References: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com> <1294974369-31647-10-git-send-email-cdhmanning@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Charles Manning wrote:

> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
...
> +static int yaffs_setxattr(struct dentry *dentry, const char *name,
> +                  const void *value, size_t size, int flags)
> +{
> +       struct inode *inode = dentry->d_inode;
> +       int error = 0;
> +       struct yaffs_dev *dev;
> +       struct yaffs_obj *obj = yaffs_inode_to_obj(inode);
> +

You only use the local variable 'inode' in the call to 
yaffs_inode_to_obj(), so you could get rid of that local variable and just 
do
    struct yaffs_obj *obj = yaffs_inode_to_obj(dentry->d_inode);
this applies to a few other function in this file as well.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

