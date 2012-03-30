Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935Ab2C3NTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:19:19 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:33467 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760877Ab2C3NSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:18:31 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 13/76] drivers/thermal/thermal_sys.c: fix build warning
Date: Fri, 30 Mar 2012 06:13:16 -0400
Message-id: <b11de07ce561574b6e03c8192b28bad540da8f79.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

With CONFIG_NET=n:

drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used

Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'

[akpm@linux-foundation.org: make thermal_event_seqnum local to generate_netlink_event()]
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/thermal/thermal_sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 220ce7e..859b80b 100644
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
@@ -1312,6 +1310,7 @@ int thermal_generate_netlink_event(u32 orig, enum events event)
 	void *msg_header;
 	int size;
 	int result;
+	static unsigned int thermal_event_seqnum;
 
 	/* allocate memory */
 	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
-- 
1.7.10.rc2.19.gfae9d

