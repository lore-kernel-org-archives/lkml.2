Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab2CSG5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:57:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52106
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab2CSG5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:57:44 -0400
Date: Mon, 19 Mar 2012 02:57:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] fs: Remove bogus wait in write_inode_now()
Message-ID: <20120319065739.GA11113@infradead.org>
References: <1331283748-12959-1-git-send-email-jack@suse.cz>
 <1331283748-12959-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331283748-12959-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 10:02:25AM +0100, Jan Kara wrote:
> inode_sync_wait() in write_inode_now() is just bogus. That function waits for
> I_SYNC bit to be cleared but writeback_single_inode() clears the bit on return
> so the wait is effectivelly a nop unless someone else submits the inode for
> writeback again. All the waiting write_inode_now() needs is achieved by using
> WB_SYNC_ALL writeback mode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Loks good - I have the same in my patchkit to kill write_inode_now
(which I really need to get out soon).

Signed-off-by: Christoph Hellwig <hch@lst.de>
