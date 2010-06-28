Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0F1KeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:34:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:38911 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0F1KeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:34:15 -0400
Date: Mon, 28 Jun 2010 19:33:34 +0900
To: snitzer@redhat.com
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
References: <20100622180029.GA15950@redhat.com>
	<1277582211-10725-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100628193122L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 28 Jun 2010 19:33:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 15:56:51 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> means bio_has_data() will not be true until the SCSI layer adds the
> payload to the discard request via blk_add_request_payload.
> 
> bio_{enable,disable}_inline_vecs are not expected to be widely used so
> they were exported using EXPORT_SYMBOL_GPL.
> 
> This patch avoids the need for the following VM accounting fix for
> discards: http://lkml.org/lkml/2010/6/23/361

Why do we need to avoid the above fix? Surely, the above fix is hacky
but much simpler than this patch.


> NOTE: Jens, you said you applied Tao Ma's fix but I cannot see it in
> your linux-2.6-block's for-next or for-2.6.36... as such I didn't revert
> it in this patch.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c    |    2 ++
>  block/blk-lib.c     |    2 +-
>  fs/bio.c            |   19 +++++++++++++++++--
>  include/linux/bio.h |    3 +++
>  4 files changed, 23 insertions(+), 3 deletions(-)
