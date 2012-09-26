Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2IZPQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:16:53 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:34313 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2IZPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:16:51 -0400
Date: Wed, 26 Sep 2012 17:16:48 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, linux-s390@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, neilb@suse.de,
        Jiri Kosina <jkosina@suse.cz>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Alasdair Kergon <agk@redhat.com>, tj@kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>, vgoyal@redhat.com,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [PATCH v3 06/26] block: Add bio_end_sector()
Message-ID: <20120926151648.GB17722@soda.linbit>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, axboe@kernel.dk, linux-s390@vger.kernel.org,
	Chris Mason <chris.mason@fusionio.com>, neilb@suse.de,
	Jiri Kosina <jkosina@suse.cz>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Alasdair Kergon <agk@redhat.com>, tj@kernel.org,
	Steven Whitehouse <swhiteho@redhat.com>, vgoyal@redhat.com,
	Lars Ellenberg <drbd-dev@lists.linbit.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-7-git-send-email-koverstreet@google.com>
 <20120925115452.GF8143@soda.linbit>
 <20120925220624.GC22647@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925220624.GC22647@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 03:06:24PM -0700, Kent Overstreet wrote:
> On Tue, Sep 25, 2012 at 01:54:52PM +0200, Lars Ellenberg wrote:
> > On Mon, Sep 24, 2012 at 03:34:46PM -0700, Kent Overstreet wrote:
> > > Just a little convenience macro - main reason to add it now is preparing
> > > for immutable bio vecs, it'll reduce the size of the patch that puts
> > > bi_sector/bi_size/bi_idx into a struct bvec_iter.
> > 
> > 
> > For the DRBD part:

> Version below look good?
> 
> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index 01b2ac6..47f55db 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -1144,7 +1144,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
>  	/* to make some things easier, force alignment of requests within the
>  	 * granularity of our hash tables */
>  	s_enr = bio->bi_sector >> HT_SHIFT;
> -	e_enr = bio->bi_size ? (bio->bi_sector+(bio->bi_size>>9)-1) >> HT_SHIFT : s_enr;
> +	e_enr = bio->bi_size ? (bio_end_sector(bio) - 1) >> HT_SHIFT : s_enr;
>  
>  	if (likely(s_enr == e_enr)) {
>  		do {

Sure.

Cheers,

	Lars

