Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0IJTU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 15:20:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57880 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0IJTU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 15:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=UY1v5EVbGMfu11l2NaQgtEJ+mgR08MjhsY9feIeG7E1HuQM0guhvaQ/o00Ty8MHjGh
         xnsUV/HqdpD1Z8IGuKv93+CoLsZML8GbMy98lcN8sGyIcI+X9y1JH1tKKbuCqhdXRqhb
         skDL4C+2HE0oFvBUoDS8dAxMhbIp0sqv2ZTIs=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, reodge@gmail.com,
        mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix macro coding style issue in adl_pci9111.c
Date: Fri, 10 Sep 2010 20:20:42 +0100
Message-Id: <1284146442-2906-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch that fixes up, macros with multiple statements should be enclosed in a do - while loop, coding style issue in the adl_pci9111.c file found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 96c4f30..18103b6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -266,19 +266,28 @@ TODO:
 	outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_8254_CONTROL)
 
 #define pci9111_8254_counter_0_set(data) \
-	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
+	do { \
+		outb(data & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
 		outb((data >> 8) & 0xFF, \
-			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0)
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
+	} while (0)
 
 #define pci9111_8254_counter_1_set(data) \
-	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
+	do { \
+		outb(data & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
 		outb((data >> 8) & 0xFF, \
-			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
+	} while (0)
 
 #define pci9111_8254_counter_2_set(data) \
-	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
+	do { \
+		outb(data & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
 		outb((data >> 8) & 0xFF, \
-			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
+	} while (0)
 
 /*  Function prototypes */
 
-- 
1.7.0.4

