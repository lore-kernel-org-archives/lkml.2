Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2JFS7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:59:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51370 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2JFS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:59:27 -0400
Date: Sat, 6 Oct 2012 19:59:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: ????????? <jaegeuk.kim@samsung.com>
Cc: "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Message-ID: <20121006185921.GI2616@ZenIV.linux.org.uk>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 09:03:09PM +0900, ????????? wrote:
> +static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> +						bool excl)
> +{
> +	struct super_block *sb = dir->i_sb;
> +	struct f2fs_sb_info *sbi = F2FS_SB(sb);
> +	struct inode *inode;
> +	nid_t ino = 0;
> +	int err;
> +
> +	if (dentry->d_name.len > F2FS_MAX_NAME_LEN)
> +		return -ENAMETOOLONG;

Pointless - failing those on ->lookup() with ENAMETOOLONG is enough.
The same goes for all entry creation methods.

> +	if (inode->i_nlink >= F2FS_LINK_MAX)
> +		return -EMLINK;

Just set ->s_max_links and be done with that.

> +	if (dir->i_nlink >= F2FS_LINK_MAX)
> +		return err;

Ditto.

> +		if (old_dir_entry) {
> +			err = -EMLINK;
> +			if (new_dir->i_nlink >= F2FS_LINK_MAX)
> +				goto out_dir;

... and here as well.
