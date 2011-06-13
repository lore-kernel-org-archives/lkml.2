Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1FMSKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:10:18 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:49668 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1FMSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:10:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samu Onkalo <samu.p.onkalo@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] misc/apds990x: apds990x_chip_on should depend on CONFIG_PM || CONFIG_PM_RUNTIME
Date: Mon, 13 Jun 2011 20:10:13 +0200
Message-Id: <1307988613-21590-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/misc/apds990x.c: At top level:
drivers/misc/apds990x.c:613: warning: ‘apds990x_chip_on’ defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/misc/apds990x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 200311f..e2a52e5 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -609,6 +609,7 @@ static int apds990x_detect(struct apds990x_chip *chip)
 	return ret;
 }
 
+#if defined(CONFIG_PM) || defined(CONFIG_PM_RUNTIME)
 static int apds990x_chip_on(struct apds990x_chip *chip)
 {
 	int err	 = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
@@ -624,6 +625,7 @@ static int apds990x_chip_on(struct apds990x_chip *chip)
 	apds990x_mode_on(chip);
 	return 0;
 }
+#endif
 
 static int apds990x_chip_off(struct apds990x_chip *chip)
 {
-- 
1.7.0.4

