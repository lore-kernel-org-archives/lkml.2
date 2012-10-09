Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2JIPey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:34:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2JIPei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:34:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Damm <damm@opensource.se>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 1/3] ARM: shmobile: mark shmobile_init_late as __init
Date: Tue,  9 Oct 2012 17:34:19 +0200
Message-Id: <1349796861-31164-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796861-31164-1-git-send-email-arnd@arndb.de>
References: <1349796861-31164-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:FpiJ9vM4l0whjZtL0NW2RuCCmQmvWh7Ms/CNlD8dxOW
 6GRlttO2q/4rRK4gw46pPAbP5Jkv+9Oceji07tOhU2dG7haOZJ
 MtVUUb1kxDFnrXhtF9rxSLmism4D8Ns47PeE0SISIMREdQOfON
 /VqilhurigJ9v5oRe/Wwxydwr2sa3TYXuPCkpcn8UgFjHzd3Cl
 j0JwMAE8iPIyBEbNFr9o/+/zuojBguUjLzsu7vfbZEL3MzFkJu
 v/cE83yyj6nwSbaAmYag3qds104TTxC/2M4yVS1xM6QjP0s0C8
 FmVj6ow5Ae/iEbxhirAPH8hEY4ewPu9pqMK6FwLi9dzNSVZzjO
 hZVcZOzGo2EkxhbQfPLh32DX7ahmrwlVCVLiga5bnquqxjC9RA
 CNgWzDxSFop1Z0EwiGm0vUD1MGv0TI38IU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 35f2b0bd59 "ARM: shmobile: Move definition of shmobile_init_late()
to header" moved the definition of the shmobile_init_late function, but
dropped the __init annotation, which is now causing warnings because
the function calls shmobile_suspend_init, which is also marked init.

Without this patch, building kota2_defconfig results in:

WARNING: vmlinux.o(.text+0xb7c8): Section mismatch in reference from the function shmobile_init_late() to the function .init.text:shmobile_suspend_init()
The function shmobile_init_late() references
the function __init shmobile_suspend_init().
This is often because shmobile_init_late lacks a __init
annotation or the annotation of shmobile_suspend_init is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Magnus Damm <damm@opensource.se>
Cc: Simon Horman <horms@verge.net.au>
---
 arch/arm/mach-shmobile/include/mach/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/include/mach/common.h b/arch/arm/mach-shmobile/include/mach/common.h
index ed77ab8..d47e215 100644
--- a/arch/arm/mach-shmobile/include/mach/common.h
+++ b/arch/arm/mach-shmobile/include/mach/common.h
@@ -100,7 +100,7 @@ static inline int shmobile_cpu_is_dead(unsigned int cpu) { return 1; }
 
 extern void shmobile_smp_init_cpus(unsigned int ncores);
 
-static inline void shmobile_init_late(void)
+static inline void __init shmobile_init_late(void)
 {
 	shmobile_suspend_init();
 	shmobile_cpuidle_init();
-- 
1.7.10

