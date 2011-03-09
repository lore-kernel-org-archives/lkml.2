Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1CIVh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:37:26 -0500
Received: from mx2.parallels.com ([64.131.90.16]:57247 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1CIVhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:37:25 -0500
Message-ID: <4D77F309.2030101@parallels.com>
Date: Wed, 9 Mar 2011 15:37:13 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Move an assert under DEBUG_KERNEL.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.169.44.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

Move an assert under DEBUG_KERNEL.  (Minor cleanup, saves about 3k for me.)

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

Note: I looked for a better config symbol than DEBUG_KERNEL but there
isn't currently a relevant DEBUG_NET variant and this doesn't seem
big enough to add one.  DEBUG_KERNEL is already used directly in
powerpc, parisc, and blackfin anyway.

 include/linux/rtnetlink.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bbad657..28c4025 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -782,6 +782,7 @@ extern struct netdev_queue *dev_ingress_queue_create(struct net_device *dev);
 extern void rtnetlink_init(void);
 extern void __rtnl_unlock(void);
 
+#ifdef CONFIG_DEBUG_KERNEL
 #define ASSERT_RTNL() do { \
 	if (unlikely(!rtnl_is_locked())) { \
 		printk(KERN_ERR "RTNL: assertion failed at %s (%d)\n", \
@@ -789,6 +790,9 @@ extern void __rtnl_unlock(void);
 		dump_stack(); \
 	} \
 } while(0)
+#else
+#define ASSERT_RTNL()
+#endif
 
 static inline u32 rtm_get_table(struct rtattr **rta, u8 table)
 {
