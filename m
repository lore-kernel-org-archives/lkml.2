Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0JAGI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:08:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0JAGI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:08:27 -0400
Date: Fri, 1 Oct 2010 02:08:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/17] fs: Make last_ino, iunique independent of
 inode_lock
Message-ID: <20101001060827.GI32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-10-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:41PM +1000, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Before removing the inode_lock, we need to make the last_ino  and iunique
> counters independent of the inode_lock. last_ino can be trivially converted to
> an atomic variable, while the iunique counter needs a new lock nested inside
> the inode_lock to provide the same protection that the inode_lock previously
> provided.

Given that last_ino becomes a per-cpu construct only a few patches later
I think there's no point to make it an atomic_t here - just reorder the
per-cpu patch before the inode_lock removal.

