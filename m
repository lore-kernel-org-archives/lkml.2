Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2ICFWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:22:04 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52397 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:21:35 -0400
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 22:21:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 5/5] x86: Turn off DEBUG_NX_TEST module in defconfigs
Message-ID: <e72faf875e1172fb1cbec5e6d3cd4122df508a97.1346649518.git.josh@joshtriplett.org>
References: <cover.1346649518.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346649518.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 defconfigs include exactly one module: test_nx.ko, a
special-purpose module which just exists to do evil things like
executing code off the stack to see if the kernel has enabled NX
support.  Anyone who actually uses that module can easily enable it
themselves, but the vast majority of kernel builds don't need it;
disable it by default.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index a6533a2..5598547 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -298,7 +298,6 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_RODATA_TEST is not set
-CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
 CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 18f3cc4..671524d 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -297,7 +297,6 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_RODATA_TEST is not set
-CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
 CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
-- 
1.7.10.4

