Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2ERSXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:23:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55510 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966504Ab2ERSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:23:05 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] mfd: Mark two lm3533 zone registers as volatile
Date: Fri, 18 May 2012 20:22:46 +0200
Message-Id: <1337365366-14385-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
References: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the two currently unused zone registers as volatile in regmap for
completeness.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/lm3533-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 104faba..0b2879b 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -567,7 +567,7 @@ static bool lm3533_readable_register(struct device *dev, unsigned int reg)
 static bool lm3533_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case 0x34:		/* zone */
+	case 0x34 ... 0x36:	/* zone */
 	case 0x37 ... 0x38:	/* adc */
 	case 0xb0 ... 0xb1:	/* fault */
 		return true;
-- 
1.7.8.5

