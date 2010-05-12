Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0ELASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:18:54 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:58046 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752121Ab0ELASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:18:52 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 20:18:52 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21078
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: fercerpav@gmail.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/4] MFD: pcf50633: Fix bitfield logic in interrupt handler
Date: Wed, 12 May 2010 02:10:53 +0200
Message-Id: <1273623056-1243-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273623056-1243-1-git-send-email-lars@metafoo.de>
References: <1273623056-1243-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those constants are alreay bitfields.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/pcf50633-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index d66f389..6f7fb60 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -354,18 +354,18 @@ static void pcf50633_irq_worker(struct work_struct *work)
 	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
 		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
 		if (chgstat & (0x3 << 4))
-			pcf_int[0] &= ~(1 << PCF50633_INT1_USBREM);
+			pcf_int[0] &= ~PCF50633_INT1_USBREM;
 		else
-			pcf_int[0] &= ~(1 << PCF50633_INT1_USBINS);
+			pcf_int[0] &= ~PCF50633_INT1_USBINS;
 	}
 
 	/* Make sure only one of ADPINS or ADPREM is set */
 	if (pcf_int[0] & (PCF50633_INT1_ADPINS | PCF50633_INT1_ADPREM)) {
 		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
 		if (chgstat & (0x3 << 4))
-			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPREM);
+			pcf_int[0] &= ~PCF50633_INT1_ADPREM;
 		else
-			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPINS);
+			pcf_int[0] &= ~PCF50633_INT1_ADPINS;
 	}
 
 	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
-- 
1.5.6.5

