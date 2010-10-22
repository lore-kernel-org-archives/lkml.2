Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0JVTV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:21:26 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:45708 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0JVTVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:21:23 -0400
Subject: [PATCH 5/5] cciss: use usleep_range not msleep for small sleeps
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Fri, 22 Oct 2010 14:21:22 -0500
Message-ID: <20101022192122.25567.29350.stgit@beardog.cce.hp.com>
In-Reply-To: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
References: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 55fed21..95bd799 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3749,7 +3749,7 @@ static void __devinit cciss_wait_for_mode_change_ack(ctlr_info_t *h)
 	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 }
 

