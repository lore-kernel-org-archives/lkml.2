Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab0JHUAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:00:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2031 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066Ab0JHT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:59:57 -0400
Subject: [PATCH 09/13] cciss: use usleep_range not msleep for small sleeps
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Oct 2010 15:06:47 -0500
Message-ID: <20101008200647.24279.76464.stgit@beardog.cce.hp.com>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
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
index 08cbee8..7d2959c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3769,7 +3769,7 @@ static void __devinit cciss_wait_for_mode_change_ack(ctlr_info_t *h)
 	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 }
 

