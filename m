Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0F0OBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 10:01:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab0F0OBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 10:01:18 -0400
Date: Sun, 27 Jun 2010 10:00:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
Message-ID: <20100627140045.GC3970@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-2-git-send-email-snitzer@redhat.com>
 <20100627093955.GD12016@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100627093955.GD12016@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27 2010 at  5:39am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Sat, Jun 26, 2010 at 03:56:51PM -0400, Mike Snitzer wrote:
> > Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> > means bio_has_data() will not be true until the SCSI layer adds the
> > payload to the discard request via blk_add_request_payload.
> > 
> > bio_{enable,disable}_inline_vecs are not expected to be widely used so
> > they were exported using EXPORT_SYMBOL_GPL.
> 
> Why do we need them exported at all?

Hmm, good point!

> Also some comments on these functions would be useful.

OK.

> Otherwise it looks good to me.

Thanks, I'll get a v2 of this patch out. 
