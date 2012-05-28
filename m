Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2E1QMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab2E1QMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:12:41 -0400
Date: Mon, 28 May 2012 12:12:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Kent Overstreet <koverstreet@google.com>
cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 08/16] block: Rework bio splitting
In-Reply-To: <1337977539-16977-9-git-send-email-koverstreet@google.com>
Message-ID: <Pine.LNX.4.64.1205281210450.3913@file.rdu.redhat.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-9-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2012, Kent Overstreet wrote:

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f8b6f14..0062326 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1001,15 +1001,9 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  		      > chunk_sects &&
>  		    conf->near_copies < conf->raid_disks)) {
>  		struct bio_pair *bp;
> -		/* Sanity check -- queue functions should prevent this happening */
> -		if (bio->bi_vcnt != 1 ||
> -		    bio->bi_idx != 0)
> -			goto bad_map;
> -		/* This is a one page bio that upper layers
> -		 * refuse to split for us, so we need to split it.
> -		 */
> +

That "Sanity check" should be removed from drivers/md/raid0.c too. Your 
patch only removes it from raid10.

Mikulas
