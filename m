Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0KKSBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:01:19 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1135 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755375Ab0KKSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:01:17 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 9573
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] POWER: jz4740-battery: Check if platform_data is supplied
Date: Thu, 11 Nov 2010 19:00:53 +0100
Message-Id: <1289498453-9938-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1289498453-9938-1-git-send-email-lars@metafoo.de>
References: <1289498453-9938-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently platform_data is dereferenced without checking whether it is actually
set, which can lead to kernel crashes.
This patch adds a check which will abort the drivers probe function gracefully
if no platform_data is supplied.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/jz4740-battery.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 2bbe04a..5b48215 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -246,6 +246,11 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 	struct jz_battery *jz_battery;
 	struct power_supply *battery;
 
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform_data supplied\n");
+		return -ENXIO;
+	}
+
 	jz_battery = kzalloc(sizeof(*jz_battery), GFP_KERNEL);
 	if (!jz_battery) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
-- 
1.5.6.5

