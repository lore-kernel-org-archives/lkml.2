Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2JIPXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:23:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab2JIPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH 8/9] ARM: binfmt_flat: unused variable 'persistent'
Date: Tue,  9 Oct 2012 17:23:02 +0200
Message-Id: <1349796183-30648-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VMyqPdIpDom/t/r3HEzLaFJMdLjM6B0GwUM2j+Sh1lO
 2GQ6zXUsmEu2PFt0DmXSqA6g/k7dehhEqzlXJDttzBqUcfRqe6
 0tPu+iZqVAVPB06+jahrPREVFdmt2V5ZWeEJOMLEzlSuhG6HEp
 akZd8vVZemnmOIJphmXkjZKD1SjhRcwdR4xaJqw6uxIie4UHF1
 ZhNKGgHHUDKttB6gAtJYGNuBqXayHCJL7gpa6hPGO1q72XOPyC
 swpTzZABTmOEO1Ecn6LFNUrI/0oOOYN06Y10TWhR5czbUCniV1
 FNQFnkGBQ7eLj6W+66COoiztR470U0+ICRsbTsjqQf/IjgmhId
 ZfysPpALNc2nRH3SKCW0a+nYb2/25jvBr2Tz71iWsEqwzXWMPu
 Gww6QoZvPzpdxnIuxEy+bfKWZjq5deUtIE=
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
Acked-by: Greg Ungerer <gerg@uclinux.org>
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

