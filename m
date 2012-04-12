Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554Ab2DLT2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:28:16 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16529 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2DLT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:28:15 -0400
Message-ID: <1334258893.3022.7.camel@lorien2>
Subject: [PATCH] net/core: simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: davem@davemloft.net
Cc: shuahkhan@gmail.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Apr 2012 13:28:13 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed net/core/net-sysfs.c: netdev_store() to use kstrtoul() 
instead of obsolete simple_strtoul().

>From 84371b0ed8b277ec8005fd0efbc73165a8bd72b9 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Thu, 12 Apr 2012 10:36:10 -0600
Subject: [PATCH] net/core: simple_strtoul cleanup


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 net/core/net-sysfs.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4955862..97d0f24 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -74,15 +74,14 @@ static ssize_t netdev_store(struct device *dev, struct device_attribute *attr,
 			    int (*set)(struct net_device *, unsigned long))
 {
 	struct net_device *net = to_net_dev(dev);
-	char *endp;
 	unsigned long new;
 	int ret = -EINVAL;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	new = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
+	ret = kstrtoul(buf, 0, &new);
+	if (ret)
 		goto err;
 
 	if (!rtnl_trylock())
-- 
1.7.5.4



