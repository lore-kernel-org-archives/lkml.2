Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab1FINFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:05:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:33213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab1FINFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:05:31 -0400
Date: Thu, 9 Jun 2011 13:05:23 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-16ba9b061223c8a58b9b2e0dd01435111c4e902a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dmitry.torokhov@gmail.com, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110601180610.453577265@duck.linux-mips.net>
References: <20110601180610.453577265@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Make pcspkr input driver use the shared i8253_lock
Git-Commit-ID: 16ba9b061223c8a58b9b2e0dd01435111c4e902a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 13:05:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16ba9b061223c8a58b9b2e0dd01435111c4e902a
Gitweb:     http://git.kernel.org/tip/16ba9b061223c8a58b9b2e0dd01435111c4e902a
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:02 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 15:01:38 +0200

i8253: Make pcspkr input driver use the shared i8253_lock

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Link: http://lkml.kernel.org/r/20110601180610.453577265@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/input/misc/pcspkr.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 2aa9d90..34f4d2e 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
@@ -25,14 +26,6 @@ MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pcspkr");
 
-#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
-/* Use the global PIT lock ! */
-#include <linux/i8253.h>
-#else
-#include <asm/8253pit.h>
-static DEFINE_RAW_SPINLOCK(i8253_lock);
-#endif
-
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
 	unsigned int count = 0;
