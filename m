Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0GHHQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:51512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0GHHQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:16:57 -0400
Date: Thu, 8 Jul 2010 07:16:38 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dtor@mail.ru, tglx@linutronix.de, feng.tang@intel.com,
       jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dtor@mail.ru, tglx@linutronix.de, feng.tang@intel.com,
       jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1278342202-10973-4-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-4-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "Input: do not force selecting i8042 on Moorestown"
Message-ID: <tip-44631ac64d06d2f7ce006c2a6f2c8e003a9c6ace@git.kernel.org>
Git-Commit-ID: 44631ac64d06d2f7ce006c2a6f2c8e003a9c6ace
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:16:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44631ac64d06d2f7ce006c2a6f2c8e003a9c6ace
Gitweb:     http://git.kernel.org/tip/44631ac64d06d2f7ce006c2a6f2c8e003a9c6ace
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Mon, 5 Jul 2010 23:03:20 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 Jul 2010 17:05:06 -0700

Revert "Input: do not force selecting i8042 on Moorestown"

This reverts commit 685afae02557a178185a4be36f58332976e79f63.

After adding x86_platform's detection for i8042 controller, we
don't need the force dependency on !X86_MRST any more

Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <1278342202-10973-4-git-send-email-feng.tang@intel.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/input/keyboard/Kconfig |    2 +-
 drivers/input/mouse/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 0f9a478..917eec3 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -73,7 +73,7 @@ config KEYBOARD_ATKBD
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index eeb58c1..c714ca2 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
