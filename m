Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab2KZRMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:12:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635Ab2KZRL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 193/270] s390: fix linker script for 31 bit builds
Date: Mon, 26 Nov 2012 14:58:03 -0200
Message-Id: <1353949160-26803-194-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit c985cb37f1b39c2c8035af741a2a0b79f1fbaca7 upstream.

Because of a change in the s390 arch backend of binutils (commit 23ecd77
"Pick the default arch depending on the target size" in binutils repo)
31 bit builds will fail since the linker would now try to create 64 bit
binary output.
Fix this by setting OUTPUT_ARCH to s390:31-bit instead of s390.
Thanks to Andreas Krebbel for figuring out the issue.

Fixes this build error:

  LD      init/built-in.o
s390x-4.7.2-ld: s390:31-bit architecture of input file
 `arch/s390/kernel/head.o' is incompatible with s390:64-bit output

Cc: Andreas Krebbel <Andreas.Krebbel@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/s390/boot/compressed/vmlinux.lds.S |    2 +-
 arch/s390/kernel/vmlinux.lds.S          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/compressed/vmlinux.lds.S b/arch/s390/boot/compressed/vmlinux.lds.S
index d80f79d..8e1fb82 100644
--- a/arch/s390/boot/compressed/vmlinux.lds.S
+++ b/arch/s390/boot/compressed/vmlinux.lds.S
@@ -5,7 +5,7 @@ OUTPUT_FORMAT("elf64-s390", "elf64-s390", "elf64-s390")
 OUTPUT_ARCH(s390:64-bit)
 #else
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
-OUTPUT_ARCH(s390)
+OUTPUT_ARCH(s390:31-bit)
 #endif
 
 ENTRY(startup)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 21109c6..1343d7c 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -8,7 +8,7 @@
 
 #ifndef CONFIG_64BIT
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
-OUTPUT_ARCH(s390)
+OUTPUT_ARCH(s390:31-bit)
 ENTRY(startup)
 jiffies = jiffies_64 + 4;
 #else
-- 
1.7.9.5

