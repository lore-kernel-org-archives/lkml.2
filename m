Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0JAGGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:06:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0JAGGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:06:51 -0400
Date: Fri, 1 Oct 2010 02:06:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] fs: icache lock inode hash
Message-ID: <20101001060650.GH32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:35PM +1000, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Currently the inode hash lists are protected by the inode_lock. To
> allow removal of the inode_lock, we need to protect the inode hash
> table lists with a new lock. Nest the new inode_hash_lock inside the
> inode_lock to protect the hash lists.

There is no reason to make inode_hash_lock global, it's only used inside
inode.c

