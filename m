Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2IVCLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 22:11:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45969 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab2IVCLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 22:11:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ashish Sharma <ashishsharma@google.com>, netdev@vger.kernel.org,
        JP Abgrall <jpa@google.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 7/7][RFC] netfilter: xt_IDLETIMER: Rename INTERFACE to LABEL in netlink notification.
Date: Fri, 21 Sep 2012 22:10:53 -0400
Message-Id: <1348279853-44499-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348279853-44499-1-git-send-email-john.stultz@linaro.org>
References: <1348279853-44499-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092202-7606-0000-0000-000003DF92DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashish Sharma <ashishsharma@google.com>

Rename INTERFACE to LABEL in netlink notification.

Cc: netdev@vger.kernel.org
Cc: JP Abgrall <jpa@google.com>
Cc: Ashish Sharma <ashishsharma@google.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: Ashish Sharma <ashishsharma@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 net/netfilter/xt_IDLETIMER.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index df91e26..f4ba863 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -68,15 +68,15 @@ static DEFINE_MUTEX(list_mutex);
 
 static struct kobject *idletimer_tg_kobj;
 
-static void notify_netlink_uevent(const char *iface, struct idletimer_tg *timer)
+static void notify_netlink_uevent(const char *label, struct idletimer_tg *timer)
 {
-	char iface_msg[NLMSG_MAX_SIZE];
+	char label_msg[NLMSG_MAX_SIZE];
 	char state_msg[NLMSG_MAX_SIZE];
-	char *envp[] = { iface_msg, state_msg, NULL };
+	char *envp[] = { label_msg, state_msg, NULL };
 	int res;
 
-	res = snprintf(iface_msg, NLMSG_MAX_SIZE, "INTERFACE=%s",
-		       iface);
+	res = snprintf(label_msg, NLMSG_MAX_SIZE, "LABEL=%s",
+		       label);
 	if (NLMSG_MAX_SIZE <= res) {
 		pr_err("message too long (%d)", res);
 		return;
@@ -87,7 +87,7 @@ static void notify_netlink_uevent(const char *iface, struct idletimer_tg *timer)
 		pr_err("message too long (%d)", res);
 		return;
 	}
-	pr_debug("putting nlmsg: <%s> <%s>\n", iface_msg, state_msg);
+	pr_debug("putting nlmsg: <%s> <%s>\n", label_msg, state_msg);
 	kobject_uevent_env(idletimer_tg_kobj, KOBJ_CHANGE, envp);
 	return;
 
-- 
1.7.9.5

