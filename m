Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030232Ab2CAJZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:25:00 -0500
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60384 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878Ab2CAJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:24:57 -0500
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2012 04:24:56 EST
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.220.168 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
From: santosh nayak <santoshprasadnayak@gmail.com>
To: bart.de.schuymer@pandora.be
Cc: pablo@netfilter.org, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 1/3] netfilter: Fix copy_to_user too small size parametre.
Date: Thu,  1 Mar 2012 14:46:30 +0530
Message-Id: <1330593390-19233-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

While copying to userspace, the size of source is 29byte where as
size parametre is 32 byte.  Its leaking extra-information from
kernel space to user space.
Replace EBT_FUNCTION_MAXNAMELEN by XT_EXTENSION_MAXNAMELEN.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 net/bridge/netfilter/ebtables.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5864cc4..f3fcbd9 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1335,7 +1335,7 @@ static inline int ebt_make_matchname(const struct ebt_entry_match *m,
     const char *base, char __user *ubase)
 {
 	char __user *hlp = ubase + ((char *)m - base);
-	if (copy_to_user(hlp, m->u.match->name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp, m->u.match->name, XT_EXTENSION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
@@ -1344,7 +1344,7 @@ static inline int ebt_make_watchername(const struct ebt_entry_watcher *w,
     const char *base, char __user *ubase)
 {
 	char __user *hlp = ubase + ((char *)w - base);
-	if (copy_to_user(hlp , w->u.watcher->name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp , w->u.watcher->name, XT_EXTENSION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
@@ -1368,7 +1368,7 @@ ebt_make_names(struct ebt_entry *e, const char *base, char __user *ubase)
 	ret = EBT_WATCHER_ITERATE(e, ebt_make_watchername, base, ubase);
 	if (ret != 0)
 		return ret;
-	if (copy_to_user(hlp, t->u.target->name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp, t->u.target->name, XT_EXTENSION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
-- 
1.7.4.4

