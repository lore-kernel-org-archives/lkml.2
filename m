Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2KUOXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:23:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:9168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab2KUOXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:23:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="245348648"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] kfifo: initialize fifo accordingly to C99 standard
Date: Wed, 21 Nov 2012 16:23:20 +0200
Message-Id: <1353507800-30346-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When build a kernel with "make W=1" we will get a warning about missing
initializer. It comes from kfifo usage style. The DEFINE_KFIFO macro doesn't
initialize the buf[] field of the fifo structure. So, using C99 style helps in
such case.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kfifo.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 10308c6..3de51a1 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -155,8 +155,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
 #define DEFINE_KFIFO(fifo, type, size) \
 	DECLARE_KFIFO(fifo, type, size) = \
 	(typeof(fifo)) { \
-		{ \
-			{ \
+		.kfifo = { \
 			.in	= 0, \
 			.out	= 0, \
 			.mask	= __is_kfifo_ptr(&(fifo)) ? \
@@ -166,11 +165,9 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
 			.data	= __is_kfifo_ptr(&(fifo)) ? \
 				NULL : \
 				(fifo).buf, \
-			} \
 		} \
 	}
 
-
 static inline unsigned int __must_check
 __kfifo_uint_must_check_helper(unsigned int val)
 {
-- 
1.7.10.4

