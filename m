Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2A1XTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 18:19:23 -0500
Received: from [69.28.251.93] ([69.28.251.93]:42372 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2A1XTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 18:19:22 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jan 2012 18:19:22 EST
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] MIPS: Fix duplicate instances of ARCH_SPARSEMEM_ENABLE
Date: Sat, 28 Jan 2012 15:07:49 -0800
Message-Id: <0736d2becb10905c35eec74f04c63970@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"config ARCH_SPARSEMEM_ENABLE" exists in both arch/mips/Kconfig and
arch/mips/cavium-octeon/Kconfig, but the dependencies are not the same.
This results in warnings when a non-Cavium platform tries to select
ARCH_SPARSEMEM_ENABLE:

    $ make lemote2f_defconfig ARCH=mips
    warning: (LEMOTE_FULOONG2E && LEMOTE_MACH2F) selects ARCH_SPARSEMEM_ENABLE which has unmet direct dependencies (CPU_CAVIUM_OCTEON)
    warning: (LEMOTE_FULOONG2E && LEMOTE_MACH2F) selects ARCH_SPARSEMEM_ENABLE which has unmet direct dependencies (CPU_CAVIUM_OCTEON)
    #
    # configuration written to .config
    #

Proposed workaround is to use a Cavium-specific config option which
"select"s the desired options.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/cavium-octeon/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/Kconfig b/arch/mips/cavium-octeon/Kconfig
index f9e275a..eda8266 100644
--- a/arch/mips/cavium-octeon/Kconfig
+++ b/arch/mips/cavium-octeon/Kconfig
@@ -82,8 +82,9 @@ config CAVIUM_OCTEON_LOCK_L2_MEMCPY
 	help
 	  Lock the kernel's implementation of memcpy() into L2.
 
-config ARCH_SPARSEMEM_ENABLE
+config CAVIUM_OCTEON_SPARSEMEM_ENABLE
 	def_bool y
+	select ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_STATIC
 
 config IOMMU_HELPER
-- 
1.7.6.3

