Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1AFINm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:13:42 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38737 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1AFINl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:13:41 -0500
Message-ID: <4D2579B2.7060704@parallels.com>
Date: Thu, 6 Jan 2011 02:13:38 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: <trivial@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-embedded@vger.kernel.org>
Subject: [PATCH] Move an assert under DEBUG_KERNEL.
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

Move an assert under DEBUG_KERNEL.

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

Saves about 3k from x86-64 defconfig according to scripts/bloat-o-meter.

  include/linux/rtnetlink.h |    4 ++++
  1 file changed, 4 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bbad657..28c4025 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -782,6 +782,7 @@ extern struct netdev_queue 
*dev_ingress_queue_create(struct net_device *dev);
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
