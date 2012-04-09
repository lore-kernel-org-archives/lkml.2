Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab2DIUvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21116 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2DIUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:31 -0400
Date: Mon, 9 Apr 2012 22:51:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 17/26] [SCSI] aic94xx: Get rid of redundant NULL check before
 release_firmware() call
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092227391.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() checks for NULL pointers internally, so checking
before calling the function is redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/aic94xx/aic94xx_seq.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 390168f..5fdca93 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -1228,8 +1228,7 @@ static int asd_seq_start_lseq(struct asd_ha_struct *asd_ha, int lseq)
 
 int asd_release_firmware(void)
 {
-	if (sequencer_fw)
-		release_firmware(sequencer_fw);
+	release_firmware(sequencer_fw);
 	return 0;
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

