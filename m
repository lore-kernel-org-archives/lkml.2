Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1AJIfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:35:39 -0500
Received: from mx2.parallels.com ([64.131.90.16]:42498 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1AJIfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:35:37 -0500
Message-ID: <4D2AC4D5.5070503@parallels.com>
Date: Mon, 10 Jan 2011 02:35:33 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <trivial@kernel.org>, <linux-net@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>
Subject: [PATCH] Move an assert under DEBUG_KERNEL. (attempt 2)
References: <4D2579B2.7060704@parallels.com> <20110106154120.b69118c9.akpm@linux-foundation.org>
In-Reply-To: <20110106154120.b69118c9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 05:41 PM, Andrew Morton wrote:
> Probably a worthwhile thing to do, IMO.  If there's some net-specific
> CONFIG_DEBUG_ setting then that wold be a better thing to use.
> 
> However the patch was a) wordwrapped, b) space-stuffed and c) not cc'ed
> to the networking list.  So its prospects are dim.

Ok, either I've beaten thunderbird into submission, or I'll be submitting a patch to Documentation/email-clients.txt.  (Whether or not I need to find a different smtp server to send this through remains an open question.)

(Confirming: I looked for a more specific DEBUG symbol, but couldn't find one.  I can add one, but this seems a bit small to have its own symbol, and DEBUG_KERNEL is already used in a few *.c files.)

From: Rob Landley <rlandley@parallels.com>

Move an assert under DEBUG_KERNEL.  (Minor cleanup to save a few bytes.)

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

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
