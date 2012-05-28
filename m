Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2E1KQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:16:53 -0400
Received: from natasha.panasas.com ([67.152.220.90]:45714 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2E1KQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:16:50 -0400
Message-ID: <4FC3504B.7000903@panasas.com>
Date: Mon, 28 May 2012 13:15:39 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-bcache@vger.kernel.org>,
        <dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
        <tj@kernel.org>, <axboe@kernel.dk>, <agk@redhat.com>, <neilb@suse.de>,
        <drbd-dev@lists.linbit.com>, <vgoyal@redhat.com>,
        <mpatocka@redhat.com>, <sage@newdream.net>, <yehuda@hq.newdream.net>
Subject: Re: [PATCH v3 07/16] block: Rename bio_split() -> bio_pair_split()
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-8-git-send-email-koverstreet@google.com>
In-Reply-To: <1337977539-16977-8-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 11:25 PM, Kent Overstreet wrote:

> This is prep work for introducing a more general bio_split()
> 
> Change-Id: Ib9c4ff691af889d26bc9ec9fb42a2f3068f34ad9
> 


Since these patches will go through Jens tree this kind of
comment can *never* be true/correct. And it is plenty unwanted
for sure.

Here:
bio_do means an operation on bio. But here we are actually operating
on a bio_pair. So rename it it to bio_pair_do.

We will later introduce a real bio_split() function that receives
a bio and splits it.

Or something like that.
Thanks
Boaz

> Signed-off-by: Kent Overstreet <koverstreet@google.com>

<snip>

> @@ -201,7 +201,7 @@ struct bio_pair {
>  	atomic_t			cnt;
>  	int				error;
>  };
> -extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
> +extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
>  extern void bio_pair_release(struct bio_pair *dbio);
>  
>  extern struct bio_set *bioset_create(unsigned int, unsigned int);


