Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab1J3Myg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:54:36 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:36202 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1J3Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-ide@vger.kernel.org
Subject: [PATCH 01/27] ide-{cd,floppy,tape}: Do not include <linux/irq.h>
Date: Sun, 30 Oct 2011 13:48:09 +0100
Message-Id: <1319978915-10933-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
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

Remove inclusion of <linux/irq.h>, to prevent the following compile error
from happening soon:

| include/linux/irq.h:132: error: redefinition of ‘struct irq_data’
| include/linux/irq.h:286: error: redefinition of ‘struct irq_chip’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: linux-ide@vger.kernel.org
---
 drivers/ide/ide-cd.c     |    1 -
 drivers/ide/ide-floppy.c |    1 -
 drivers/ide/ide-tape.c   |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 04b0956..8126824 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -43,7 +43,6 @@
 /* For SCSI -> ATAPI command conversion */
 #include <scsi/scsi.h>
 
-#include <linux/irq.h>
 #include <linux/io.h>
 #include <asm/byteorder.h>
 #include <linux/uaccess.h>
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 61fdf54..3d42043 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -35,7 +35,6 @@
 #include <scsi/scsi_ioctl.h>
 
 #include <asm/byteorder.h>
-#include <linux/irq.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <asm/unaligned.h>
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 7ecb1ad..ce8237d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -41,7 +41,6 @@
 #include <scsi/scsi.h>
 
 #include <asm/byteorder.h>
-#include <linux/irq.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <asm/unaligned.h>
-- 
1.7.0.4

