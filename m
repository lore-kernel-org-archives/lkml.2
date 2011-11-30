Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1K3Qww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:52:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57564 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124Ab1K3Qwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:52:51 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Correct revision display for WM1811 revision D
Date: Wed, 30 Nov 2011 16:52:34 +0000
Message-Id: <1322671954-29177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As WM1811 revision C was transparent to software the revision IDs for
subsequent revisions are one less than they would normally be. Correct
for this in log messages.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I can fold this and other updates into the big regmap changes I posted
the other day if that's helpful?

 drivers/mfd/wm8994-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 5633fe4..f49b1ac 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -460,6 +460,11 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 			break;
 		}
 		break;
+	case WM1811:
+		/* Revision C did not change the relevant layer */
+		if (ret > 1)
+			ret++;
+		break;
 	default:
 		break;
 	}
-- 
1.7.7.3

