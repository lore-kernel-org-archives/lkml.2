Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1IBT5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:57:46 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39529 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755264Ab1IBTz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:55:59 -0400
From: Serge Hallyn <serge@hallyn.com>
To: akpm@osdl.org, segooon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com, rdunlap@xenotime.net
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 11/15] userns: make some net-sysfs capable calls targeted
Date: Fri,  2 Sep 2011 19:56:36 +0000
Message-Id: <1314993400-6910-14-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314993400-6910-1-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

Changelog: jul 1: fix compilation errors (net_device != net)

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/net-sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 1683e5d..876915b 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -76,7 +76,7 @@ static ssize_t netdev_store(struct device *dev, struct device_attribute *attr,
 	unsigned long new;
 	int ret = -EINVAL;
 
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(net)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	new = simple_strtoul(buf, &endp, 0);
@@ -261,7 +261,7 @@ static ssize_t store_ifalias(struct device *dev, struct device_attribute *attr,
 	size_t count = len;
 	ssize_t ret;
 
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(netdev)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	/* ignore trailing newline */
-- 
1.7.5.4

