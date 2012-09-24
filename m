Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab2IXXOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:14:48 -0400
Received: from jim.sh ([75.150.123.25]:53261 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2IXXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:14:46 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2012 19:14:46 EDT
Date: Mon, 24 Sep 2012 19:04:50 -0400
From: Jim Paris <jim@jtan.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, neilb@suse.de,
        vgoyal@redhat.com, "Ed L. Cashin" <ecashin@coraid.com>,
        Nick Piggin <npiggin@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Geoff Levand <geoff@infradead.org>, Alasdair Kergon <agk@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 07/26] block: Use bio_sectors() more consistently
Message-ID: <20120924230449.GA2040@psychosis.jim.sh>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-8-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348526106-17074-8-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet wrote:
> Bunch of places in the code weren't using it where they could be -
> this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: "Ed L. Cashin" <ecashin@coraid.com>
> CC: Nick Piggin <npiggin@kernel.dk>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Jim Paris <jim@jtan.com>
> CC: Geoff Levand <geoff@infradead.org>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: dm-devel@redhat.com
> CC: Neil Brown <neilb@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/block/aoe/aoecmd.c   |  2 +-
>  drivers/block/brd.c          |  3 +--
>  drivers/block/pktcdvd.c      |  2 +-
>  drivers/block/ps3vram.c      |  2 +-
>  drivers/md/dm-raid1.c        |  2 +-
>  drivers/md/raid0.c           |  6 +++---
>  drivers/md/raid1.c           | 17 ++++++++---------
>  drivers/md/raid10.c          | 24 +++++++++++-------------
>  drivers/md/raid5.c           |  8 ++++----
>  include/trace/events/block.h | 10 +++++-----
>  10 files changed, 36 insertions(+), 40 deletions(-)
...
> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> index f58cdcf..1ff38e8 100644
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -553,7 +553,7 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
>  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
>  	int write = bio_data_dir(bio) == WRITE;
>  	const char *op = write ? "write" : "read";
> -	loff_t offset = bio->bi_sector << 9;
> +	loff_t offset = bio_sectors(bio);

This doesn't look right to me: bio_sectors(bio) is (bio->bi_size>>9),
not (bio->bi_sector<<9~)?

-jim

