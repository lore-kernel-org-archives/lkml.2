Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab1IKMG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:06:28 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42683 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab1IKMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/28] keyboard: Do not include <linux/irq.>
Date: Sun, 11 Sep 2011 13:59:29 +0200
Message-Id: <1315742394-16036-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The top of <linux/irq.h> has this comment:

 * Please do not include this file in generic code.  There is currently
 * no requirement for any architecture to implement anything held
 * within this file.
 *
 * Thanks. --rmk

Remove inclusion of <linux/irq.>, to prevent the following compile error
from happening soon:

| include/linux/irq.h:132: error: redefinition of ‘struct irq_data’
| include/linux/irq.h:286: error: redefinition of ‘struct irq_chip’

drivers/tty/vt/keyboard.c needs to include <asm/irq_regs.h> for get_irq_regs():

| drivers/tty/vt/keyboard.c:497: error: implicit declaration of function ‘get_irq_regs’
| drivers/tty/vt/keyboard.c:497: warning: initialization makes pointer from integer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/vt/keyboard.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 3761ccf..a605549 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -33,7 +33,6 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/irq.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -43,6 +42,8 @@
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
 
+#include <asm/irq_regs.h>
+
 extern void ctrl_alt_del(void);
 
 /*
-- 
1.7.0.4

