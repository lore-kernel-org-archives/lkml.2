Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab0CPIPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:15:20 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:45331 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0CPIPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:15:18 -0400
From: Arun Bhanu <arun@bhanu.net>
To: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Cc: Michal Simek <monstr@monstr.eu>, Arun Bhanu <arun@bhanu.net>
Subject: [PATCH v2] microblaze: Fix Makefile to delete build generated files
Date: Tue, 16 Mar 2010 16:16:35 +0800
Message-Id: <1268727395-7770-1-git-send-email-arun@bhanu.net>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make clean' does not to delete the following build generated file:
	arch/microblaze/boot/linux.bin.ub

'make mrproper' does not to delete the following build generated files:
	arch/microblaze/boot/simpleImage.*

Fix the Makefile to delete these build generated files.

See [1] for a discussion on why simpleImage.* files are deleted with 'make
mrproper' and not with 'make clean'.
	[1] http://lkml.org/lkml/2010/3/12/96

Signed-off-by: Arun Bhanu <arun@bhanu.net>
---
 arch/microblaze/Makefile      |    2 ++
 arch/microblaze/boot/Makefile |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index d2d6cfc..36926b9 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -93,3 +93,5 @@ define archhelp
   echo '  name of a dts file from the arch/microblaze/boot/dts/ directory'
   echo '  (minus the .dts extension).'
 endef
+
+MRPROPER_FILES += $(boot)/simpleImage.*
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 902cf98..a1fc324 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -64,4 +64,4 @@ $(obj)/%.dtb: $(dtstree)/%.dts FORCE
 
 clean-kernel += linux.bin linux.bin.gz simpleImage.*
 
-clean-files += *.dtb simpleImage.*.unstrip
+clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
-- 
1.6.2.5

