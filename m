Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2KEJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:52:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2KEJwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:52:11 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 1/3] dmaengine: PL08x: Fix reading the byte count in cctl
Date: Mon,  5 Nov 2012 10:51:42 +0100
Message-Id: <1352109104-2969-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
References: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:kCZT2fiA8gCksrW75fhXR7+NDUK/AzSH2YfyZvayHe3
 bFjlPcq+blXpLXJl02BahTb0E8Y8GYg2HxWM8GbHr3LuISxwXT
 y5+ravdZQYtGWXZ6gNO2JLEwD7ZOiyUnThsGh1BGhC/P7t7pAQ
 UzQN24mZK77vggygdAG/oJ/Tw0OTWdogQLsuBCHZ4Js8SCBWOQ
 lUs6gj9/KAbzqc4YCR1BzTjS3P3zmf7diFuFOBKxlHDtAbNBn6
 6ELXJpdkFlzrZ6zFnhqHrTCw9Oc+c5ZJ76Ox825vqbiktZVHuR
 IxiqLBW74eC3XORtafqQO5GfSrz2oBOpey7uyZvpiCX0yLa3LI
 tJVmbmDT1aVqTgHgULDRoF86mnoVxozZF5HCJ6z5ObgdE5Jk2M
 dguk0W96+VyEaH8TNE/g1Es4ox7KbDu7me41odDZWJArNZvS7X
 GjGY8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/dma/amba-pl08x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d1cc579..fc8bedf 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -453,7 +453,8 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 	/* The source width defines the number of bytes */
 	u32 bytes = cctl & PL080_CONTROL_TRANSFER_SIZE_MASK;
 
-	switch (cctl >> PL080_CONTROL_SWIDTH_SHIFT) {
+	switch ((cctl & PL080_CONTROL_SWIDTH_MASK) >>
+		PL080_CONTROL_SWIDTH_SHIFT) {
 	case PL080_WIDTH_8BIT:
 		break;
 	case PL080_WIDTH_16BIT:
-- 
1.7.0.4

