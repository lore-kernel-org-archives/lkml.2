Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2JEO6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:58:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2JEO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Greg Ungerer <gerg@uclinux.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH 02/16] ARM: binfmt_flat: unused variable 'persistent'
Date: Fri,  5 Oct 2012 16:55:16 +0200
Message-Id: <1349448930-23976-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:K0YBM3I7f7Mt9STq6dMgB66KyM3j+bH2V2MyrD/xhj8
 zERrUt6C3Njksw55zlCDuzNT1+qCtevjH6JDY6ZLUOSzkczFhT
 PdFdG2beMYXSaOhD1mSni9uc8x+ppPWMkpoWuRfZK0YZQj9o35
 Uki048IXqy7ZN4ZLfi6nWDLTL4JBVTaKJqdPqT30o63RVU0yHN
 Hqlddu23uqcurSFTkTez2U8qVNwEcsprPFZwvezM+EALgZ931v
 0sEd1gR3Q0+/QrGlt1KH+8LIIykU7hwYw0d6kEXTK4jfcXcx07
 RgBbC9QkErv7/O9NDQVuLcBO1zgfWZhn4CE3hslvrKViguPNSg
 +nu8ELObcN+Nq4VB/txMs0kdkYTFOxMpGZr16scU5p3/UcvG4T
 uZGrxwY0bwr/LYVmxDSbbrotPrnypwheAo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flat_get_addr_from_rp() macro does not use the 'persistent' argument
on ARM, causing a harmless compiler warning. A cast to void removes
that warning.

Without this patch, building at91x40_defconfig results in:

fs/binfmt_flat.c: In function 'load_flat_file':
fs/binfmt_flat.c:746:17: warning: unused variable 'persistent' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/include/asm/flat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/flat.h b/arch/arm/include/asm/flat.h
index 59426a4..e847d23 100644
--- a/arch/arm/include/asm/flat.h
+++ b/arch/arm/include/asm/flat.h
@@ -8,7 +8,7 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags, persistent) get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, persistent) ((void)persistent,get_unaligned(rp))
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
 #define	flat_set_persistent(relval, p)		0
-- 
1.7.10

