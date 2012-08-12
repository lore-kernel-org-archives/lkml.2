Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2HLOYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:24:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:59933 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2HLOX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:23:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,756,1336374000"; 
   d="scan'208";a="198736935"
Date: Sun, 12 Aug 2012 22:23:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] m68k: add generic atomic64_t support
Message-ID: <20120812142355.GA16664@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes build errors like:

fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
fs/namespace.c:2290:1: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]
fs/namespace.c:2290:1: error: initializer element is not constant
fs/namespace.c: In function 'alloc_mnt_ns':
fs/namespace.c:2299:2: error: implicit declaration of function 'atomic64_add_return' [-Werror=implicit-function-declaration]

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/m68k/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/arch/m68k/Kconfig	2012-08-12 21:15:49.730533572 +0800
+++ linux/arch/m68k/Kconfig	2012-08-12 22:19:56.202624988 +0800
@@ -12,6 +12,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select GENERIC_ATOMIC64
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
