Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1EKPwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:52:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57130 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab1EKPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:52:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] sst: tweak the shared functions so we don't crash the ASoC
 driver
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 11 May 2011 14:38:26 +0100
Message-ID: <20110511133728.6372.74986.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The ASoC driver is currently pulling bits from staging rather than its own
copy. Post all the merges and fixes we've put back an assumption that
crashes ASoC so we need to fix it differently.

(See 0ed625b2f2751c249417bd28694e37ef48eb5fbb)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 .../staging/intel_sst/intel_sst_drv_interface.c    |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 6b4b752..1021477 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -526,7 +526,9 @@ int register_sst_card(struct intel_sst_card_ops *card)
 		pr_err("Repeat for registration..denied\n");
 		return -EBADRQC;
 	}
-	sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
+	/* The ASoC code doesn't set scard_ops */
+	if (sst_drv_ctx->scard_ops)
+		sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(register_sst_card);

