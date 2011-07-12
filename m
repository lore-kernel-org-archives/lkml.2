Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1GLXhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:37:46 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58726 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153Ab1GLXho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:44 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [RFC PATCH 11/14] userns: make some net-sysfs capable calls targeted
Date: Tue, 12 Jul 2011 23:30:49 +0000
Message-Id: <1310513452-13397-12-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310513452-13397-1-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

Changelog: jul 1: fix compilation errors (net_device != net)

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/net-sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 33d2a1f..b651baf 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -76,7 +76,7 @@ static ssize_t netdev_store(struct device *dev, struct device_attribute *attr,
 	unsigned long new;
 	int ret = -EINVAL;
 
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(net)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	new = simple_strtoul(buf, &endp, 0);
@@ -262,7 +262,7 @@ static ssize_t store_ifalias(struct device *dev, struct device_attribute *attr,
 	size_t count = len;
 	ssize_t ret;
 
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(netdev)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	/* ignore trailing newline */
-- 
1.7.4.1

