Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2BFRf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:35:56 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56270
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797Ab2BFRfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:35:54 -0500
Date: Mon, 6 Feb 2012 12:35:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH V2 2/2] hfsplus: Add an ioctl to bless files
Message-ID: <20120206173553.GB1135@infradead.org>
References: <1328215191-4201-1-git-send-email-mjg@redhat.com>
 <1328215191-4201-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328215191-4201-2-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+#define HFSPLUS_IOC_BLESS              _IO('f', 0x20)

I'd probably move this to fs.h and follow the numbering there,
otherwise we are bound to run into conflicts.

> +static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)

Care to add a little comment on what this ioctl does, bless is a bit
of a generic name.

> +{
> +	struct inode *inode = file->f_dentry->d_inode;

Please use file->f_path.dentry instead of the f_dentry define, please.

Also given that we use the dentry almost as often I'd pull it into a
local variable as well.

> +	mutex_lock(&sbi->vh_mutex);
> +	vh->finder_info[0] = bvh->finder_info[0] =
> +		cpu_to_be32(parent_ino(file->f_dentry));
> +	vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(inode->i_ino);
> +	vh->finder_info[5] = bvh->finder_info[5] =
> +		cpu_to_be32(parent_ino(file->f_dentry));

Any idea why we write the parent twice?



Not directly relevant, but where do you plan to put the userspace to
call this ioctl?
