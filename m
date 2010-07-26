Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0GZN3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:29:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:38084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0GZN3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:29:41 -0400
From: Michal Marek <mmarek@suse.cz>
To: Russell King <linux@arm.linux.org.uk>
Cc: Robert Nelson <robertcnelson@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] arm: Build with -fno-dwarf2-cfi-asm
Date: Mon, 26 Jul 2010 15:28:40 +0200
Message-Id: <1280150920-17122-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100726131122.GD23399@n2100.arm.linux.org.uk>
References: <20100726131122.GD23399@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d0679c7 restricted this workaround to powerpc only, but it turns
out that ARM needs it as well. Fixes
https://bugzilla.kernel.org/show_bug.cgi?id=16310 .

Reported-and-Tested-by: Robert Nelson <robertcnelson@gmail.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---

v2: changed commend as suggested by Mikael

---
 arch/arm/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 64ba313..730d40c 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -21,6 +21,9 @@ GZFLAGS		:=-9
 # Explicitly specifiy 32-bit ARM ISA since toolchain default can be -mthumb:
 KBUILD_CFLAGS	+=$(call cc-option,-marm,)
 
+# Never generate .eh_frame
+KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
+
 # Do not use arch/arm/defconfig - it's always outdated.
 # Select a platform tht is kept up-to-date
 KBUILD_DEFCONFIG := versatile_defconfig
-- 
1.7.1

