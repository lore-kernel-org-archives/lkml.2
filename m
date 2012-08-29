Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2H2RQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:16:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2H2RQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:16:26 -0400
Message-ID: <503E4E5F.5060003@kernel.dk>
Date: Wed, 29 Aug 2012 10:16:15 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix bad range check in bio_sector_offset
References: <yq1a9xesxll.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1a9xesxll.fsf@sermon.lab.mkp.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-28 11:03, Martin K. Petersen wrote:
> 
> DM would occasionally end up splitting data integrity-enabled requests
> incorrectly. The culprit was a bad range check in bio_sector_offset.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: <stable@vger.kernel.org>
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 9bfade8..b9a6744 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1552,8 +1552,8 @@ sector_t bio_sector_offset(struct bio *bio, unsigned short index,
>  	sector_sz = queue_logical_block_size(bio->bi_bdev->bd_disk->queue);
>  	sectors = 0;
>  
> -	if (index >= bio->bi_idx)
> -		index = bio->bi_vcnt - 1;
> +	if (index > bio->bi_vcnt)
> +		return 0;
>  
>  	__bio_for_each_segment(bv, bio, i, 0) {
>  		if (i == index) {

Good catch, merged.

-- 
Jens Axboe

