Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1DRIeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:34:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab1DRIdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:33:54 -0400
Date: Mon, 18 Apr 2011 18:33:43 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110418183343.036f412e@notabene.brown>
In-Reply-To: <4DABF1EA.3070301@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
	<4D761E0D.8050200@fusionio.com>
	<20110308202100.GA31744@redhat.com>
	<4D76912C.9040705@fusionio.com>
	<20110308220526.GA393@redhat.com>
	<20110310005810.GA17911@redhat.com>
	<20110405130541.6c2b5f86@notabene.brown>
	<20110411145022.710c30e9@notabene.brown>
	<4DA2C7BE.6060804@fusionio.com>
	<20110411205928.13915719@notabene.brown>
	<4DA2E03A.2080607@fusionio.com>
	<20110411212635.7959de70@notabene.brown>
	<4DA2E7F0.9010904@fusionio.com>
	<20110411220505.1028816e@notabene.brown>
	<4DA2F00E.6010907@fusionio.com>
	<20110418081922.1651474a@notabene.brown>
	<4DABDC60.2090009@fusionio.com>
	<20110418172551.55629fc6@notabene.brown>
	<4DABF1EA.3070301@fusionio.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[[NOTE to dm-devel people - one of the patches here remove some
 now-unused code from dm-raid.c plus a declaration from device-mapper.h ]]]


On Mon, 18 Apr 2011 10:10:18 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-04-18 09:25, NeilBrown wrote:

> >>> Therefore md cannot put anything useful on the list in 'struct blk_plug'.
> > 
> > That is the heart of the problem.
> 
> Hmm, I don't really see a way to avoid the list in that case. You really
> do need some way to queue items, a single callback or flag or pointer
> will not suffice.
> 
> I've added the patch and removed the (now) useless ->unplugged_fn
> callback. I suggest you base your md changes on top of my for-linus
> branch and tell me when you are confident it looks good, then I'll pull
> in your MD changes and submit them later today.
> 
> OK with you?
> 

Yes, that's perfect.  Thanks.

All of my plugging-related patches are now in a 'for-jens' branch:

The following changes since commit 99e22598e9a8e0a996d69c8c0f6b7027cb57720a:

  block: drop queue lock before calling __blk_run_queue() for kblockd punt (2011-04-18 09:59:55 +0200)

are available in the git repository at:
  git://neil.brown.name/md for-jens

NeilBrown (6):
      md: use new plugging interface for RAID IO.
      md/dm - remove remains of plug_fn callback.
      md - remove old plugging code.
      md: provide generic support for handling unplug callbacks.
      md: incorporate new plugging into raid5.
      md: fix up raid1/raid10 unplugging.

 drivers/md/dm-raid.c          |    8 ----
 drivers/md/md.c               |   87 +++++++++++++++++++++-------------------
 drivers/md/md.h               |   26 ++----------
 drivers/md/raid1.c            |   29 +++++++-------
 drivers/md/raid10.c           |   27 ++++++-------
 drivers/md/raid5.c            |   61 ++++++++++++----------------
 drivers/md/raid5.h            |    2 -
 include/linux/device-mapper.h |    1 -
 8 files changed, 103 insertions(+), 138 deletions(-)


Thanks,
NeilBrown

