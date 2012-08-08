Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2HHV2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:28:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab2HHV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:28:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 08/10] ARM: s3c24xx: enable CONFIG_BUG for tct_hammer
Date: Wed,  8 Aug 2012 23:27:56 +0200
Message-Id: <1344461278-28245-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344461278-28245-1-git-send-email-arnd@arndb.de>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Vat1lTL8eeQVlmJ752ZGk7961s+zsGSpKrtJ1Mxcwy+
 lFvl128Dkx9VqrBTxgsmBI/ORBUeK4iR5I6BuneJWPxymghHk3
 5PJeTaYgkdce8jiI6crANGaey0YzmOVXhsGiNCzPakqry7DM2x
 IFoKyFyfsSigkMGpjR0UML2IYPpOpzsJQrCaJi9uHf3bxROwEX
 /pmIGZtZheGe2l+j6bVR3gfbEdR6JMwt1w0VGJk/0GJUbmdUqa
 AL15fpMFH1VJwrJL/nmu4Pruw5O3o57kiugTvrFPVd3VpNYBha
 W4jD+LSzyYE0P2BTJ6ei28e5H6AoRQfEchv31l20ggVoL4p3rR
 FK3TYmSPcOQPOuJqoGhO2fgnSzhpWSIVsVrI0P6Ngv+1gCgmgA
 IK5VlEyY9vHjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling CONFIG_BUG creates an insane amount of build warnings, which
makes it useless to check for building defconfigs to see if new
warnings show up.

Without this patch, building tct_hammer_defconfig results in:

net/packet/af_packet.c: In function 'tpacket_rcv':
net/packet/af_packet.c:1889:30: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]
net/core/ethtool.c: In function 'ethtool_get_feature_mask':
net/core/ethtool.c:213:1: warning: control reaches end of non-void function [-Wreturn-type]
block/cfq-iosched.c: In function 'cfq_async_queue_prio':
block/cfq-iosched.c:2914:1: warning: control reaches end of non-void function [-Wreturn-type]
mm/bootmem.c: In function 'mark_bootmem':
mm/bootmem.c:352:1: warning: control reaches end of non-void function [-Wreturn-type]
net/core/dev.c: In function 'skb_warn_bad_offload':
net/core/dev.c:1904:33: warning: unused variable 'null_features' [-Wunused-variable]
drivers/mtd/chips/cfi_probe.c: In function 'cfi_chip_setup':
include/linux/mtd/cfi.h:489:3: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]
include/linux/mtd/map.h:394:11: note: 'r.x[0]' was declared here
include/linux/mtd/cfi.h:489:3: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]
(and many more)

The size of vmlinux increases by 1.78% because of this:

size obj-arm/vmlinux.nobug
   text    data     bss     dec     hex filename
   2108474  116916   55352 2280742  22cd26 obj-arm/vmlinux
size obj-arm/vmlinux.bug
   text    data     bss     dec     hex filename
   2150804  116916   53696 2321416  236c08 obj-arm/vmlinux

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 arch/arm/configs/tct_hammer_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 1d24f84..71277a1 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -7,7 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
-# CONFIG_BUG is not set
+# CONFIG_BUGVERBOSE is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_SHMEM is not set
 CONFIG_SLOB=y
-- 
1.7.10

