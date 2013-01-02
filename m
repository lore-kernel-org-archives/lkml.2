Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3ABMBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:01:42 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63428 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABMBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:01:39 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 07:01:39 EST
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] davinci: dm355: Fix uninitialized variable compiler warnings
Date: Wed,  2 Jan 2013 17:23:49 +0530
Message-Id: <1357127630-8167-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/platform/davinci/dm355_ccdc.c:593:9: warning: ‘val1’ may be
used uninitialized in this function [-Wuninitialized]
drivers/media/platform/davinci/dm355_ccdc.c:560:6: note: ‘val1’ was declared here

This is a false positive but the compiler has no way to know about it,
so initialize the variable to 0.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/dm355_ccdc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index ce0e413..3c28aaa 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -557,7 +557,7 @@ static int ccdc_config_vdfc(struct ccdc_vertical_dft *dfc)
  */
 static void ccdc_config_csc(struct ccdc_csc *csc)
 {
-	u32 val1, val2;
+	u32 val1 = 0, val2;
 	int i;
 
 	if (!csc->enable)
-- 
1.7.4.1

