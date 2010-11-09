Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0KIJHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:07:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52110 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0KIJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=g/zsNx5hcPHtx9/Tst9NVbGNbKuFuPMBB1+8lOX4naHoywlY7OMFadHRsc5/XmowTi
         7Ovi+briUDH6UsMr1Cz/I5lTJOu00V7ysYWH1sOC67Lx4xbnl4Pknl6HSjHDgN92xAAc
         pPBkJvYv0CIrsEba51jHWhEIH8d04wE0oXvfo=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Subject: [PATCH 3/4] ARM: add CONFIG_CRASH_DUMP to Kconfig
Date: Tue,  9 Nov 2010 11:06:12 +0200
Message-Id: <3cae99ef4ab792c1e7c632dcfa6a2c16e5d2a190.1289292124.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289292124.git.mika.westerberg@iki.fi>
References: <cover.1289292124.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1289292124.git.mika.westerberg@iki.fi>
References: <cover.1289292124.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>

Add CONFIG_CRASH_DUMP configuration option which is used by dump
capture kernels.

Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
---
 arch/arm/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..78774d9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1650,6 +1650,19 @@ config ATAGS_PROC
 	  Should the atags used to boot the kernel be exported in an "atags"
 	  file in procfs. Useful with kexec.
 
+config CRASH_DUMP
+	bool "Build kdump crash kernel (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Generate crash dump after being started by kexec. This should
+	  be normally only set in special crash dump kernels which are
+	  loaded in the main kernel with kexec-tools into a specially
+	  reserved region and then later executed after a crash by
+	  kdump/kexec. The crash dump kernel must be compiled to a
+	  memory address not used by the main kernel
+
+	  For more details see Documentation/kdump/kdump.txt
+
 config AUTO_ZRELADDR
 	bool "Auto calculation of the decompressed kernel image address"
 	depends on !ZBOOT_ROM && !ARCH_U300
-- 
1.7.2.3

