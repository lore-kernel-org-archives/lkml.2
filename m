Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2AVQqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 11:46:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38929 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2AVQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 11:46:13 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, guenter.roeck@ericsson.com,
        durgadoss.r@intel.com, khali@linux-fr.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] thermal: thermal_sys: Fix build warning
Date: Sun, 22 Jan 2012 14:46:01 -0200
Message-Id: <1327250761-7071-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327249995-18682-1-git-send-email-festevam@gmail.com>
References: <1327249995-18682-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning:

drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used

,which happens when CONFIG_NET is not set.

Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Change since v1:
- Sent corrupted patch in v1, and fixed now
 drivers/thermal/thermal_sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index dd9a574..11f5955 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -60,8 +60,6 @@ static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static DEFINE_MUTEX(thermal_list_lock);
 
-static unsigned int thermal_event_seqnum;
-
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
 	int err;
@@ -1304,6 +1302,8 @@ static struct genl_multicast_group thermal_event_mcgrp = {
 	.name = THERMAL_GENL_MCAST_GROUP_NAME,
 };
 
+static unsigned int thermal_event_seqnum;
+
 int generate_netlink_event(u32 orig, enum events event)
 {
 	struct sk_buff *skb;
-- 
1.7.1

