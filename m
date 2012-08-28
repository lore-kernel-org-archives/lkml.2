Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2H1Ubw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:31:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62494 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2H1Ubv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:31:51 -0400
Date: Tue, 28 Aug 2012 13:31:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Message-ID: <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346175456-1572-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Aug 28, 2012 at 10:37:30AM -0700, Kent Overstreet wrote:
> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> was open coding it, by doing a bio_init() and resetting bi_destructor.

Better to explain why some bio fields are re-ordered and why that
shouldn't make things worse cacheline-wise?

> +void bio_reset(struct bio *bio)
> +{

Function comment explaining what it does and why it does what it does
with integrity / bi_css / whatnot?

> +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> +
> +	if (bio_integrity(bio))
> +		bio_integrity_free(bio, bio->bi_pool);
> +
> +	bio_disassociate_task(bio);

Is this desirable?  Why?

Thanks.

-- 
tejun
