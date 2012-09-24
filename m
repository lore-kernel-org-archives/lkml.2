Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab2IXXJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:09:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2IXXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:09:49 -0400
Date: Mon, 24 Sep 2012 16:09:45 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jim Paris <jim@jtan.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, neilb@suse.de,
        vgoyal@redhat.com, "Ed L. Cashin" <ecashin@coraid.com>,
        Nick Piggin <npiggin@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Geoff Levand <geoff@infradead.org>, Alasdair Kergon <agk@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 07/26] block: Use bio_sectors() more consistently
Message-ID: <20120924230945.GB27689@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-8-git-send-email-koverstreet@google.com>
 <20120924230449.GA2040@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924230449.GA2040@psychosis.jim.sh>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 07:04:50PM -0400, Jim Paris wrote:
> Kent Overstreet wrote:
> > Bunch of places in the code weren't using it where they could be -
> > this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> > into a struct bvec_iter.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: "Ed L. Cashin" <ecashin@coraid.com>
> > CC: Nick Piggin <npiggin@kernel.dk>
> > CC: Jiri Kosina <jkosina@suse.cz>
> > CC: Jim Paris <jim@jtan.com>
> > CC: Geoff Levand <geoff@infradead.org>
> > CC: Alasdair Kergon <agk@redhat.com>
> > CC: dm-devel@redhat.com
> > CC: Neil Brown <neilb@suse.de>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  drivers/block/aoe/aoecmd.c   |  2 +-
> >  drivers/block/brd.c          |  3 +--
> >  drivers/block/pktcdvd.c      |  2 +-
> >  drivers/block/ps3vram.c      |  2 +-
> >  drivers/md/dm-raid1.c        |  2 +-
> >  drivers/md/raid0.c           |  6 +++---
> >  drivers/md/raid1.c           | 17 ++++++++---------
> >  drivers/md/raid10.c          | 24 +++++++++++-------------
> >  drivers/md/raid5.c           |  8 ++++----
> >  include/trace/events/block.h | 10 +++++-----
> >  10 files changed, 36 insertions(+), 40 deletions(-)
> ...
> > diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> > index f58cdcf..1ff38e8 100644
> > --- a/drivers/block/ps3vram.c
> > +++ b/drivers/block/ps3vram.c
> > @@ -553,7 +553,7 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
> >  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
> >  	int write = bio_data_dir(bio) == WRITE;
> >  	const char *op = write ? "write" : "read";
> > -	loff_t offset = bio->bi_sector << 9;
> > +	loff_t offset = bio_sectors(bio);
> 
> This doesn't look right to me: bio_sectors(bio) is (bio->bi_size>>9),
> not (bio->bi_sector<<9~)?

Whoops, you're right - that's completely wrong. Thanks.
