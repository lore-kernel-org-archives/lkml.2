Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0JUOoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:44:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53516 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0JUOoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jHm99IBrHMaetQsJO0fXrLDLF7sXz/PsriYGPGp3DumdyEkp0+v4q4+oGyiwKS7p4f
         XhYDoMHSTOMeS2ydwS1ARW22h0+nmQ+A1IoqJqNSk2luqMWCuTn6Jpfadea7JWiNWFlr
         IsBKeFbAp012jkQFxWi96fMOvaQlLLk+lzHUk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 10/22] asm-generic: use little-endian bitops
Date: Thu, 21 Oct 2010 23:41:05 +0900
Message-Id: <1287672077-5797-11-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
No change from previous submission

 include/asm-generic/bitops/ext2-atomic.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/bitops/ext2-atomic.h b/include/asm-generic/bitops/ext2-atomic.h
index ab1c875..bcf359f 100644
--- a/include/asm-generic/bitops/ext2-atomic.h
+++ b/include/asm-generic/bitops/ext2-atomic.h
@@ -5,7 +5,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_set_le_bit((nr), (unsigned long *)(addr)); \
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -14,7 +14,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_clear_le_bit((nr), (unsigned long *)(addr)); \
 		spin_unlock(lock);			\
 		ret;					\
 	})
-- 
1.7.1.231.gd0b16

