Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1BLTj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:39:59 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1071 "HELO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752583Ab1BLTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:39:36 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24377
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 02/14] bq27x00: Improve temperature property precession
Date: Sat, 12 Feb 2011 20:39:01 +0100
Message-Id: <1297539554-13957-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297539554-13957-1-git-send-email-lars@metafoo.de>
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the precession of the temperature property of the
bq27x00 driver.
By dividing before multiplying the current code effectively cuts of the
last decimal digit. This patch fixes it by multiplying before dividing.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/power/bq27x00_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index bb043f9..4f74659 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -109,7 +109,7 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
 	if (di->chip == BQ27500)
 		return temp - 2731;
 	else
-		return ((temp >> 2) - 273) * 10;
+		return ((temp * 5) - 5463) / 2;
 }
 
 /*
-- 
1.7.2.3

