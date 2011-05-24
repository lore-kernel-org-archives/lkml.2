Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab1EXTHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:07:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13107 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1EXTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:07:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 May 2011 12:07:46 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: cbouatmailru@gmail.com
Cc: bleung@chromium.org, olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/2] power: bq20z75: enable detection after registering
Date: Tue, 24 May 2011 12:06:00 -0700
Message-Id: <1306263960-1236-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1306263960-1236-1-git-send-email-rklein@nvidia.com>
References: <1306263960-1236-1-git-send-email-rklein@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to enable detection, which is also blocking the unit conversion logic
after registering the power_supply.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v2:	This should have been adding the line, not removing it. Fixed that.

 drivers/power/bq20z75.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index e1adc0e..9c5e5be 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -702,6 +702,8 @@ skip_gpio:
 
 	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
 
+	bq20z75_device->enable_detection = true;
+
 	return 0;
 
 exit_psupply:
-- 
1.7.5.1

