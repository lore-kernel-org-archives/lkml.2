Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2JZA3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:29:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:53383 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab2JZAH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 10/85] s390: fix linker script for 31 bit builds
Date: Thu, 25 Oct 2012 17:05:28 -0700
Message-Id: <20121026000032.166545448@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/boot/compressed/vmlinux.lds.S |    2 +-
 arch/s390/kernel/vmlinux.lds.S          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/boot/compressed/vmlinux.lds.S
+++ b/arch/s390/boot/compressed/vmlinux.lds.S
@@ -5,7 +5,7 @@ OUTPUT_FORMAT("elf64-s390", "elf64-s390"
 OUTPUT_ARCH(s390:64-bit)
 #else
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
-OUTPUT_ARCH(s390)
+OUTPUT_ARCH(s390:31-bit)
 #endif
 
 ENTRY(startup)
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


