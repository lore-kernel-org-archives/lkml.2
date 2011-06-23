Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab1FWR3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:65236 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab1FWR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sven Neumann <s.neumann@raumfeld.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 053/247] ds2760_battery: Fix calculation of time_to_empty_now
Date: Thu, 23 Jun 2011 13:25:52 -0400
Message-Id: <1308850146-15061-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Neumann <s.neumann@raumfeld.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 86af95039b69a90db15294eb1f9c147f1df0a8ea upstream.

A check against division by zero was modified in commit b0525b48.
Since this change time_to_empty_now is always reported as zero
while the battery is discharging and as a negative value while
the battery is charging. This is because current is negative while
the battery is discharging.

Fix the check introduced by commit b0525b48 so that time_to_empty_now
is reported correctly during discharge and as zero while charging.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/power/ds2760_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 3bf8d1f..4e13ebd 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -212,7 +212,7 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	if (di->rem_capacity > 100)
 		di->rem_capacity = 100;
 
-	if (di->current_uA >= 100L)
+	if (di->current_uA < -100L)
 		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
 					/ (di->current_uA / 100L);
 	else
-- 
1.7.4.4

