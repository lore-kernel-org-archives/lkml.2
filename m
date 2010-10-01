Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0JAGGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:06:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0JAGGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:06:08 -0400
Date: Fri, 1 Oct 2010 02:06:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] fs: Factor inode hash operations into functions
Message-ID: <20101001060607.GG32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-12-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:43PM +1000, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Before we can replace the inode hash locking with a more scalable
> mechanism, we need to remove external users of the inode_hash_lock.
> Make it private by adding a function __remove_inode_hash that can be
> called by filesystems instead of open-coding their own inode hash
> removal operations.

I like the factoring, but this changelog is misleading.  At least in
this series no new user of __remove_inode_hash appears, and I'm not sure
where it would appear anyway.  Just making the function global without
actually exporting it is not helping external filesystems anyway.  For
now it can simply be made static.

