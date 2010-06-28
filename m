Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0F1MeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:34:16 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33690 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0F1MeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:34:14 -0400
Message-ID: <4C2896C6.9030607@kernel.dk>
Date: Mon, 28 Jun 2010 14:34:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com>
In-Reply-To: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-26 21:56, Mike Snitzer wrote:
> Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> means bio_has_data() will not be true until the SCSI layer adds the
> payload to the discard request via blk_add_request_payload.

Sorry, this looks horrible. What is the point of this?!

> bio_{enable,disable}_inline_vecs are not expected to be widely used so
> they were exported using EXPORT_SYMBOL_GPL.

Never export anything that doesn't have an in-kernel modular user.

> This patch avoids the need for the following VM accounting fix for
> discards: http://lkml.org/lkml/2010/6/23/361
> NOTE: Jens, you said you applied Tao Ma's fix but I cannot see it in
> your linux-2.6-block's for-next or for-2.6.36... as such I didn't revert
> it in this patch.

It's in the for-linus branch, that is stuff headed for the current
kernel.

-- 
Jens Axboe

