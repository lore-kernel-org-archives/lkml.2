Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0JAFtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:49:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0JAFtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:49:09 -0400
Date: Fri, 1 Oct 2010 01:49:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] fs: icache lock s_inodes list
Message-ID: <20101001054909.GB32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:34PM +1000, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> To allow removal of the inode_lock, we first need to protect the
> superblock inode list with it's own lock instead of using the
> inode_lock for this purpose. Nest the new sb_inode_list_lock inside
> the inode_lock around the list operations it needs to protect.

Is there any good reason not to make this lock per-superblock?

