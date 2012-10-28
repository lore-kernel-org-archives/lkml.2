Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2J1Xi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:38:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42048 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707Ab2J1X1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:50 -0400
Message-Id: <20121028231555.816549511@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 061/105] s390: fix linker script for 31 bit builds
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
index de8fa9b..79cb51a 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -8,7 +8,7 @@
 
 #ifndef CONFIG_64BIT
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
-OUTPUT_ARCH(s390)
+OUTPUT_ARCH(s390:31-bit)
 ENTRY(_start)
 jiffies = jiffies_64 + 4;
 #else


