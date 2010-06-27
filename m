Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0F0JkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 05:40:20 -0400
Received: from verein.lst.de ([213.95.11.210]:34954 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0F0JkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 05:40:18 -0400
Date: Sun, 27 Jun 2010 11:39:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard requests
Message-ID: <20100627093955.GD12016@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 03:56:51PM -0400, Mike Snitzer wrote:
> Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> means bio_has_data() will not be true until the SCSI layer adds the
> payload to the discard request via blk_add_request_payload.
> 
> bio_{enable,disable}_inline_vecs are not expected to be widely used so
> they were exported using EXPORT_SYMBOL_GPL.

Why do we need them exported at all?  Also some comments on these
functions would be useful.

Otherwise it looks good to me.

