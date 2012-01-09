Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2AIG5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:57:38 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:39663 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2AIG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:57:37 -0500
From: Barry Song <Barry.Song@csr.com>
To: <linux-kernel@vger.kernel.org>
CC: <sujith.thomas@intel.com>, <rui.zhang@intel.com>, <len.brown@intel.com>,
        <rjw@sisk.pl>, <mingo@elte.hu>, <durgadoss.r@intel.com>,
        <workgroup.linux@csr.com>, Barry Song <Baohua.song@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] thermal: Fix "warning: 'thermal_event_seqnum' defined but not used"
Date: Mon, 9 Jan 2012 14:56:32 +0800
Message-ID: <1326092192-13953-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.song@csr.com>

Only if CONFIG_NET is enabled, thermal_event_seqnum will
be used.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
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



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
