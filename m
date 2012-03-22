Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2CVSJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:09:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:37334 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2CVSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:08:55 -0400
Subject: [PATCH 1/2] cciss: Fix scsi tape io with more than 255 scatter gather
	elements
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Thu, 22 Mar 2012 13:08:52 -0500
Message-ID: <20120322180852.14453.3206.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The total number of scatter gather elements in the CISS command
used by the scsi tape code was being cast to a u8, which can hold
at most 255 scatter gather elements.  It should have been cast to
a u16.  Without this patch the command gets rejected by the controller
since the total scatter gather count did not add up to the right
value resulting in an i/o error.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/block/cciss_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e820b68..1162f7b 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1410,7 +1410,7 @@ static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *c,
 	/* track how many SG entries we are using */
 	if (request_nsgs > h->maxSG)
 		h->maxSG = request_nsgs;
-	c->Header.SGTotal = (__u8) request_nsgs + chained;
+	c->Header.SGTotal = (u16) request_nsgs + chained;
 	if (request_nsgs > h->max_cmd_sgentries)
 		c->Header.SGList = h->max_cmd_sgentries;
 	else

