Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1KCGqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:46:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53977 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1KCGp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:45:58 -0400
Message-ID: <1320302748.17983.0.camel@phoenix>
Subject: [PATCH] hwspinlock: Don't return a value in __hwspin_unlock
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 03 Nov 2011 14:45:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning:

  CC      arch/arm/mach-omap2/hwspinlock.o
In file included from arch/arm/mach-omap2/hwspinlock.c:22:
include/linux/hwspinlock.h: In function '__hwspin_unlock':
include/linux/hwspinlock.h:121: warning: 'return' with a value, in function returning void

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 include/linux/hwspinlock.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index 08a2fee..aad6bd4 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -118,7 +118,6 @@ int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 static inline
 void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 {
-	return 0;
 }
 
 static inline int hwspin_lock_get_id(struct hwspinlock *hwlock)
-- 
1.7.5.4



