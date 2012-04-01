Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2DAUlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:41:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:54110 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2DAUjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 01/11] irq_work: fix compile failure on MIPS from system.h split
Date: Sun,  1 Apr 2012 16:38:37 -0400
Message-Id: <1333312727-11428-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Builds of the MIPS platform ip32_defconfig fails as of
commit 0195c00244dc2e9f522475868fa278c473ba7339

    "Merge tag 'split-asm_system_h-for-linus-20120328' ..."

because MIPS xchg() macro uses BUILD_BUG_ON and it was moved
in commit b81947c646bfefdf98e2fde5d7d39cbbda8525d4

    "Disintegrate asm/system.h for MIPS"

The root cause is that the system.h split wasn't tested on
a baseline with commit 6c03438edeb5c359af35f060ea016ca65671c269

    "kernel.h: doesn't explicitly use bug.h, so don't include it."

Since this file uses BUG code in several other places besides
the xchg call, simply make the inclusion explicit.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq_work.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index c3c46c7..0c56d44 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -5,6 +5,7 @@
  * context. The enqueueing is NMI-safe.
  */
 
+#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/irq_work.h>
-- 
1.7.9.1

