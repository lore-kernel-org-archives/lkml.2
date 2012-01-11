Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2AKRaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:30:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64412 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2AKRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:30:42 -0500
Date: Wed, 11 Jan 2012 09:30:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: axboe@kernel.dk, mingo@redhat.com, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com
Subject: Re: [PATCH 2/9] block: block_bio_complete tracepoint was missing
Message-ID: <20120111173036.GG26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-3-git-send-email-tj@kernel.org>
 <1326302732.7642.57.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326302732.7642.57.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 11, 2012 at 12:25:32PM -0500, Steven Rostedt wrote:
> On Tue, 2012-01-10 at 10:28 -0800, Tejun Heo wrote:
> > block_bio_complete tracepoint was defined but not invoked anywhere.
> > Fix it.
> > 
> > -tj: This will generate duplicate BLK_TA_COMPLETEs.  Namhyung is
> >      working on proper solution.
> > 
> > DO_NOT_APPLY
> > Cc: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  fs/bio.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index b1fe82c..96548da 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1447,6 +1447,9 @@ void bio_endio(struct bio *bio, int error)
> >  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> >  		error = -EIO;
> >  
> > +	if (bio->bi_bdev)
> > +		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
> > +					 bio, error);
> 
> I thought I commented before about using TRACE_EVENT_CONDITIONAL() here.
> To remove that open coded branch.

Yeah but this particular patch is dead now so it's a bit pointless.
ioblame:ioblame_io uses it FWIW.  Namhyung, can you please consider
using TRACE_EVENT_CONDITION() for you patches if applicable?

Thanks.

-- 
tejun
