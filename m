Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2APQLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:11:18 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:39645 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2APQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:11:17 -0500
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] mfd: s5m: fix error handling for invalid device type
Date: Mon, 16 Jan 2012 15:52:21 +0900
Message-Id: <1326696741-23353-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

If device type is not supported in driver, have to retun error.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/mfd/s5m-irq.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/s5m-irq.c b/drivers/mfd/s5m-irq.c
index de76dfb..2aa7708 100644
--- a/drivers/mfd/s5m-irq.c
+++ b/drivers/mfd/s5m-irq.c
@@ -342,7 +342,8 @@ int s5m_irq_resume(struct s5m87xx_dev *s5m87xx)
 			s5m8767_irq_thread(s5m87xx->irq_base, s5m87xx);
 			break;
 		default:
-			break;
+			dev_err(s5m87xx->dev, "Unknown device type %d\n", s5m87xx->device_type);
+			return -EINVAL;
 
 		}
 	}
@@ -444,7 +445,8 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
 		}
 		break;
 	default:
-		break;
+		dev_err(s5m87xx->dev, "Unknown device type %d\n", s5m87xx->device_type);
+		return -EINVAL;
 	}
 
 	if (!s5m87xx->ono)
@@ -467,12 +469,15 @@ int s5m_irq_init(struct s5m87xx_dev *s5m87xx)
 					IRQF_ONESHOT, "s5m87xx-ono", s5m87xx);
 		break;
 	default:
+		ret = -EINVAL;
 		break;
 	}
 
-	if (ret)
+	if (ret) {
 		dev_err(s5m87xx->dev, "Failed to request IRQ %d: %d\n",
 			s5m87xx->ono, ret);
+		return ret;
+	}
 
 	return 0;
 }
-- 
1.7.1

