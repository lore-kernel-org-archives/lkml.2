Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0IQDTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:19:21 -0400
Received: from verein.lst.de ([213.95.11.210]:38914 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab0IQDTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:19:20 -0400
Date: Fri, 17 Sep 2010 05:19:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20100917031911.GA25217@lst.de>
References: <20100917113738.f8ecaf63.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917113738.f8ecaf63.sfr@canb.auug.org.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:37:38AM +1000, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/ocfs2/file.c: In function 'ocfs2_sync_file':
> fs/ocfs2/file.c:191: error: 'BLKDEV_IFL_WAIT' undeclared (first use in this function)
> fs/ocfs2/file.c:191: error: too many arguments to function 'blkdev_issue_flush'
> 
> Caused by commit dd3932eddf428571762596e17b65f5dc92ca361b ("block: remove
> BLKDEV_IFL_WAIT") interacting with commit
> 04eda1a18019bb387dc7e97ee99979dd88dc608a ("ocfs2: Flush drive's caches on
> fdatasync") that entered Linus' tree before v2.6.36-rc4.


Justremove the last argument for blkdev_issue_flush and it'll be fine.
Unfortunately Jens' for-next branch which I based the patch again
doesn't include the ocfs2 commit yet.
