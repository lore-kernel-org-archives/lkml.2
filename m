Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab0LTXmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:42:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:56712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0LTXmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:42:18 -0500
Date: Tue, 21 Dec 2010 00:42:13 +0100
From: Michal Marek <mmarek@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cciss: fix cciss_revalidate panic.
Message-ID: <20101220234213.GA10060@sepie.suse.cz>
References: <20101216190200.630.8596.stgit@beardog.cce.hp.com>
 <4D0B190E.1030206@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0B190E.1030206@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 09:02:22AM +0100, Jens Axboe wrote:
> On 2010-12-16 20:02, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <StephenM.Cameron>
> > 
> > If you delete a logical drive, and then run BLKRRPART (e.g. via fdisk)
> > on a logical drive which is "after" the deleted logical drive in the h->drv[]
> > array, then cciss_revalidate panics because it will access the null pointer
> > h->drv[x] when x hits the deleted drive.
> 
> Thanks Stephen. I put this in for-linus for 2.6.37 and marked it for
> stable backport.

This got applied without the semicolon after 'continue' somehow and
broke build. Please apply the patch below.

Michal

>From 70b720652024b23d71d72a1464f174df124600b7 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Tue, 21 Dec 2010 00:35:56 +0100
Subject: [PATCH] cciss: Fix build

drivers/block/cciss.c:2839:3: error: expected ';' before 'if'

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 233e06c..8e0f925 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2835,7 +2835,7 @@ static int cciss_revalidate(struct gendisk *disk)
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
 		if (!h->drv[logvol])
-			continue
+			continue;
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
 			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;
