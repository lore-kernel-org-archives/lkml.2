Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2KTOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:39:19 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:40644 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2KTOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:39:17 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/2] asm-generic: uaccess: allow arch to over-ride __get_user_fn()
Date: Tue, 20 Nov 2012 20:08:16 +0530
Message-ID: <1353422297-29079-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353422297-29079-1-git-send-email-vgupta@synopsys.com>
References: <1353422297-29079-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 include/asm-generic/uaccess.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 5f6ee61..432d55f 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -225,12 +225,17 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 		-EFAULT;					\
 })
 
+#ifndef __get_user_fn
 static inline int __get_user_fn(size_t size, const void __user *ptr, void *x)
 {
 	size = __copy_from_user(x, ptr, size);
 	return size ? -EFAULT : size;
 }
 
+#define __get_user_fn(sz, u, k)	__get_user_fn(sz, u, k)
+
+#endif
+
 extern int __get_user_bad(void) __attribute__((noreturn));
 
 #ifndef __copy_from_user_inatomic
-- 
1.7.4.1

