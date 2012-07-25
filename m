Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2GYMEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:04:06 -0400
Received: from natasha.panasas.com ([67.152.220.90]:36070 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2GYMEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:04:04 -0400
Message-ID: <500FE092.6010108@panasas.com>
Date: Wed, 25 Jul 2012 15:03:30 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>, <tj@kernel.org>, <axboe@kernel.dk>,
        <agk@redhat.com>, <neilb@suse.de>, <drbd-dev@lists.linbit.com>,
        <vgoyal@redhat.com>, <mpatocka@redhat.com>, <sage@newdream.net>,
        <yehuda@hq.newdream.net>
Subject: Re: [PATCH v4 09/12] block: Rework bio_pair_split()
References: <1343160689-12378-1-git-send-email-koverstreet@google.com> <1343160689-12378-10-git-send-email-koverstreet@google.com>
In-Reply-To: <1343160689-12378-10-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 11:11 PM, Kent Overstreet wrote:

> This changes bio_pair_split() to use the new bio_split() underneath,
> which gets rid of the single page bio limitation. The various callers
> are fixed up for the slightly different struct bio_pair, and to remove
> the unnecessary checks.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

<snip>

> +
> +extern struct bio *bio_split(struct bio *bio, int sectors,
> +			     gfp_t gfp, struct bio_set *bs);


nit:

Just for taking pride in my work, I'd move this extern declaration
to the previous patch that actually introduces it.

Cheers
Boaz

>  extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
>  extern void bio_pair_release(struct bio_pair *dbio);
>  
> @@ -512,7 +514,6 @@ extern int bio_integrity_prep(struct bio *);
>  extern void bio_integrity_endio(struct bio *, int);
>  extern void bio_integrity_advance(struct bio *, unsigned int);
>  extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
> -extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
>  extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
>  extern int bioset_integrity_create(struct bio_set *, int);
>  extern void bioset_integrity_free(struct bio_set *);
> @@ -556,12 +557,6 @@ static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
>  	return 0;
>  }
>  
> -static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
> -				       int sectors)
> -{
> -	return;
> -}
> -
>  static inline void bio_integrity_advance(struct bio *bio,
>  					 unsigned int bytes_done)
>  {


