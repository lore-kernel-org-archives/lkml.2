Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1FMSlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:41:35 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38635 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1FMSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:39:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Creasey <sammy@sammy.net>
Subject: [PATCH 6/8] scsi/sun3: Check for NCR_TIMEOUT being defined instead of having a value
Date: Mon, 13 Jun 2011 20:39:20 +0200
Message-Id: <1307990362-22768-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:

drivers/scsi/sun3_NCR5380.c:1448:5: warning: "NCR_TIMEOUT" is not defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_NCR5380.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 2ba1cb7..f3cffdf 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -1445,7 +1445,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd,
     local_irq_restore(flags);
 
     /* Wait for arbitration logic to complete */
-#if NCR_TIMEOUT
+#ifdef NCR_TIMEOUT
     {
       unsigned long timeout = jiffies + 2*NCR_TIMEOUT;
 
-- 
1.7.0.4

