Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1F2SJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:09:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47099
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab1F2SJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:09:40 -0400
Date: Wed, 29 Jun 2011 14:09:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110629180939.GA9934@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309370716-12235-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -int blkdev_fsync(struct file *filp, int datasync)
> +int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
>  {
>  	struct inode *bd_inode = filp->f_mapping->host;
>  	struct block_device *bdev = I_BDEV(bd_inode);
> @@ -389,14 +389,10 @@ int blkdev_fsync(struct file *filp, int datasync)
>  	 * i_mutex and doing so causes performance issues with concurrent
>  	 * O_SYNC writers to a block device.
>  	 */
> -	mutex_unlock(&bd_inode->i_mutex);
> -

Now that i_mutex on entry isn't held the comment above can be removed.

