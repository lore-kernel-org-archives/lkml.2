Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0GHHRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:17:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:51533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0GHHRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:17:16 -0400
Date: Thu, 8 Jul 2010 07:16:56 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       randy.dunlap@oracle.com, dtor@mail.ru, tglx@linutronix.de,
       feng.tang@intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, dtor@mail.ru, tglx@linutronix.de,
       feng.tang@intel.com, hpa@linux.intel.com
In-Reply-To: <1278342202-10973-5-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-5-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "Input: fixup X86_MRST selects"
Message-ID: <tip-c9d46f63f8e89fd70f97b83fdc4e5d2e37d92aeb@git.kernel.org>
Git-Commit-ID: c9d46f63f8e89fd70f97b83fdc4e5d2e37d92aeb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:16:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9d46f63f8e89fd70f97b83fdc4e5d2e37d92aeb
Gitweb:     http://git.kernel.org/tip/c9d46f63f8e89fd70f97b83fdc4e5d2e37d92aeb
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Mon, 5 Jul 2010 23:03:21 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 Jul 2010 17:05:07 -0700

Revert "Input: fixup X86_MRST selects"

This reverts commit 0b28bac5aef7bd1ab213723df031e61db9ff151a.

After adding x86_platform's detection for i8042 controller, we
don't need the force dependency on !X86_MRST any more

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <1278342202-10973-5-git-send-email-feng.tang@intel.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/input/keyboard/Kconfig |    2 +-
 drivers/input/serio/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 917eec3..3525f53 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,7 +69,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86 || X86_MRST
+	tristate "AT keyboard" if EMBEDDED || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 256b9e9..3bfe8fa 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !X86_MRST
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
