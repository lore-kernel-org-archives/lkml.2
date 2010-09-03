Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab0ICMsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:48:43 -0400
Received: from mv-drv-hcb003.ocn.ad.jp ([118.23.109.133]:47365 "EHLO
	mv-drv-hcb003.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0ICMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:48:41 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: m41t80: do not use rtc_valid_tm in m41t80_rtc_read_alarm
Date: Fri,  3 Sep 2010 21:48:36 +0900
Message-Id: <1283518116-5863-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit b485fe5ea ("rtc/m41t80: use rtc_valid_tm() to check
returned tm") added rtc_valid_tm to m41t80_rtc_read_alarm() but it was
wrong while the t->time does not contain complete date/time.

This patch also fix a warning:
warning: passing argument 1 of 'rtc_valid_tm' from incompatible pointer type

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-m41t80.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 66377f3..d60557c 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -364,7 +364,7 @@ static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->time.tm_isdst = -1;
 	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
 	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return rtc_valid_tm(t);
+	return 0;
 }
 
 static struct rtc_class_ops m41t80_rtc_ops = {
-- 
1.5.6.5

