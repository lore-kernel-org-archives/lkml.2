Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2KTEtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:49:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40712 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab2KTEtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:49:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] mfd: arizona: Use correct array for ARRAY_SIZE in mfd_add_devices call
Date: Tue, 20 Nov 2012 13:46:19 +0900
Message-Id: <1353386781-10468-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20121120044544.GF4483@opensource.wolfsonmicro.com>
 <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

wm5102_devs array was used for ARRAY_SIZE whilst adding the wm5110
devices. This change corrects this to get the size from the wm5110_devs
array. As both arrays are the same size no issues should have been
caused by this bug.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1b48f20..166254b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -520,7 +520,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		break;
 	case WM5110:
 		ret = mfd_add_devices(arizona->dev, -1, wm5110_devs,
-				      ARRAY_SIZE(wm5102_devs), NULL, 0, NULL);
+				      ARRAY_SIZE(wm5110_devs), NULL, 0, NULL);
 		break;
 	}
 
-- 
1.7.10.4

