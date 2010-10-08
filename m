Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab0JHUAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:00:19 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:22417 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab0JHUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:00:12 -0400
Subject: [PATCH 12/13] hpsa: use usleep_range not msleep for small sleeps
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Oct 2010 15:07:03 -0500
Message-ID: <20101008200703.24279.96566.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a68dba7..c36427d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3594,7 +3594,7 @@ static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 		if (!doorbell_value & CFGTBL_ChangeReq)
 			break;
 		/* delay and try again */
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 }
 

