Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2DGALf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:11:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2DGALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:11:31 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] module: Clarify GPL-Compatible is OK
Date: Fri,  6 Apr 2012 17:11:22 -0700
Message-Id: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

While the kernel is GPLv2 individual files and modules have
historically been allowed to be:

  * Dual BSD/GPL
  * Dual MIT/GPL
  * Dual MPL/GPL

This is done for several reasons but most importantly to be able to
share between Linux and permissive licensed Operating Systems such
as the BSDs.

You do not need to make dual licenses when licenses are compatible
with each other, and in fact at times this can confuse developers / legal.
This has been well documented by SFLC through their "Maintaining
Permissive-Licensed Files in a GPL-Licensed Project: Guidelines for
Developers" [0] which was inspired by the ambiguity of the MadWifi
Project's Dual BSD/GPL license tradition. The list of GPL-Compatible
licenses can be found on the FSF's website [1].

Lets help move out of the stone age and instead of extending this list
with more permissive licenses add a simple "GPL-Compatible" tag for use by
any GPL-Compatible licensed module. Given that vendors tend to grep existing
drivers for what they do also change all drivers to use the simple tag but
leave in place the old checks in case external drivers are using this. Moving
forward GPL-Compatible modules should rely on this simple new tag instead
of using the old tags or looking to add a new GPL-Compatible text descring
that license.

[0] http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
[1] http://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses

Cc: Keith Packard <keithp@keithp.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 crypto/aes_generic.c                               |    2 +-
 crypto/cts.c                                       |    2 +-
 crypto/fcrypt.c                                    |    2 +-
 drivers/block/xen-blkback/blkback.c                |    2 +-
 drivers/char/pcmcia/cm4000_cs.c                    |    2 +-
 drivers/char/pcmcia/cm4040_cs.c                    |    2 +-
 drivers/dma/ioat/pci.c                             |    2 +-
 drivers/ide/ide-cs.c                               |    2 +-
 drivers/infiniband/core/addr.c                     |    2 +-
 drivers/infiniband/core/cm.c                       |    2 +-
 drivers/infiniband/core/cma.c                      |    2 +-
 drivers/infiniband/core/device.c                   |    2 +-
 drivers/infiniband/core/iwcm.c                     |    2 +-
 drivers/infiniband/core/mad.c                      |    2 +-
 drivers/infiniband/core/sa_query.c                 |    2 +-
 drivers/infiniband/core/ucm.c                      |    2 +-
 drivers/infiniband/core/ucma.c                     |    2 +-
 drivers/infiniband/core/user_mad.c                 |    2 +-
 drivers/infiniband/core/uverbs_main.c              |    2 +-
 drivers/infiniband/hw/amso1100/c2.c                |    2 +-
 drivers/infiniband/hw/cxgb3/iwch.c                 |    2 +-
 drivers/infiniband/hw/cxgb4/device.c               |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |    2 +-
 drivers/infiniband/hw/mlx4/main.c                  |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |    2 +-
 drivers/infiniband/hw/nes/nes.c                    |    2 +-
 drivers/infiniband/hw/qib/qib_driver.c             |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/input/keyboard/hil_kbd.c                   |    2 +-
 drivers/input/misc/hp_sdc_rtc.c                    |    2 +-
 drivers/input/serio/hil_mlc.c                      |    2 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/serio/hp_sdc_mlc.c                   |    2 +-
 drivers/isdn/hisax/elsa_cs.c                       |    2 +-
 drivers/isdn/hisax/sedlbauer_cs.c                  |    2 +-
 drivers/isdn/i4l/isdn_bsdcomp.c                    |    2 +-
 drivers/media/video/vivi.c                         |    2 +-
 drivers/mtd/ftl.c                                  |    2 +-
 drivers/net/can/sja1000/sja1000.c                  |    2 +-
 drivers/net/can/vcan.c                             |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |    2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |    2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    2 +-
 drivers/net/ppp/bsd_comp.c                         |    2 +-
 drivers/net/ppp/ppp_deflate.c                      |    2 +-
 drivers/net/ppp/ppp_mppe.c                         |    2 +-
 drivers/net/slip/slhc.c                            |    2 +-
 drivers/net/usb/cdc_ncm.c                          |    2 +-
 drivers/net/usb/ipheth.c                           |    2 +-
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/airo_cs.c                     |    2 +-
 drivers/net/wireless/ath/ath5k/base.c              |    2 +-
 drivers/net/wireless/ath/ath6kl/core.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    2 +-
 drivers/net/wireless/ath/ath9k/common.c            |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 drivers/net/wireless/ath/main.c                    |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |    2 +-
 drivers/net/wireless/orinoco/airport.c             |    2 +-
 drivers/net/wireless/orinoco/main.c                |    2 +-
 drivers/net/wireless/orinoco/orinoco_cs.c          |    2 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c      |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |    2 +-
 drivers/net/wireless/orinoco/spectrum_cs.c         |    2 +-
 drivers/net/xen-netback/netback.c                  |    2 +-
 drivers/parisc/power.c                             |    2 +-
 drivers/parport/parport_cs.c                       |    2 +-
 drivers/pcmcia/i82365.c                            |    2 +-
 drivers/pcmcia/m32r_cfc.c                          |    2 +-
 drivers/pcmcia/m32r_pcc.c                          |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c                       |    2 +-
 drivers/pcmcia/sa1100_generic.c                    |    2 +-
 drivers/pcmcia/sa11xx_base.c                       |    2 +-
 drivers/pcmcia/soc_common.c                        |    2 +-
 drivers/pcmcia/tcic.c                              |    2 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    2 +-
 drivers/scsi/aic7xxx_old.c                         |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    2 +-
 drivers/scsi/isci/init.c                           |    2 +-
 drivers/scsi/pcmcia/aha152x_stub.c                 |    2 +-
 drivers/scsi/pcmcia/fdomain_stub.c                 |    2 +-
 drivers/staging/et131x/et131x.c                    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    2 +-
 drivers/staging/rtl8192u/ieee80211/aes.c           |    2 +-
 drivers/staging/slicoss/slicoss.c                  |    2 +-
 drivers/staging/wlags49_h2/wl_main.c               |    2 +-
 drivers/staging/wlan-ng/prism2sta.c                |    2 +-
 drivers/staging/zram/zram_drv.c                    |    2 +-
 drivers/tty/nozomi.c                               |    2 +-
 drivers/tty/rocket.c                               |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/dwc3/core.c                            |    2 +-
 drivers/usb/dwc3/dwc3-omap.c                       |    2 +-
 drivers/usb/dwc3/dwc3-pci.c                        |    2 +-
 drivers/usb/gadget/file_storage.c                  |    2 +-
 drivers/video/intelfb/intelfbdrv.c                 |    2 +-
 drivers/xen/xen-pciback/pci_stub.c                 |    2 +-
 fs/freevxfs/vxfs_super.c                           |    2 +-
 fs/nls/nls_ascii.c                                 |    2 +-
 fs/nls/nls_base.c                                  |    2 +-
 fs/nls/nls_cp1250.c                                |    2 +-
 fs/nls/nls_cp1251.c                                |    2 +-
 fs/nls/nls_cp1255.c                                |    2 +-
 fs/nls/nls_cp437.c                                 |    2 +-
 fs/nls/nls_cp737.c                                 |    2 +-
 fs/nls/nls_cp775.c                                 |    2 +-
 fs/nls/nls_cp850.c                                 |    2 +-
 fs/nls/nls_cp852.c                                 |    2 +-
 fs/nls/nls_cp855.c                                 |    2 +-
 fs/nls/nls_cp857.c                                 |    2 +-
 fs/nls/nls_cp860.c                                 |    2 +-
 fs/nls/nls_cp861.c                                 |    2 +-
 fs/nls/nls_cp862.c                                 |    2 +-
 fs/nls/nls_cp863.c                                 |    2 +-
 fs/nls/nls_cp864.c                                 |    2 +-
 fs/nls/nls_cp865.c                                 |    2 +-
 fs/nls/nls_cp866.c                                 |    2 +-
 fs/nls/nls_cp869.c                                 |    2 +-
 fs/nls/nls_cp874.c                                 |    2 +-
 fs/nls/nls_cp932.c                                 |    2 +-
 fs/nls/nls_cp936.c                                 |    2 +-
 fs/nls/nls_cp949.c                                 |    2 +-
 fs/nls/nls_cp950.c                                 |    2 +-
 fs/nls/nls_euc-jp.c                                |    2 +-
 fs/nls/nls_iso8859-1.c                             |    2 +-
 fs/nls/nls_iso8859-13.c                            |    2 +-
 fs/nls/nls_iso8859-14.c                            |    2 +-
 fs/nls/nls_iso8859-15.c                            |    2 +-
 fs/nls/nls_iso8859-2.c                             |    2 +-
 fs/nls/nls_iso8859-3.c                             |    2 +-
 fs/nls/nls_iso8859-4.c                             |    2 +-
 fs/nls/nls_iso8859-5.c                             |    2 +-
 fs/nls/nls_iso8859-6.c                             |    2 +-
 fs/nls/nls_iso8859-7.c                             |    2 +-
 fs/nls/nls_iso8859-9.c                             |    2 +-
 fs/nls/nls_koi8-r.c                                |    2 +-
 fs/nls/nls_koi8-ru.c                               |    2 +-
 fs/nls/nls_koi8-u.c                                |    2 +-
 fs/nls/nls_utf8.c                                  |    2 +-
 include/linux/license.h                            |    1 +
 include/linux/module.h                             |   26 +++++++++++++-------
 lib/cordic.c                                       |    2 +-
 lib/crc8.c                                         |    2 +-
 lib/test-kstrtox.c                                 |    2 +-
 net/9p/trans_rdma.c                                |    2 +-
 net/can/af_can.c                                   |    2 +-
 net/can/bcm.c                                      |    2 +-
 net/can/gw.c                                       |    2 +-
 net/can/raw.c                                      |    2 +-
 net/rds/af_rds.c                                   |    2 +-
 net/rds/rdma_transport.c                           |    2 +-
 net/rds/tcp.c                                      |    2 +-
 net/sunrpc/xprtrdma/svc_rdma.c                     |    2 +-
 net/sunrpc/xprtrdma/transport.c                    |    2 +-
 net/tipc/core.c                                    |    2 +-
 sound/drivers/opl4/opl4_seq.c                      |    2 +-
 sound/usb/midi.c                                   |    2 +-
 177 files changed, 193 insertions(+), 184 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index a68c73d..1bdf8c1 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1474,5 +1474,5 @@ module_init(aes_init);
 module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("aes");
diff --git a/crypto/cts.c b/crypto/cts.c
index ccf9c5d..60884da 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -349,5 +349,5 @@ static void __exit crypto_cts_module_exit(void)
 module_init(crypto_cts_module_init);
 module_exit(crypto_cts_module_exit);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("CTS-CBC CipherText Stealing for CBC");
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index c33107e..ffcecaa 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -418,6 +418,6 @@ static void __exit fcrypt_mod_fini(void)
 module_init(fcrypt_mod_init);
 module_exit(fcrypt_mod_fini);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("FCrypt Cipher Algorithm");
 MODULE_AUTHOR("David Howells <dhowells@redhat.com>");
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 0088bf6..64918f9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -899,5 +899,5 @@ static int __init xen_blkif_init(void)
 
 module_init(xen_blkif_init);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("xen-backend:vbd");
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index a758486..fd1283d 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1921,4 +1921,4 @@ static void __exit cmm_exit(void)
 
 module_init(cmm_init);
 module_exit(cmm_exit);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 8dd48a2..4c9e7e1 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -684,4 +684,4 @@ static void __exit cm4040_exit(void)
 
 module_init(cm4040_init);
 module_exit(cm4040_exit);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 5e3a40f..f35d455 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -37,7 +37,7 @@
 #include "hw.h"
 
 MODULE_VERSION(IOAT_DMA_VERSION);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Intel Corporation");
 
 static struct pci_device_id ioat_pci_tbl[] = {
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 28e344e..9b9c1c8 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -55,7 +55,7 @@
 
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("PCMCIA ATA/IDE card driver");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*====================================================================*/
 
diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 6ef660c..ccf827f 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -48,7 +48,7 @@
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("IB Address Translation");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 struct addr_req {
 	struct list_head list;
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c889aae..cd40c17 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -54,7 +54,7 @@
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("InfiniBand CM");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static void cm_add_one(struct ib_device *device);
 static void cm_remove_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e3e470f..5d02dcc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -56,7 +56,7 @@
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #define CMA_CM_RESPONSE_TIMEOUT 20
 #define CMA_MAX_CM_RETRIES 15
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index e711de4..fb9afdd 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -44,7 +44,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("core kernel InfiniBand API");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 struct ib_client_data {
 	struct list_head  list;
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 0bb99bb..a50db9a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -54,7 +54,7 @@
 
 MODULE_AUTHOR("Tom Tucker");
 MODULE_DESCRIPTION("iWARP CM");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static struct workqueue_struct *iwcm_wq;
 struct iwcm_work {
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 426bb76..6101d35 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -43,7 +43,7 @@
 #include "smi.h"
 #include "agent.h"
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("kernel IB MAD API");
 MODULE_AUTHOR("Hal Rosenstock");
 MODULE_AUTHOR("Sean Hefty");
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index fbbfa24..b50cb606 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -49,7 +49,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand subnet administration query support");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 struct ib_sa_sm_ah {
 	struct ib_ah        *ah;
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 06f0871..f36cd01 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -54,7 +54,7 @@
 
 MODULE_AUTHOR("Libor Michalek");
 MODULE_DESCRIPTION("InfiniBand userspace Connection Manager access");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 struct ib_ucm_device {
 	int			devnum;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 5861cdb..5499c05 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -50,7 +50,7 @@
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("RDMA Userspace Connection Manager Access");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static unsigned int max_backlog = 1024;
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f..d7dbb03 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -55,7 +55,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace MAD packet access");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 enum {
 	IB_UMAD_MAX_PORTS  = 64,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 604556d..b63970b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -52,7 +52,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 enum {
 	IB_UVERBS_MAJOR       = 231,
diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 5ce7b9e..4ca4413 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -60,7 +60,7 @@
 
 MODULE_AUTHOR("Tom Tucker <tom@opengridcomputing.com>");
 MODULE_DESCRIPTION("Ammasso AMSO1100 Low-level iWARP Driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK
diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 8e77dc5..06c0911 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -44,7 +44,7 @@
 
 MODULE_AUTHOR("Boyd Faulkner, Steve Wise");
 MODULE_DESCRIPTION("Chelsio T3 RDMA Driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 static void open_rnic_dev(struct t3cdev *);
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 6d0df6e..e31b2e7 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -41,7 +41,7 @@
 
 MODULE_AUTHOR("Steve Wise");
 MODULE_DESCRIPTION("Chelsio T4 RDMA Driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 static LIST_HEAD(uld_ctx_list);
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 832e7a7..1c19df0 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -54,7 +54,7 @@
 
 #define HCAD_VERSION "0029"
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
 MODULE_VERSION(HCAD_VERSION);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75d3056..1249b17 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -56,7 +56,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 static const char mlx4_ib_version[] =
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index aa12a53..1f7349f 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -48,7 +48,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox InfiniBand HCA low-level driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 #ifdef CONFIG_INFINIBAND_MTHCA_DEBUG
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 7140199..66281e1 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -62,7 +62,7 @@
 
 MODULE_AUTHOR("NetEffect");
 MODULE_DESCRIPTION("NetEffect RNIC Low-level iWARP Driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 int max_mtu = 9000;
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 6fc9365..bab4746 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -61,7 +61,7 @@ module_param_named(compat_ddr_negotiate, qib_compat_ddr_negotiate, uint,
 MODULE_PARM_DESC(compat_ddr_negotiate,
 		 "Attempt pre-IBTA 1.2 DDR speed negotiation");
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("QLogic <support@qlogic.com>");
 MODULE_DESCRIPTION("QLogic IB driver");
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3974c29..a86aa8c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -50,7 +50,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("IP-over-InfiniBand net driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 int ipoib_sendq_size __read_mostly = IPOIB_TX_RING_SIZE;
 int ipoib_recvq_size __read_mostly = IPOIB_RX_RING_SIZE;
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index db43b31..1d1dc47 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -84,7 +84,7 @@ int iser_debug_level = 0;
 
 MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover "
 		   "v" DRV_VER " (" DRV_DATE ")");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Alex Nezhinsky, Dan Bar Dov, Or Gerlitz");
 
 module_param_named(debug_level, iser_debug_level, int, 0644);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bcbf22e..c21e33c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -59,7 +59,7 @@
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator "
 		   "v" DRV_VERSION " (" DRV_RELDATE ")");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 69e2ad0..c8b6fcd 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -62,7 +62,7 @@
 MODULE_AUTHOR("Vu Pham and Bart Van Assche");
 MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol target "
 		   "v" DRV_VERSION " (" DRV_RELDATE ")");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*
  * Global Variables
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index 589e3c2..0e48e53 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("HIL keyboard/mouse driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("serio:ty03pr25id00ex*"); /* HIL keyboard */
 MODULE_ALIAS("serio:ty03pr25id0Fex*"); /* HIL mouse */
 
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 0b4f542..818e875 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -48,7 +48,7 @@
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("HP i8042 SDC + MSM-58321 RTC Driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #define RTC_VERSION "1.10d"
 
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index bfd3865..bcab8cf 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -64,7 +64,7 @@
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("HIL MLC serio");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 EXPORT_SYMBOL(hil_mlc_register);
 EXPORT_SYMBOL(hil_mlc_unregister);
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 09a0899..3806dd0 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -90,7 +90,7 @@
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("HP i8042-based SDC Driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 EXPORT_SYMBOL(hp_sdc_request_timer_irq);
 EXPORT_SYMBOL(hp_sdc_request_hil_irq);
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index d50f067..139b0a7 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -48,7 +48,7 @@ static hil_mlc hp_sdc_mlc;
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("Glue for onboard HIL MLC in HP-PARISC machines");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static struct hp_sdc_mlc_priv_s {
 	int emtestmode;
diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index a8c4d3f..532ca18 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -52,7 +52,7 @@
 
 MODULE_DESCRIPTION("ISDN4Linux: PCMCIA client driver for Elsa PCM cards");
 MODULE_AUTHOR("Klaus Lichtenwalder");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 
 /*====================================================================*/
diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index f0dfc0c..8c5465c 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -52,7 +52,7 @@
 
 MODULE_DESCRIPTION("ISDN4Linux: PCMCIA client driver for Sedlbauer cards");
 MODULE_AUTHOR("Marcus Niemann");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 
 /*====================================================================*/
diff --git a/drivers/isdn/i4l/isdn_bsdcomp.c b/drivers/isdn/i4l/isdn_bsdcomp.c
index c59e8d2..bcb183d 100644
--- a/drivers/isdn/i4l/isdn_bsdcomp.c
+++ b/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -93,7 +93,7 @@
 #include "isdn_ppp.h"
 
 MODULE_DESCRIPTION("ISDN4Linux: BSD Compression for PPP over ISDN");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #define BSD_VERSION(x)	((x) >> 5)
 #define BSD_NBITS(x)	((x) & 0x1F)
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index b456d3e..1c60204 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -48,7 +48,7 @@
 
 MODULE_DESCRIPTION("Video Technology Magazine Virtual Video Capture Board");
 MODULE_AUTHOR("Mauro Carvalho Chehab, Ted Walther and John Sokol");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(VIVI_VERSION);
 
 static unsigned video_nr = -1;
diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 19d6372..631960e 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -1113,6 +1113,6 @@ module_init(init_ftl);
 module_exit(cleanup_ftl);
 
 
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("Support code for Flash Translation Layer, used on PCMCIA devices");
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 5e10472..b5f1f87 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -66,7 +66,7 @@
 #define DRV_NAME "sja1000"
 
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION(DRV_NAME "CAN netdevice driver");
 
 static struct can_bittiming_const sja1000_bittiming_const = {
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index ea2d942..d7b9a3c 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -53,7 +53,7 @@ static __initdata const char banner[] =
 	KERN_INFO "vcan: Virtual CAN interface driver\n";
 
 MODULE_DESCRIPTION("virtual CAN interface");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>");
 
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 63bfdd1..d21a01b 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -101,7 +101,7 @@ static DEFINE_PCI_DEVICE_TABLE(cxgb3_pci_tbl) = {
 
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Chelsio Communications");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, cxgb3_pci_tbl);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index b126b98..17170fb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -205,7 +205,7 @@ static DEFINE_PCI_DEVICE_TABLE(cxgb4_pci_tbl) = {
 
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Chelsio Communications");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, cxgb4_pci_tbl);
 MODULE_FIRMWARE(FW_FNAME);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 25e3308..4b16318 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2897,7 +2897,7 @@ static struct pci_device_id cxgb4vf_pci_tbl[] = {
 
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Chelsio Communications");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, cxgb4vf_pci_tbl);
 
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index 360a578..447993a 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -157,4 +157,4 @@ struct platform_driver mpc52xx_fec_mdio_driver = {
 /* let fec driver call it, since this has to be registered before it */
 EXPORT_SYMBOL_GPL(mpc52xx_fec_mdio_driver);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 2097a7d..2f1afe1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("Liran Liss, Yevgeny Petrilin");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA Ethernet driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION " ("DRV_RELDATE")");
 
 static const char mlx4_en_version[] =
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 8bb05b4..6d06cd4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -51,7 +51,7 @@
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA low-level driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(DRV_VERSION);
 
 struct workqueue_struct *mlx4_wq;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 27273ae..3677ce1 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -84,7 +84,7 @@
 MODULE_DESCRIPTION("Myricom 10G driver (10GbE)");
 MODULE_AUTHOR("Maintainer: help@myri.com");
 MODULE_VERSION(MYRI10GE_VERSION_STR);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #define MYRI10GE_MAX_ETHER_MTU 9014
 
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index ef76725..2bd2102 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -59,7 +59,7 @@
 #include "vxge-main.h"
 #include "vxge-reg.h"
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("Neterion's X3100 Series 10GbE PCIe I/O"
 	"Virtualized Server Adapter");
 
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 94a1f94..4681577 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -231,7 +231,7 @@ static const char *if_names[] = { "Auto", "10BaseT", "10Base2", "AUI", "100BaseT
 /* Module parameters */
 
 MODULE_DESCRIPTION("Xircom PCMCIA ethernet driver");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0)
 
diff --git a/drivers/net/ppp/bsd_comp.c b/drivers/net/ppp/bsd_comp.c
index a9b759a..55facfa 100644
--- a/drivers/net/ppp/bsd_comp.c
+++ b/drivers/net/ppp/bsd_comp.c
@@ -1166,5 +1166,5 @@ static void __exit bsdcomp_cleanup(void)
 
 module_init(bsdcomp_init);
 module_exit(bsdcomp_cleanup);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_BSD_COMPRESS));
diff --git a/drivers/net/ppp/ppp_deflate.c b/drivers/net/ppp/ppp_deflate.c
index 602c625..7f7123d 100644
--- a/drivers/net/ppp/ppp_deflate.c
+++ b/drivers/net/ppp/ppp_deflate.c
@@ -626,6 +626,6 @@ static void __exit deflate_cleanup(void)
 
 module_init(deflate_init);
 module_exit(deflate_cleanup);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_DEFLATE));
 MODULE_ALIAS("ppp-compress-" __stringify(CI_DEFLATE_DRAFT));
diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index 9a1849a..bfc3811 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -61,7 +61,7 @@
 
 MODULE_AUTHOR("Frank Cusack <fcusack@fcusack.com>");
 MODULE_DESCRIPTION("Point-to-Point Protocol Microsoft Point-to-Point Encryption support");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
 MODULE_VERSION("1.0.2");
 
diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index 1252d9c..ddad16a 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -738,4 +738,4 @@ EXPORT_SYMBOL(slhc_compress);
 EXPORT_SYMBOL(slhc_uncompress);
 EXPORT_SYMBOL(slhc_toss);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 7adc9f6..cf5f4b1 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1228,4 +1228,4 @@ module_usb_driver(cdc_ncm_driver);
 
 MODULE_AUTHOR("Hans Petter Selasky");
 MODULE_DESCRIPTION("USB CDC NCM host driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index dd78c4c..b613aed 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -552,4 +552,4 @@ module_usb_driver(ipheth_driver);
 
 MODULE_AUTHOR("Diego Giagio <diego@giagio.com>");
 MODULE_DESCRIPTION("Apple iPhone USB Ethernet driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 520a4b2..a1de705 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -243,7 +243,7 @@ static int proc_perm = 0644;
 MODULE_AUTHOR("Benjamin Reed");
 MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet cards.  "
 		   "Direct support for ISA/PCI/MPI cards and support for PCMCIA when used with airo_cs.");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340/350");
 module_param_array(io, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index 630577d..c76a2b6 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -47,7 +47,7 @@ MODULE_AUTHOR("Benjamin Reed");
 MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet "
 		   "cards.  This is the module that links the PCMCIA card "
 		   "with the airo module.");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340 PCMCIA cards");
 
 /*====================================================================*/
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 0e643b0..8ff6136 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -91,7 +91,7 @@ MODULE_AUTHOR("Jiri Slaby");
 MODULE_AUTHOR("Nick Kossifidis");
 MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static int ath5k_init(struct ieee80211_hw *hw);
 static int ath5k_reset(struct ath5k_hw *ah, struct ieee80211_channel *chan,
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 45e641f..6550141 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -296,4 +296,4 @@ EXPORT_SYMBOL(ath6kl_core_destroy);
 
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_DESCRIPTION("Core module for AR600x SDIO and USB devices.");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5352864..5b3212f 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1439,7 +1439,7 @@ module_exit(ath6kl_sdio_exit);
 
 MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x SDIO devices");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 MODULE_FIRMWARE(AR6003_HW_2_0_FW_DIR "/" AR6003_HW_2_0_OTP_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_0_FW_DIR "/" AR6003_HW_2_0_FIRMWARE_FILE);
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 325b122..ac3a28f 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -423,7 +423,7 @@ module_exit(ath6kl_usb_exit);
 
 MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x USB devices");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_FIRMWARE(AR6004_HW_1_0_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_0_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 905f1b3..c65b4fd 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -25,7 +25,7 @@
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 int ath9k_cmn_padpos(__le16 frame_control)
 {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index de5ee15..0a66fa7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -17,7 +17,7 @@
 #include "htc.h"
 
 MODULE_AUTHOR("Atheros Communications");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("Atheros driver 802.11n HTC based wireless devices");
 
 static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6c69e4e..c6129f6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -30,7 +30,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 802.11n WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static int __init ath9k_init(void)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cb00645..13fb9dd 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -26,7 +26,7 @@ static char *dev_info = "ath9k";
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 802.11n WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index ea2c737..14e54be 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -21,7 +21,7 @@
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless LAN cards.");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 				u32 len,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2a1e5ae..ec2610f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -49,7 +49,7 @@
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 
 /* Interface control information */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 8236422..9150623 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -163,7 +163,7 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac usb driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac usb cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static struct brcmf_usbdev *brcmf_usb_get_buspub(struct device *dev)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 569ab8a..e0b0e62 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -86,7 +86,7 @@ static int n_adapters_found;
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 
 /* recognized BCMA Core IDs */
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index b45ab34..8bd99a3 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -24,7 +24,7 @@
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver utilities.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 struct sk_buff *brcmu_pkt_buf_get_skb(uint len)
 {
diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 0ca8b14..1094625 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -226,7 +226,7 @@ static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 	" (Benjamin Herrenschmidt <benh@kernel.crashing.org>)";
 MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
 MODULE_DESCRIPTION("Driver for the Apple Airport wireless card.");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static struct of_device_id airport_match[] = {
 	{
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 88e3ad2..72c2b1c 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -111,7 +111,7 @@ MODULE_AUTHOR("Pavel Roskin <proski@gnu.org> & "
 	      "David Gibson <hermes@gibson.dropbear.id.au>");
 MODULE_DESCRIPTION("Driver for Lucent Orinoco, Prism II based "
 		   "and similar wireless cards");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /* Level of debugging. Used in the macros in orinoco.h */
 #ifdef ORINOCO_DEBUG
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index d7dbc00..f83715b 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -30,7 +30,7 @@
 MODULE_AUTHOR("David Gibson <hermes@gibson.dropbear.id.au>");
 MODULE_DESCRIPTION("Driver for PCMCIA Lucent Orinoco,"
 		   " Prism II based and similar wireless cards");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /* Module parameters */
 
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index 326396b..e0dd299 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -297,7 +297,7 @@ static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 	" (Tobias Hoffmann & Christoph Jungegger <disdos@traum404.de>)";
 MODULE_AUTHOR("Christoph Jungegger <disdos@traum404.de>");
 MODULE_DESCRIPTION("Driver for wireless LAN cards using the Nortel PCI bridge");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static int __init orinoco_nortel_init(void)
 {
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index 6058c66..4a83776 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -240,7 +240,7 @@ static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org> &"
 	      " David Gibson <hermes@gibson.dropbear.id.au>");
 MODULE_DESCRIPTION("Driver for wireless LAN cards using direct PCI interface");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static int __init orinoco_pci_init(void)
 {
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index 2bac824..524184d 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -345,7 +345,7 @@ static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 	" Daniel Barlow <dan@telent.net>)";
 MODULE_AUTHOR("Daniel Barlow <dan@telent.net>");
 MODULE_DESCRIPTION("Driver for wireless LAN cards using the PLX9052 PCI bridge");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static int __init orinoco_plx_init(void)
 {
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index 93159d6..9a2272a 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -223,7 +223,7 @@ static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 	" (Joerg Dorchain <joerg@dorchain.net>)";
 MODULE_AUTHOR("Joerg Dorchain <joerg@dorchain.net>");
 MODULE_DESCRIPTION("Driver for wireless LAN cards using the TMD7160 PCI bridge");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 static int __init orinoco_tmd_init(void)
 {
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index f634d45..4844ff0 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1758,4 +1758,4 @@ module_usb_driver(orinoco_driver);
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Driver for Orinoco wireless LAN cards using EZUSB bridge");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 6e28ee4..68e8687 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -37,7 +37,7 @@
 
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>");
 MODULE_DESCRIPTION("Driver for Symbol Spectrum24 Trilogy cards with firmware downloader");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /* Module parameters */
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 2596401..776ffba 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1702,5 +1702,5 @@ failed_init:
 
 module_init(netback_init);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("xen-backend:vif");
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index 90cca5e..7a7a7b8 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -253,4 +253,4 @@ module_exit(power_exit);
 
 MODULE_AUTHOR("Helge Deller <deller@gmx.de>");
 MODULE_DESCRIPTION("Soft power switch driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 067ad51..94c4db5 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -59,7 +59,7 @@
 
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("PCMCIA parallel port card driver");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0)
 
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index e6f3d17..c09ed8f 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -1352,5 +1352,5 @@ static void __exit exit_i82365(void)
 
 module_init(init_i82365);
 module_exit(exit_i82365);
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 /*====================================================================*/
diff --git a/drivers/pcmcia/m32r_cfc.c b/drivers/pcmcia/m32r_cfc.c
index a26f38c..17f9d8a 100644
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -793,5 +793,5 @@ static void __exit exit_m32r_pcc(void)
 
 module_init(init_m32r_pcc);
 module_exit(exit_m32r_pcc);
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 /*====================================================================*/
diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index 2965141..9b5bfa7 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -755,5 +755,5 @@ static void __exit exit_m32r_pcc(void)
 
 module_init(init_m32r_pcc);
 module_exit(exit_m32r_pcc);
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 /*====================================================================*/
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index a3a851e..136673c 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -64,7 +64,7 @@
 #define pcmcia_error(args...) printk(KERN_ERR "m8xx_pcmcia: "args)
 
 static const char *version = "Version 0.06, Aug 2005";
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 #if !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B)
 
diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
index 2eea664..27084e0 100644
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -131,7 +131,7 @@ static void __exit sa11x0_pcmcia_exit(void)
 
 MODULE_AUTHOR("John Dorsey <john+@cs.cmu.edu>");
 MODULE_DESCRIPTION("Linux PCMCIA Card Services: SA-11x0 Socket Controller");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 fs_initcall(sa11x0_pcmcia_init);
 module_exit(sa11x0_pcmcia_exit);
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 6eecd7cd..582146e 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -266,4 +266,4 @@ module_exit(sa11xx_pcmcia_exit);
 
 MODULE_AUTHOR("John Dorsey <john+@cs.cmu.edu>");
 MODULE_DESCRIPTION("Linux PCMCIA Card Services: SA-11xx core socket driver");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index a2bc6ee..c34130b 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -814,4 +814,4 @@ EXPORT_SYMBOL(soc_pcmcia_add_one);
 
 MODULE_AUTHOR("John Dorsey <john+@cs.cmu.edu>");
 MODULE_DESCRIPTION("Linux PCMCIA Card Services: Common SoC support");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index cbe15fc..d592aeb 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -53,7 +53,7 @@
 
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("Databook TCIC-2 PCMCIA socket driver");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*====================================================================*/
 
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index a391090..4f94981 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1239,7 +1239,7 @@ static void __exit inia100_exit(void)
 
 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 module_init(inia100_init);
 module_exit(inia100_exit);
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 9328121..2f31af0 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -318,7 +318,7 @@ static char *aic79xx = NULL;
 
 MODULE_AUTHOR("Maintainer: Hannes Reinecke <hare@suse.de>");
 MODULE_DESCRIPTION("Adaptec AIC790X U320 SCSI Host Bus Adapter driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(AIC79XX_DRIVER_VERSION);
 module_param(aic79xx, charp, 0444);
 MODULE_PARM_DESC(aic79xx,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 5a477cd..11f88f8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -338,7 +338,7 @@ static char *aic7xxx = NULL;
 
 MODULE_AUTHOR("Maintainer: Hannes Reinecke <hare@suse.de>");
 MODULE_DESCRIPTION("Adaptec AIC77XX/78XX SCSI Host Bus Adapter driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
 module_param(aic7xxx, charp, 0444);
 MODULE_PARM_DESC(aic7xxx,
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 5b212f0..d216d1f 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -11103,7 +11103,7 @@ aic7xxx_print_scratch_ram(struct aic7xxx_host *p)
 
 #include "aic7xxx_old/aic7xxx_proc.c"
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(AIC7XXX_H_VERSION);
 
 
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index cbde1dc..6d2bf12 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -72,7 +72,7 @@
 #include "arcmsr.h"
 MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
 MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus Adapter");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
 #define	ARCMSR_SLEEPTIME	10
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index eb0f56c..7a8da32 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -809,7 +809,7 @@ static __exit void isci_exit(void)
 	sas_release_transport(isci_transport_template);
 }
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_FIRMWARE(ISCI_FW_NAME);
 module_init(isci_init);
 module_exit(isci_exit);
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 7d1609f..4cef811 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -72,7 +72,7 @@ module_param(synchronous, int, 0);
 module_param(reset_delay, int, 0);
 module_param(ext_trans, int, 0);
 
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*====================================================================*/
 
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 714b248..03af4bf 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -55,7 +55,7 @@
 
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("Future Domain PCMCIA SCSI driver");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*====================================================================*/
 
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 886f565..08ccb89 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -84,7 +84,7 @@
 
 MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");
 MODULE_AUTHOR("Mark Einon <mark.einon@gmail.com>");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 		   "for the ET1310 by Agere Systems");
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 84c38d5..7b8b7a7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -19,7 +19,7 @@
 #include <linux/kthread.h>
 
 MODULE_DESCRIPTION("FT1000 EXPRESS CARD DRIVER");
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_SUPPORTED_DEVICE("QFT FT1000 Express Cards");
 
 void *pFileStart;
diff --git a/drivers/staging/rtl8192u/ieee80211/aes.c b/drivers/staging/rtl8192u/ieee80211/aes.c
index a6bb6c9..cc1e08b 100644
--- a/drivers/staging/rtl8192u/ieee80211/aes.c
+++ b/drivers/staging/rtl8192u/ieee80211/aes.c
@@ -465,5 +465,5 @@ module_init(aes_init);
 module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 77a0751..33f7f69 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -127,7 +127,7 @@ static struct dentry *slic_debugfs;
 
 MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 module_param(dynamic_intagg, int, 0);
 MODULE_PARM_DESC(dynamic_intagg, "Dynamic Interrupt Aggregation Setting");
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index d5bf0a7..c53afee 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -3868,4 +3868,4 @@ void timer_oor( u_long arg )
 } // timer_oor
 #endif //DN554
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 417aea5..bf6a5f2 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -119,7 +119,7 @@ MODULE_PARM_DESC(prism2_reset_holdtime, "reset hold time in ms");
 module_param(prism2_reset_settletime, int, 0644);
 MODULE_PARM_DESC(prism2_reset_settletime, "reset settle time in ms");
 
-MODULE_LICENSE("Dual MPL/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
 void prism2_disconnected(wlandevice_t *wlandev);
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 685d612..582f431 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -858,6 +858,6 @@ MODULE_PARM_DESC(num_devices, "Number of zram devices");
 module_init(zram_init);
 module_exit(zram_exit);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
 MODULE_DESCRIPTION("Compressed RAM Block Device");
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index e7592f9..71de860 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1962,5 +1962,5 @@ module_exit(nozomi_exit);
 
 module_param(debug, int, S_IRUGO | S_IWUSR);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 777d5f9..977e1fe 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -290,7 +290,7 @@ module_init(rp_init);
 module_exit(rp_cleanup_module);
 
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*************************************************************************/
 /*                     Module code starts here                           */
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 01ea5d7..9c47869 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2757,4 +2757,4 @@ module_usb_driver(uea_driver);
 
 MODULE_AUTHOR("Damien Bergamini/Matthieu Castet/Stanislaw W. Gruszka");
 MODULE_DESCRIPTION("ADI 930/Eagle USB ADSL Modem driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 7bd815a..257383d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -601,5 +601,5 @@ module_platform_driver(dwc3_driver);
 
 MODULE_ALIAS("platform:dwc3");
 MODULE_AUTHOR("Felipe Balbi <balbi@ti.com>");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("DesignWare USB3 DRD Controller Driver");
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index d7d9c0e..001a918 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -388,5 +388,5 @@ module_platform_driver(dwc3_omap_driver);
 
 MODULE_ALIAS("platform:omap-dwc3");
 MODULE_AUTHOR("Felipe Balbi <balbi@ti.com>");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("DesignWare USB3 OMAP Glue Layer");
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index a9ca9ad..a57ad259 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -167,7 +167,7 @@ static struct pci_driver dwc3_pci_driver = {
 };
 
 MODULE_AUTHOR("Felipe Balbi <balbi@ti.com>");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DESCRIPTION("DesignWare USB3 PCI Glue Layer");
 
 module_pci_driver(dwc3_pci_driver);
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 4fac569..4716de5 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -286,7 +286,7 @@ static const char fsg_string_interface[] = "Mass Storage";
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Alan Stern");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 /*
  * This driver assumes self-powered hardware and has no way for users to
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index 02fd226..444a000 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -227,7 +227,7 @@ MODULE_AUTHOR("David Dawes <dawes@tungstengraphics.com>, "
 	      "Sylvain Meyer <sylvain.meyer@worldonline.fr>");
 MODULE_DESCRIPTION("Framebuffer driver for Intel(R) " SUPPORTED_CHIPSETS
 		   " chipsets");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_DEVICE_TABLE(pci, intelfb_pci_table);
 
 static bool accel       = 1;
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 097e536..7a31758 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -1406,5 +1406,5 @@ static void __exit xen_pcibk_cleanup(void)
 module_init(xen_pcibk_init);
 module_exit(xen_pcibk_cleanup);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS("xen-backend:pci");
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index d4fabd2..45cfc35 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -50,7 +50,7 @@
 
 MODULE_AUTHOR("Christoph Hellwig");
 MODULE_DESCRIPTION("Veritas Filesystem (VxFS) driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 MODULE_ALIAS("vxfs"); /* makes mount -t vxfs autoload the module */
 
diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 7020e94..b29ac34 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -164,4 +164,4 @@ static void __exit exit_nls_ascii(void)
 module_init(init_nls_ascii)
 module_exit(exit_nls_ascii)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index fea6bd5..eb9fb84 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -544,4 +544,4 @@ EXPORT_SYMBOL(unload_nls);
 EXPORT_SYMBOL(load_nls);
 EXPORT_SYMBOL(load_nls_default);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp1250.c b/fs/nls/nls_cp1250.c
index c8471fe..ee38849 100644
--- a/fs/nls/nls_cp1250.c
+++ b/fs/nls/nls_cp1250.c
@@ -344,4 +344,4 @@ static void __exit exit_nls_cp1250(void)
 module_init(init_nls_cp1250)
 module_exit(exit_nls_cp1250)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp1251.c b/fs/nls/nls_cp1251.c
index 1939b46..a536552 100644
--- a/fs/nls/nls_cp1251.c
+++ b/fs/nls/nls_cp1251.c
@@ -299,4 +299,4 @@ static void __exit exit_nls_cp1251(void)
 module_init(init_nls_cp1251)
 module_exit(exit_nls_cp1251)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp1255.c b/fs/nls/nls_cp1255.c
index 8120ae2..123e902 100644
--- a/fs/nls/nls_cp1255.c
+++ b/fs/nls/nls_cp1255.c
@@ -381,5 +381,5 @@ static void __exit exit_nls_cp1255(void)
 module_init(init_nls_cp1255)
 module_exit(exit_nls_cp1255)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NLS(iso8859-8);
diff --git a/fs/nls/nls_cp437.c b/fs/nls/nls_cp437.c
index ff37a46..0c73821 100644
--- a/fs/nls/nls_cp437.c
+++ b/fs/nls/nls_cp437.c
@@ -385,4 +385,4 @@ static void __exit exit_nls_cp437(void)
 module_init(init_nls_cp437)
 module_exit(exit_nls_cp437)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp737.c b/fs/nls/nls_cp737.c
index f5576b8..ef5cb11 100644
--- a/fs/nls/nls_cp737.c
+++ b/fs/nls/nls_cp737.c
@@ -348,4 +348,4 @@ static void __exit exit_nls_cp737(void)
 module_init(init_nls_cp737)
 module_exit(exit_nls_cp737)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp775.c b/fs/nls/nls_cp775.c
index 4905635..f417612 100644
--- a/fs/nls/nls_cp775.c
+++ b/fs/nls/nls_cp775.c
@@ -317,4 +317,4 @@ static void __exit exit_nls_cp775(void)
 module_init(init_nls_cp775)
 module_exit(exit_nls_cp775)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp850.c b/fs/nls/nls_cp850.c
index fe5bdad..43624ba 100644
--- a/fs/nls/nls_cp850.c
+++ b/fs/nls/nls_cp850.c
@@ -313,4 +313,4 @@ static void __exit exit_nls_cp850(void)
 module_init(init_nls_cp850)
 module_exit(exit_nls_cp850)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp852.c b/fs/nls/nls_cp852.c
index ceb1c01..f19cc4b 100644
--- a/fs/nls/nls_cp852.c
+++ b/fs/nls/nls_cp852.c
@@ -335,4 +335,4 @@ static void __exit exit_nls_cp852(void)
 module_init(init_nls_cp852)
 module_exit(exit_nls_cp852)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp855.c b/fs/nls/nls_cp855.c
index cc7f5fb2..336ba08 100644
--- a/fs/nls/nls_cp855.c
+++ b/fs/nls/nls_cp855.c
@@ -297,4 +297,4 @@ static void __exit exit_nls_cp855(void)
 module_init(init_nls_cp855)
 module_exit(exit_nls_cp855)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp857.c b/fs/nls/nls_cp857.c
index e418e19..91e53e8 100644
--- a/fs/nls/nls_cp857.c
+++ b/fs/nls/nls_cp857.c
@@ -299,4 +299,4 @@ static void __exit exit_nls_cp857(void)
 module_init(init_nls_cp857)
 module_exit(exit_nls_cp857)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp860.c b/fs/nls/nls_cp860.c
index a86c97d..bd14953 100644
--- a/fs/nls/nls_cp860.c
+++ b/fs/nls/nls_cp860.c
@@ -362,4 +362,4 @@ static void __exit exit_nls_cp860(void)
 module_init(init_nls_cp860)
 module_exit(exit_nls_cp860)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp861.c b/fs/nls/nls_cp861.c
index bd92022..bcd3ce9 100644
--- a/fs/nls/nls_cp861.c
+++ b/fs/nls/nls_cp861.c
@@ -385,4 +385,4 @@ static void __exit exit_nls_cp861(void)
 module_init(init_nls_cp861)
 module_exit(exit_nls_cp861)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp862.c b/fs/nls/nls_cp862.c
index e9b68eb..1f9f32d 100644
--- a/fs/nls/nls_cp862.c
+++ b/fs/nls/nls_cp862.c
@@ -419,4 +419,4 @@ static void __exit exit_nls_cp862(void)
 module_init(init_nls_cp862)
 module_exit(exit_nls_cp862)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp863.c b/fs/nls/nls_cp863.c
index f8a9b07..6af186a 100644
--- a/fs/nls/nls_cp863.c
+++ b/fs/nls/nls_cp863.c
@@ -379,4 +379,4 @@ static void __exit exit_nls_cp863(void)
 module_init(init_nls_cp863)
 module_exit(exit_nls_cp863)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp864.c b/fs/nls/nls_cp864.c
index 8d31f43..5d1a6a7 100644
--- a/fs/nls/nls_cp864.c
+++ b/fs/nls/nls_cp864.c
@@ -405,4 +405,4 @@ static void __exit exit_nls_cp864(void)
 module_init(init_nls_cp864)
 module_exit(exit_nls_cp864)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp865.c b/fs/nls/nls_cp865.c
index 4bd902f..5b65535 100644
--- a/fs/nls/nls_cp865.c
+++ b/fs/nls/nls_cp865.c
@@ -385,4 +385,4 @@ static void __exit exit_nls_cp865(void)
 module_init(init_nls_cp865)
 module_exit(exit_nls_cp865)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp866.c b/fs/nls/nls_cp866.c
index bdc7cb3..d3f7eda 100644
--- a/fs/nls/nls_cp866.c
+++ b/fs/nls/nls_cp866.c
@@ -303,4 +303,4 @@ static void __exit exit_nls_cp866(void)
 module_init(init_nls_cp866)
 module_exit(exit_nls_cp866)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp869.c b/fs/nls/nls_cp869.c
index 9f283a2..fd72862 100644
--- a/fs/nls/nls_cp869.c
+++ b/fs/nls/nls_cp869.c
@@ -313,4 +313,4 @@ static void __exit exit_nls_cp869(void)
 module_init(init_nls_cp869)
 module_exit(exit_nls_cp869)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_cp874.c b/fs/nls/nls_cp874.c
index 0b3c488..fe1c14f 100644
--- a/fs/nls/nls_cp874.c
+++ b/fs/nls/nls_cp874.c
@@ -272,5 +272,5 @@ static void __exit exit_nls_cp874(void)
 module_init(init_nls_cp874)
 module_exit(exit_nls_cp874)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NLS(tis-620);
diff --git a/fs/nls/nls_cp932.c b/fs/nls/nls_cp932.c
index 0ffed6f..de9fb45 100644
--- a/fs/nls/nls_cp932.c
+++ b/fs/nls/nls_cp932.c
@@ -7930,5 +7930,5 @@ static void __exit exit_nls_cp932(void)
 module_init(init_nls_cp932)
 module_exit(exit_nls_cp932)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NLS(sjis);
diff --git a/fs/nls/nls_cp936.c b/fs/nls/nls_cp936.c
index 8277030..f4669a0 100644
--- a/fs/nls/nls_cp936.c
+++ b/fs/nls/nls_cp936.c
@@ -11108,5 +11108,5 @@ static void __exit exit_nls_cp936(void)
 module_init(init_nls_cp936)
 module_exit(exit_nls_cp936)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NLS(gb2312);
diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 8a7a2fe..bceeb55 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -13943,5 +13943,5 @@ static void __exit exit_nls_cp949(void)
 module_init(init_nls_cp949)
 module_exit(exit_nls_cp949)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NLS(euc-kr);
diff --git a/fs/nls/nls_cp950.c b/fs/nls/nls_cp950.c
index ef25368..f45b84e 100644
--- a/fs/nls/nls_cp950.c
+++ b/fs/nls/nls_cp950.c
@@ -9479,5 +9479,5 @@ static void __exit exit_nls_cp950(void)
 module_init(init_nls_cp950)
 module_exit(exit_nls_cp950)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NLS(big5);
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 7424929..452a746 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -578,4 +578,4 @@ static void __exit exit_nls_euc_jp(void)
 module_init(init_nls_euc_jp)
 module_exit(exit_nls_euc_jp)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-1.c b/fs/nls/nls_iso8859-1.c
index 7b951bb..98bb8b0 100644
--- a/fs/nls/nls_iso8859-1.c
+++ b/fs/nls/nls_iso8859-1.c
@@ -255,4 +255,4 @@ static void __exit exit_nls_iso8859_1(void)
 module_init(init_nls_iso8859_1)
 module_exit(exit_nls_iso8859_1)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-13.c b/fs/nls/nls_iso8859-13.c
index c4d52ea..ca58d12 100644
--- a/fs/nls/nls_iso8859-13.c
+++ b/fs/nls/nls_iso8859-13.c
@@ -283,4 +283,4 @@ static void __exit exit_nls_iso8859_13(void)
 module_init(init_nls_iso8859_13)
 module_exit(exit_nls_iso8859_13)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-14.c b/fs/nls/nls_iso8859-14.c
index dc02600..50bce2b 100644
--- a/fs/nls/nls_iso8859-14.c
+++ b/fs/nls/nls_iso8859-14.c
@@ -339,4 +339,4 @@ static void __exit exit_nls_iso8859_14(void)
 module_init(init_nls_iso8859_14)
 module_exit(exit_nls_iso8859_14)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-15.c b/fs/nls/nls_iso8859-15.c
index 3c7dfc8..83dfa59 100644
--- a/fs/nls/nls_iso8859-15.c
+++ b/fs/nls/nls_iso8859-15.c
@@ -305,4 +305,4 @@ static void __exit exit_nls_iso8859_15(void)
 module_init(init_nls_iso8859_15)
 module_exit(exit_nls_iso8859_15)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-2.c b/fs/nls/nls_iso8859-2.c
index a2d2197..f909943 100644
--- a/fs/nls/nls_iso8859-2.c
+++ b/fs/nls/nls_iso8859-2.c
@@ -306,4 +306,4 @@ static void __exit exit_nls_iso8859_2(void)
 module_init(init_nls_iso8859_2)
 module_exit(exit_nls_iso8859_2)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-3.c b/fs/nls/nls_iso8859-3.c
index a61e0da..6d6e2c0 100644
--- a/fs/nls/nls_iso8859-3.c
+++ b/fs/nls/nls_iso8859-3.c
@@ -306,4 +306,4 @@ static void __exit exit_nls_iso8859_3(void)
 module_init(init_nls_iso8859_3)
 module_exit(exit_nls_iso8859_3)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-4.c b/fs/nls/nls_iso8859-4.c
index e8ff555..53b0462 100644
--- a/fs/nls/nls_iso8859-4.c
+++ b/fs/nls/nls_iso8859-4.c
@@ -306,4 +306,4 @@ static void __exit exit_nls_iso8859_4(void)
 module_init(init_nls_iso8859_4)
 module_exit(exit_nls_iso8859_4)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-5.c b/fs/nls/nls_iso8859-5.c
index 4721e89..8b923b2 100644
--- a/fs/nls/nls_iso8859-5.c
+++ b/fs/nls/nls_iso8859-5.c
@@ -270,4 +270,4 @@ static void __exit exit_nls_iso8859_5(void)
 module_init(init_nls_iso8859_5)
 module_exit(exit_nls_iso8859_5)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-6.c b/fs/nls/nls_iso8859-6.c
index 01a517d..4e2b55e 100644
--- a/fs/nls/nls_iso8859-6.c
+++ b/fs/nls/nls_iso8859-6.c
@@ -261,4 +261,4 @@ static void __exit exit_nls_iso8859_6(void)
 module_init(init_nls_iso8859_6)
 module_exit(exit_nls_iso8859_6)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-7.c b/fs/nls/nls_iso8859-7.c
index 2d27b93..55ce958 100644
--- a/fs/nls/nls_iso8859-7.c
+++ b/fs/nls/nls_iso8859-7.c
@@ -315,4 +315,4 @@ static void __exit exit_nls_iso8859_7(void)
 module_init(init_nls_iso8859_7)
 module_exit(exit_nls_iso8859_7)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_iso8859-9.c b/fs/nls/nls_iso8859-9.c
index 694bf07..26095da 100644
--- a/fs/nls/nls_iso8859-9.c
+++ b/fs/nls/nls_iso8859-9.c
@@ -270,4 +270,4 @@ static void __exit exit_nls_iso8859_9(void)
 module_init(init_nls_iso8859_9)
 module_exit(exit_nls_iso8859_9)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_koi8-r.c b/fs/nls/nls_koi8-r.c
index 4387531..e9c351c 100644
--- a/fs/nls/nls_koi8-r.c
+++ b/fs/nls/nls_koi8-r.c
@@ -321,4 +321,4 @@ static void __exit exit_nls_koi8_r(void)
 module_init(init_nls_koi8_r)
 module_exit(exit_nls_koi8_r)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index e7bc1d7..205fb5d 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -80,4 +80,4 @@ static void __exit exit_nls_koi8_ru(void)
 module_init(init_nls_koi8_ru)
 module_exit(exit_nls_koi8_ru)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_koi8-u.c b/fs/nls/nls_koi8-u.c
index 8c9f029..1e2e119 100644
--- a/fs/nls/nls_koi8-u.c
+++ b/fs/nls/nls_koi8-u.c
@@ -328,4 +328,4 @@ static void __exit exit_nls_koi8_u(void)
 module_init(init_nls_koi8_u)
 module_exit(exit_nls_koi8_u)
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index 0d60a44..1dd6921 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -65,4 +65,4 @@ static void __exit exit_nls_utf8(void)
 
 module_init(init_nls_utf8)
 module_exit(exit_nls_utf8)
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/include/linux/license.h b/include/linux/license.h
index decdbf4..c4ae101 100644
--- a/include/linux/license.h
+++ b/include/linux/license.h
@@ -6,6 +6,7 @@ static inline int license_is_gpl_compatible(const char *license)
 	return (strcmp(license, "GPL") == 0
 		|| strcmp(license, "GPL v2") == 0
 		|| strcmp(license, "GPL and additional rights") == 0
+		|| strcmp(license, "GPL-Compatible") == 0
 		|| strcmp(license, "Dual BSD/GPL") == 0
 		|| strcmp(license, "Dual MIT/GPL") == 0
 		|| strcmp(license, "Dual MPL/GPL") == 0);
diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..192cec2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -101,20 +101,28 @@ extern const struct gtype##_id __mod_##gtype##_table		\
  *	"GPL"				[GNU Public License v2 or later]
  *	"GPL v2"			[GNU Public License v2]
  *	"GPL and additional rights"	[GNU Public License v2 rights and more]
- *	"Dual BSD/GPL"			[GNU Public License v2
- *					 or BSD license choice]
- *	"Dual MIT/GPL"			[GNU Public License v2
- *					 or MIT license choice]
- *	"Dual MPL/GPL"			[GNU Public License v2
- *					 or Mozilla license choice]
+ *	"GPL-Compatible"		[Any GPL-Compatible license]
  *
  * The following other idents are available
  *
  *	"Proprietary"			[Non free products]
  *
- * There are dual licensed components, but when running with Linux it is the
- * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
- * is a GPL combined work.
+ * The Linux kernel is GPLv2 but individual modules / files
+ * can be GPL-Compatible. For details refer to:
+ *
+ * http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
+ *
+ * We use the Signed-off-by tag from contributors to keep contributions under
+ * the same license of the file. The Signed-off-by tag is documented under the
+ * Developer's Certificate of Origin found under Documentation/SubmittingPatches
+ *
+ * GPL-Compatible licenses are those listed by the FSF:
+ *
+ * http://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
+ *
+ * Although all listed licenses are GPL-Compatible a maintainer may
+ * decide which GPL-Compatible license to accept or reject. A good
+ * example of a license to avoid is the The Clear BSD License.
  *
  * This exists for several reasons
  * 1.	So modinfo can show license info for users wanting to vet their setup 
diff --git a/lib/cordic.c b/lib/cordic.c
index 6cf4778..9fed976 100644
--- a/lib/cordic.c
+++ b/lib/cordic.c
@@ -98,4 +98,4 @@ EXPORT_SYMBOL(cordic_calc_iq);
 
 MODULE_DESCRIPTION("CORDIC algorithm");
 MODULE_AUTHOR("Broadcom Corporation");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/lib/crc8.c b/lib/crc8.c
index 87b59ca..d02566a 100644
--- a/lib/crc8.c
+++ b/lib/crc8.c
@@ -83,4 +83,4 @@ EXPORT_SYMBOL(crc8);
 
 MODULE_DESCRIPTION("CRC8 (by Williams, Ross N.) function");
 MODULE_AUTHOR("Broadcom Corporation");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
index d55769d..2afc874 100644
--- a/lib/test-kstrtox.c
+++ b/lib/test-kstrtox.c
@@ -736,4 +736,4 @@ static int __init test_kstrtox_init(void)
 	return -EINVAL;
 }
 module_init(test_kstrtox_init);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 2c69ddd..cd1080b 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -716,4 +716,4 @@ module_exit(p9_trans_rdma_exit);
 
 MODULE_AUTHOR("Tom Tucker <tom@opengridcomputing.com>");
 MODULE_DESCRIPTION("RDMA Transport for 9P");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 0ce2ad0..35cffa5 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -66,7 +66,7 @@ static __initdata const char banner[] = KERN_INFO
 	"can: controller area network core (" CAN_VERSION_STRING ")\n";
 
 MODULE_DESCRIPTION("Controller Area Network PF_CAN core");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>, "
 	      "Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
 
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 151b773..ced6ff0 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -81,7 +81,7 @@ static __initdata const char banner[] = KERN_INFO
 	"can: broadcast manager protocol (rev " CAN_BCM_VERSION " t)\n";
 
 MODULE_DESCRIPTION("PF_CAN broadcast manager protocol");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
 MODULE_ALIAS("can-proto-2");
 
diff --git a/net/can/gw.c b/net/can/gw.c
index 3d79b12..31745fc 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -62,7 +62,7 @@ static __initdata const char banner[] =
 	KERN_INFO "can: netlink gateway (rev " CAN_GW_VERSION ")\n";
 
 MODULE_DESCRIPTION("PF_CAN netlink gateway");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
 MODULE_ALIAS("can-gw");
 
diff --git a/net/can/raw.c b/net/can/raw.c
index cde1b4a..9594cdc 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -59,7 +59,7 @@ static __initdata const char banner[] =
 	KERN_INFO "can: raw protocol (rev " CAN_RAW_VERSION ")\n";
 
 MODULE_DESCRIPTION("PF_CAN raw protocol");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>");
 MODULE_ALIAS("can-proto-1");
 
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 424ff62..6fd0877 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -595,5 +595,5 @@ MODULE_AUTHOR("Oracle Corporation <rds-devel@oss.oracle.com>");
 MODULE_DESCRIPTION("RDS: Reliable Datagram Sockets"
 		   " v" DRV_VERSION " (" DRV_RELDATE ")");
 MODULE_VERSION(DRV_VERSION);
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_ALIAS_NETPROTO(PF_RDS);
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index c2be901..37ecb07 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -247,5 +247,5 @@ module_exit(rds_rdma_exit);
 
 MODULE_AUTHOR("Oracle Corporation <rds-devel@oss.oracle.com>");
 MODULE_DESCRIPTION("RDS: IB/iWARP transport");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index edac9ef..7b24307 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -322,5 +322,5 @@ module_init(rds_tcp_init);
 
 MODULE_AUTHOR("Oracle Corporation <rds-devel@oss.oracle.com>");
 MODULE_DESCRIPTION("RDS: TCP transport");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 8343737..93c1937 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -297,6 +297,6 @@ int svc_rdma_init(void)
 }
 MODULE_AUTHOR("Tom Tucker <tom@opengridcomputing.com>");
 MODULE_DESCRIPTION("SVC RDMA Transport");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 module_init(svc_rdma_init);
 module_exit(svc_rdma_cleanup);
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index b446e10..ca00bc4 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -58,7 +58,7 @@
 # define RPCDBG_FACILITY	RPCDBG_TRANS
 #endif
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 MODULE_DESCRIPTION("RPC/RDMA Transport for Linux kernel NFS");
 MODULE_AUTHOR("Network Appliance, Inc.");
diff --git a/net/tipc/core.c b/net/tipc/core.c
index 68eba03..6c89492 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -199,5 +199,5 @@ module_init(tipc_init);
 module_exit(tipc_exit);
 
 MODULE_DESCRIPTION("TIPC: Transparent Inter Process Communication");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 MODULE_VERSION(TIPC_MOD_VER);
diff --git a/sound/drivers/opl4/opl4_seq.c b/sound/drivers/opl4/opl4_seq.c
index 9919769..4479742 100644
--- a/sound/drivers/opl4/opl4_seq.c
+++ b/sound/drivers/opl4/opl4_seq.c
@@ -39,7 +39,7 @@
 
 MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
 MODULE_DESCRIPTION("OPL4 wavetable synth driver");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 int volume_boost = 8;
 
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index c83f614..e99f309 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -75,7 +75,7 @@
 
 MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
 MODULE_DESCRIPTION("USB Audio/MIDI helper module");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL-Compatible");
 
 
 struct usb_ms_header_descriptor {
-- 
1.7.10.rc1.22.gf5241

