Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab0EFJvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:51:41 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:36636 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0EFJvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:51:40 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] powerpc/BSR: Use resource_size
Date: Thu,  6 May 2010 11:51:37 +0200
Message-Id: <1273139497-25961-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.6.94214
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_800_899 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource_size function instead of manually calculating the
resource size.  This reduces the chance of introducing off-by-one
errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/char/bsr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 89d871e..aadc78b 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -210,7 +210,7 @@ static int bsr_add_node(struct device_node *bn)
 
 		cur->bsr_minor  = i + total_bsr_devs;
 		cur->bsr_addr   = res.start;
-		cur->bsr_len    = res.end - res.start + 1;
+		cur->bsr_len    = resource_size(&res);
 		cur->bsr_bytes  = bsr_bytes[i];
 		cur->bsr_stride = bsr_stride[i];
 		cur->bsr_dev    = MKDEV(bsr_major, i + total_bsr_devs);
-- 
1.6.3.3

