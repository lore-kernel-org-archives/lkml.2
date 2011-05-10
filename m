Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1EJIDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:03:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36716 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab1EJIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:03:52 -0400
Date: Tue, 10 May 2011 04:03:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/14] HPFS: Implement fsync for hpfs
Message-ID: <20110510080349.GC13420@infradead.org>
References: <alpine.DEB.2.00.1105082029340.7013@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105082029340.7013@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 08:44:19PM +0200, Mikulas Patocka wrote:
> Index: linux-2.6.39-rc5-fast/fs/hpfs/file.c
> ===================================================================
> --- linux-2.6.39-rc5-fast.orig/fs/hpfs/file.c	2011-05-05 01:02:43.000000000 +0200
> +++ linux-2.6.39-rc5-fast/fs/hpfs/file.c	2011-05-05 01:02:56.000000000 +0200
> @@ -20,8 +20,8 @@ static int hpfs_file_release(struct inod
>  
>  int hpfs_file_fsync(struct file *file, int datasync)
>  {
> -	/*return file_fsync(file, datasync);*/
> -	return 0; /* Don't fsync :-) */
> +	struct inode *inode = file->f_mapping->host;
> +	return sync_blockdev(inode->i_sb->s_bdev);

So you push all dirty data into buffers immediately and don't have
anything else to write back?

