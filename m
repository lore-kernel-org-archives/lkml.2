Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3AJMS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:18:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41516 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab3AJMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/9] mfd: wm5102: Mark DSP memory regions as volatile and readable
Date: Thu, 10 Jan 2013 12:18:44 +0000
Message-Id: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130110121828.GN20956@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can cache some of them but this is simpler for now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 088872a..4a01192 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1825,7 +1825,13 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_3:
 		return true;
 	default:
-		return false;
+		if ((reg >= 0x100000 && reg < 0x106000) ||
+		    (reg >= 0x180000 && reg < 0x180800) ||
+		    (reg >= 0x190000 && reg < 0x194800) ||
+		    (reg >= 0x1a8000 && reg < 0x1a9800))
+			return true;
+		else
+			return false;
 	}
 }
 
-- 
1.7.10.4

