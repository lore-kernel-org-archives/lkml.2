Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1EKQkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:40:24 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:40386 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab1EKQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:40:18 -0400
Date: Wed, 11 May 2011 15:03:39 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Christoph Hellwig <hch@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/14] HPFS: Implement fsync for hpfs
In-Reply-To: <20110510080349.GC13420@infradead.org>
Message-ID: <alpine.DEB.2.00.1105111502300.23587@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1105082029340.7013@artax.karlin.mff.cuni.cz> <20110510080349.GC13420@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 May 2011, Christoph Hellwig wrote:

> On Sun, May 08, 2011 at 08:44:19PM +0200, Mikulas Patocka wrote:
> > Index: linux-2.6.39-rc5-fast/fs/hpfs/file.c
> > ===================================================================
> > --- linux-2.6.39-rc5-fast.orig/fs/hpfs/file.c	2011-05-05 01:02:43.000000000 +0200
> > +++ linux-2.6.39-rc5-fast/fs/hpfs/file.c	2011-05-05 01:02:56.000000000 +0200
> > @@ -20,8 +20,8 @@ static int hpfs_file_release(struct inod
> >  
> >  int hpfs_file_fsync(struct file *file, int datasync)
> >  {
> > -	/*return file_fsync(file, datasync);*/
> > -	return 0; /* Don't fsync :-) */
> > +	struct inode *inode = file->f_mapping->host;
> > +	return sync_blockdev(inode->i_sb->s_bdev);
> 
> So you push all dirty data into buffers immediately and don't have
> anything else to write back?

Data are written in vfs_fsync_range ... so fsync should write just 
metadata. I write all metadata, HPFS is not performance-sensitive anyway, 
so there is no need to differentiate metadata for a specific file.

Mikulas
