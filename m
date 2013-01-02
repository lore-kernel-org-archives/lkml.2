Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3ABLy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:54:26 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50609 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABLyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:54:25 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] davinci: dm644x: fix enum ccdc_gama_width and enum ccdc_data_size comparision warning
Date: Wed,  2 Jan 2013 17:23:50 +0530
Message-Id: <1357127630-8167-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357127630-8167-1-git-send-email-prabhakar.lad@ti.com>
References: <1357127630-8167-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while the effect is harmless this patch fixes following build warning,

drivers/media/platform/davinci/dm644x_ccdc.c: In function ‘validate_ccdc_param’:
drivers/media/platform/davinci/dm644x_ccdc.c:233:32: warning: comparison between
‘enum ccdc_gama_width’ and ‘enum ccdc_data_size’ [-Wenum-compare]

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/dm644x_ccdc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index ee7942b..42b473a 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -228,9 +228,12 @@ static void ccdc_readregs(void)
 static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 {
 	if (ccdcparam->alaw.enable) {
+		u32 gama_wd = ccdcparam->alaw.gama_wd;
+		u32 data_sz = ccdcparam->data_sz;
+
 		if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
 		    (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
-		    (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
+		    (gama_wd < data_sz)) {
 			dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
 			return -1;
 		}
-- 
1.7.4.1

