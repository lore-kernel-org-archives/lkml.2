Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0L2PMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 10:12:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0L2PMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 10:12:47 -0500
Date: Wed, 29 Dec 2010 10:12:46 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20101229151246.GA22033@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218015117.759480620@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - the sync_inodes_sb export removal looks fine to, but should be a
   separate patch with a good changelog
 - why is the sync_inode_metadata wait parameter removed?  Especially
   as we would need it for some callers that need to be converted to it.
   E.g. in this patch converts writeback_inode from non-blocking to
   blocking behaviour.
 - except for that the sync_inode() removal is fine, I had planned for
   that already.  But again, please a separate and well-documented
   patch.

As for the actualy sync_inode operation:  I don't think it's helpful.
The *_sync_inode helpers in ext2 and fat are fine, but there's little
point in going through an iops vector for it.  Also adding the file
syncing really complicates the API for now reason, epecially with
the range interface.

