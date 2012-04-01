Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2DAUjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:54246 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2DAUjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 11/11] asm-generic: add linux/types.h to cmpxchg.h
Date: Sun,  1 Apr 2012 16:38:47 -0400
Message-Id: <1333312727-11428-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Builds of the openrisc or1ksim_defconfig show the following:

  In file included from arch/openrisc/include/generated/asm/cmpxchg.h:1:0,
                   from include/asm-generic/atomic.h:18,
                   from arch/openrisc/include/generated/asm/atomic.h:1,
                   from include/linux/atomic.h:4,
                   from include/linux/dcache.h:4,
                   from fs/notify/fsnotify.c:19:
  include/asm-generic/cmpxchg.h: In function '__xchg':
  include/asm-generic/cmpxchg.h:34:20: error: expected ')' before 'u8'
  include/asm-generic/cmpxchg.h:34:20: warning: type defaults to 'int' in type name

and many more lines of similar errors.  It seems specific to the or32
because most other platforms have an arch specific component that would
have already included types.h ahead of time, but the o32 does not.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/asm-generic/cmpxchg.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/cmpxchg.h b/include/asm-generic/cmpxchg.h
index 8a36183..1488302 100644
--- a/include/asm-generic/cmpxchg.h
+++ b/include/asm-generic/cmpxchg.h
@@ -10,6 +10,7 @@
 #error "Cannot use generic cmpxchg on SMP"
 #endif
 
+#include <linux/types.h>
 #include <linux/irqflags.h>
 
 #ifndef xchg
-- 
1.7.9.1

