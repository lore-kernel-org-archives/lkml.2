Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0ECV2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0ECV2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:28:32 -0400
Date: Tue, 4 May 2010 00:24:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Tom Herbert <therbert@google.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] net: show stopped status in sysfs
Message-ID: <20100503212423.GA15998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debugging faulty hardware (in case of virt, faulty
emulation) I found it helpful to be able to examine
stopped status of the interface. The following patch makes
this visible in sysfs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/core/net-sysfs.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c57c4b2..e1f80c0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -132,6 +132,16 @@ static ssize_t show_carrier(struct device *dev,
 	return -EINVAL;
 }
 
+static ssize_t show_stopped(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	if (netif_running(netdev)) {
+		return sprintf(buf, fmt_dec, !!netif_queue_stopped(netdev));
+	}
+	return -EINVAL;
+}
+
 static ssize_t show_speed(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
@@ -303,6 +313,7 @@ static struct device_attribute net_class_attributes[] = {
 	__ATTR(address, S_IRUGO, show_address, NULL),
 	__ATTR(broadcast, S_IRUGO, show_broadcast, NULL),
 	__ATTR(carrier, S_IRUGO, show_carrier, NULL),
+	__ATTR(carrier, S_IRUGO, show_stopped, NULL),
 	__ATTR(speed, S_IRUGO, show_speed, NULL),
 	__ATTR(duplex, S_IRUGO, show_duplex, NULL),
 	__ATTR(dormant, S_IRUGO, show_dormant, NULL),
-- 
1.7.1.rc1.22.g3163
