Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0DVFaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:30:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1681 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab0DVFap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:30:45 -0400
Subject: [PATCH] kernel.h: Add pr_warn for symmetry to dev_warn, netdev_warn
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 22:30:43 -0700
Message-ID: <1271914243.1730.678.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logging macros are
pr_<level>, dev_<level>, netdev_<level>, and netif_<level>.
pr_ uses warning, the other use warn.

Standardize these logging macros a bit more by
adding pr_warn and pr_warn_ratelimited.

Right now, there are:

$ for level in emerg alert crit err warn warning notice info ; do \
    for prefix in pr dev netdev netif ; do \
      echo -n "${prefix}_${level}:	`git grep -w "${prefix}_${level}" | wc -l`	" ; \
    done ; \
    echo ; \
  done
pr_emerg: 	45	dev_emerg: 	4	netdev_emerg: 	1	netif_emerg: 	4	
pr_alert: 	24	dev_alert: 	36	netdev_alert: 	1	netif_alert: 	6	
pr_crit: 	24	dev_crit: 	22	netdev_crit: 	1	netif_crit: 	4	
pr_err:  	2013	dev_err: 	8467	netdev_err: 	267	netif_err: 	240	
pr_warn: 	0	dev_warn: 	1818	netdev_warn: 	126	netif_warn: 	23	
pr_warning: 	773	dev_warning: 	0	netdev_warning:	0	netif_warning: 	0	
pr_notice: 	148	dev_notice: 	111	netdev_notice: 	9	netif_notice: 	3	
pr_info: 	1717	dev_info: 	3007	netdev_info: 	101	netif_info: 	85	

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9365227..ae8e9ea 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -386,6 +386,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn pr_warning
 #define pr_notice(fmt, ...) \
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
@@ -444,6 +445,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning_ratelimited(fmt, ...) \
 	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn_ratelimited pr_warning_ratelimited
 #define pr_notice_ratelimited(fmt, ...) \
 	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info_ratelimited(fmt, ...) \


