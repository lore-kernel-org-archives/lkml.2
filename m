Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1GNMIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:08:14 -0400
Received: from smtp.nokia.com ([147.243.1.47]:53830 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab1GNMIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:08:12 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] trivial: Fix potentially dangerous trailing ';' in #defined values/expressions
Date: Thu, 14 Jul 2011 15:07:13 +0300
Message-Id: <1310645233-31889-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these are instances of
  #define NAME value;
or
  #define NAME(params_opt) value;

These of course fail to build when used in contexts like
  if(foo $OP NAME)
  while(bar $OP NAME)
and may silently generate the wrong code in contexts such as
  foo = NAME + 1;    /* foo = value; + 1; */
  bar = NAME - 1;    /* bar = value; - 1; */
  baz = NAME & quux; /* baz = value; & quux; */

Reported on comp.lang.c,
Message-ID: <ab0d55fe-25e5-482b-811e-c475aa6065c3@c29g2000yqd.googlegroups.com>
Initial analysis of the dangers provided by Keith Thompson in that thread.

There are many more instances of more complicated macros having unnecessary
trailing semicolons, but this pile seems to be all of the cases of simple
values suffering from the problem. (Thus things that are likely to be found
in one of the contexts above, more complicated ones aren't.)

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 Documentation/DocBook/v4l/io.xml             |    2 +-
 arch/alpha/include/asm/floppy.h              |    2 +-
 arch/h8300/kernel/setup.c                    |    2 +-
 arch/ia64/include/asm/sn/tioce.h             |    2 +-
 arch/mips/include/asm/floppy.h               |    2 +-
 arch/parisc/include/asm/dma-mapping.h        |    2 +-
 arch/parisc/math-emu/decode_exc.c            |    2 +-
 arch/powerpc/include/asm/elf.h               |    4 ++--
 arch/powerpc/include/asm/smu.h               |    2 +-
 arch/sparc/include/asm/elf_64.h              |    2 +-
 arch/um/sys-i386/signal.c                    |    2 +-
 arch/x86/kernel/i387.c                       |    2 +-
 drivers/acpi/ac.c                            |    2 +-
 drivers/acpi/battery.c                       |    2 +-
 drivers/acpi/sbs.c                           |    2 +-
 drivers/gpu/drm/sis/sis_drv.h                |    4 ++--
 drivers/hwmon/gl520sm.c                      |    2 +-
 drivers/isdn/i4l/isdn_bsdcomp.c              |    2 +-
 drivers/net/bsd_comp.c                       |    2 +-
 drivers/net/natsemi.c                        |    2 +-
 drivers/net/r8169.c                          |    2 +-
 drivers/net/s2io.h                           |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-commands.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    4 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c   |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h                  |    8 ++++----
 drivers/usb/otg/twl4030-usb.c                |    2 +-
 drivers/video/i810/i810.h                    |    2 +-
 include/linux/ceph/libceph.h                 |    2 +-
 include/linux/mfd/tps65910.h                 |    2 +-
 include/scsi/scsi.h                          |    2 +-
 include/sound/soundfont.h                    |    2 +-
 mm/slub.c                                    |    2 +-
 net/mac80211/mesh_hwmp.c                     |   20 ++++++++++----------
 35 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/Documentation/DocBook/v4l/io.xml b/Documentation/DocBook/v4l/io.xml
index 227e7ac..c57d1ec 100644
--- a/Documentation/DocBook/v4l/io.xml
+++ b/Documentation/DocBook/v4l/io.xml
@@ -210,7 +210,7 @@ for (i = 0; i &lt; reqbuf.count; i++)
       <programlisting>
 &v4l2-requestbuffers; reqbuf;
 /* Our current format uses 3 planes per buffer */
-#define FMT_NUM_PLANES = 3;
+#define FMT_NUM_PLANES = 3
 
 struct {
 	void *start[FMT_NUM_PLANES];
diff --git a/arch/alpha/include/asm/floppy.h b/arch/alpha/include/asm/floppy.h
index 0be5041..46cefbd 100644
--- a/arch/alpha/include/asm/floppy.h
+++ b/arch/alpha/include/asm/floppy.h
@@ -27,7 +27,7 @@
 #define fd_cacheflush(addr,size) /* nothing */
 #define fd_request_irq()        request_irq(FLOPPY_IRQ, floppy_interrupt,\
 					    IRQF_DISABLED, "floppy", NULL)
-#define fd_free_irq()           free_irq(FLOPPY_IRQ, NULL);
+#define fd_free_irq()           free_irq(FLOPPY_IRQ, NULL)
 
 #ifdef CONFIG_PCI
 
diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index 7fda657..68d6510 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -46,7 +46,7 @@
 #include <asm/regs267x.h>
 #endif
 
-#define STUBSIZE 0xc000;
+#define STUBSIZE 0xc000
 
 unsigned long rom_length;
 unsigned long memory_start;
diff --git a/arch/ia64/include/asm/sn/tioce.h b/arch/ia64/include/asm/sn/tioce.h
index 893468e..6eae8ad 100644
--- a/arch/ia64/include/asm/sn/tioce.h
+++ b/arch/ia64/include/asm/sn/tioce.h
@@ -467,7 +467,7 @@ typedef volatile struct tioce {
 #define CE_LSI_GB_CFG1_RXL0S_THS_SHFT	0
 #define CE_LSI_GB_CFG1_RXL0S_THS_MASK	(0xffULL << 0)
 #define CE_LSI_GB_CFG1_RXL0S_SMP_SHFT	8
-#define CE_LSI_GB_CFG1_RXL0S_SMP_MASK	(0xfULL << 8);
+#define CE_LSI_GB_CFG1_RXL0S_SMP_MASK	(0xfULL << 8)
 #define CE_LSI_GB_CFG1_RXL0S_ADJ_SHFT	12
 #define CE_LSI_GB_CFG1_RXL0S_ADJ_MASK	(0x7ULL << 12)
 #define CE_LSI_GB_CFG1_RXL0S_FLT_SHFT	15
diff --git a/arch/mips/include/asm/floppy.h b/arch/mips/include/asm/floppy.h
index c5c7c0e..4456c9c 100644
--- a/arch/mips/include/asm/floppy.h
+++ b/arch/mips/include/asm/floppy.h
@@ -29,7 +29,7 @@ static inline void fd_cacheflush(char * addr, long size)
 #define FLOPPY0_TYPE 		fd_drive_type(0)
 #define FLOPPY1_TYPE		fd_drive_type(1)
 
-#define FDC1			fd_getfdaddr1();
+#define FDC1			fd_getfdaddr1()
 
 #define N_FDC 1			/* do you *really* want a second controller? */
 #define N_DRIVE 8
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 4ef73b0..890531e 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -210,7 +210,7 @@ parisc_walk_tree(struct device *dev)
 	return dev->platform_data;
 }
 		
-#define GET_IOC(dev) (HBA_DATA(parisc_walk_tree(dev))->iommu);	
+#define GET_IOC(dev) (HBA_DATA(parisc_walk_tree(dev))->iommu)
 	
 
 #ifdef CONFIG_IOMMU_CCIO
diff --git a/arch/parisc/math-emu/decode_exc.c b/arch/parisc/math-emu/decode_exc.c
index 27a7492..04e550e 100644
--- a/arch/parisc/math-emu/decode_exc.c
+++ b/arch/parisc/math-emu/decode_exc.c
@@ -56,7 +56,7 @@
 /* General definitions */
 #define DOESTRAP 1
 #define NOTRAP 0
-#define SIGNALCODE(signal, code) ((signal) << 24 | (code));
+#define SIGNALCODE(signal, code) ((signal) << 24 | (code))
 #define copropbit	1<<31-2	/* bit position 2 */
 #define opclass		9	/* bits 21 & 22 */
 #define fmt		11	/* bits 19 & 20 */
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 2b917c6..3bf9cca 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -267,7 +267,7 @@ extern int ucache_bsize;
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
-#define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b);
+#define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b)
 
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (is_32bit_task() ? \
@@ -298,7 +298,7 @@ do {									\
 	NEW_AUX_ENT(AT_DCACHEBSIZE, dcache_bsize);			\
 	NEW_AUX_ENT(AT_ICACHEBSIZE, icache_bsize);			\
 	NEW_AUX_ENT(AT_UCACHEBSIZE, ucache_bsize);			\
-	VDSO_AUX_ENT(AT_SYSINFO_EHDR, current->mm->context.vdso_base)	\
+	VDSO_AUX_ENT(AT_SYSINFO_EHDR, current->mm->context.vdso_base);	\
 } while (0)
 
 /* PowerPC64 relocations defined by the ABIs */
diff --git a/arch/powerpc/include/asm/smu.h b/arch/powerpc/include/asm/smu.h
index e3bdada..ae20ce1 100644
--- a/arch/powerpc/include/asm/smu.h
+++ b/arch/powerpc/include/asm/smu.h
@@ -547,7 +547,7 @@ struct smu_sdbp_header {
  * (currently, afaik, this concerns only the FVT partition
  * (0x12)
  */
-#define SMU_U16_MIX(x)	le16_to_cpu(x);
+#define SMU_U16_MIX(x)	le16_to_cpu(x)
 #define SMU_U32_MIX(x)  ((((x) & 0xff00ff00u) >> 8)|(((x) & 0x00ff00ffu) << 8))
 
 
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index e678803..cfa9cd2 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -186,7 +186,7 @@ static inline unsigned int sparc64_elf_hwcap(void)
 	return cap;
 }
 
-#define ELF_HWCAP	sparc64_elf_hwcap();
+#define ELF_HWCAP	sparc64_elf_hwcap()
 
 /* This yields a string that ld.so will use to load implementation
    specific libraries for optimization.  This is more specific in
diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
index 1296473..89a4662 100644
--- a/arch/um/sys-i386/signal.c
+++ b/arch/um/sys-i386/signal.c
@@ -58,7 +58,7 @@ static inline unsigned long twd_fxsr_to_i387(struct user_fxsr_struct *fxsave)
 	unsigned long ret = 0xffff0000;
 	int i;
 
-#define FPREG_ADDR(f, n)	((char *)&(f)->st_space + (n) * 16);
+#define FPREG_ADDR(f, n)	((char *)&(f)->st_space + (n) * 16)
 
 	for (i = 0; i < 8; i++) {
 		if (twd & 0x1) {
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 12aff25..739d859 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -321,7 +321,7 @@ static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
 	return tmp;
 }
 
-#define FPREG_ADDR(f, n)	((void *)&(f)->st_space + (n) * 16);
+#define FPREG_ADDR(f, n)	((void *)&(f)->st_space + (n) * 16)
 #define FP_EXP_TAG_VALID	0
 #define FP_EXP_TAG_ZERO		1
 #define FP_EXP_TAG_SPECIAL	2
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 58c3f74..6512b20 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -89,7 +89,7 @@ struct acpi_ac {
 	unsigned long long state;
 };
 
-#define to_acpi_ac(x) container_of(x, struct acpi_ac, charger);
+#define to_acpi_ac(x) container_of(x, struct acpi_ac, charger)
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
 static const struct file_operations acpi_ac_fops = {
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fcc13ac..2c66135 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -132,7 +132,7 @@ struct acpi_battery {
 	unsigned long flags;
 };
 
-#define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
+#define to_acpi_battery(x) container_of(x, struct acpi_battery, bat)
 
 inline int acpi_battery_present(struct acpi_battery *battery)
 {
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 51ae379..50658ff 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -112,7 +112,7 @@ struct acpi_battery {
 	u8 have_sysfs_alarm:1;
 };
 
-#define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
+#define to_acpi_battery(x) container_of(x, struct acpi_battery, bat)
 
 struct acpi_sbs {
 	struct power_supply charger;
diff --git a/drivers/gpu/drm/sis/sis_drv.h b/drivers/gpu/drm/sis/sis_drv.h
index ef940ba..194303c 100644
--- a/drivers/gpu/drm/sis/sis_drv.h
+++ b/drivers/gpu/drm/sis/sis_drv.h
@@ -48,8 +48,8 @@ enum sis_family {
 
 
 #define SIS_BASE (dev_priv->mmio)
-#define SIS_READ(reg)         DRM_READ32(SIS_BASE, reg);
-#define SIS_WRITE(reg, val)   DRM_WRITE32(SIS_BASE, reg, val);
+#define SIS_READ(reg)         DRM_READ32(SIS_BASE, reg)
+#define SIS_WRITE(reg, val)   DRM_WRITE32(SIS_BASE, reg, val)
 
 typedef struct drm_sis_private {
 	drm_local_map_t *mmio;
diff --git a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
index ec58802..131ea86 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -273,7 +273,7 @@ static SENSOR_DEVICE_ATTR(in4_max, S_IRUGO | S_IWUSR,
 
 #define DIV_FROM_REG(val) (1 << (val))
 #define FAN_FROM_REG(val,div) ((val)==0 ? 0 : (480000/((val) << (div))))
-#define FAN_TO_REG(val,div) ((val)<=0?0:SENSORS_LIMIT((480000 + ((val) << ((div)-1))) / ((val) << (div)), 1, 255));
+#define FAN_TO_REG(val,div) ((val)<=0?0:SENSORS_LIMIT((480000 + ((val) << ((div)-1))) / ((val) << (div)), 1, 255))
 
 static ssize_t get_fan_input(struct device *dev, struct device_attribute *attr,
 			     char *buf)
diff --git a/drivers/isdn/i4l/isdn_bsdcomp.c b/drivers/isdn/i4l/isdn_bsdcomp.c
index 02d9918..aa0b6a6 100644
--- a/drivers/isdn/i4l/isdn_bsdcomp.c
+++ b/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -155,7 +155,7 @@ struct bsd_db {
 #define LAST	255
 
 #define MAXCODE(b)	((1 << (b)) - 1)
-#define BADCODEM1	MAXCODE(MAX_BSD_BITS);
+#define BADCODEM1	MAXCODE(MAX_BSD_BITS)
 
 #define BSD_HASH(prefix,suffix,hshift) ((((unsigned long)(suffix))<<(hshift)) \
 					 ^ (unsigned long)(prefix))
diff --git a/drivers/net/bsd_comp.c b/drivers/net/bsd_comp.c
index 6e99d80..a9b759a 100644
--- a/drivers/net/bsd_comp.c
+++ b/drivers/net/bsd_comp.c
@@ -201,7 +201,7 @@ extern void ppp_unregister_compressor (struct compressor *cp);
 #define LAST	255
 
 #define MAXCODE(b)	((1 << (b)) - 1)
-#define BADCODEM1	MAXCODE(MAX_BSD_BITS);
+#define BADCODEM1	MAXCODE(MAX_BSD_BITS)
 
 #define BSD_HASH(prefix,suffix,hshift) ((((unsigned long)(suffix))<<(hshift)) \
 					 ^ (unsigned long)(prefix))
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 8f8b65a..cf3fb1a 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -1382,7 +1382,7 @@ static int find_mii(struct net_device *dev)
 /* WCSR bits [0:4] [9:10] */
 #define WCSR_RESET_SAVE 0x61f
 /* RFCR bits [20] [22] [27:31] */
-#define RFCR_RESET_SAVE 0xf8500000;
+#define RFCR_RESET_SAVE 0xf8500000
 
 static void natsemi_reset(struct net_device *dev)
 {
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 5990621..6f36306 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -667,7 +667,7 @@ struct rtl8169_private {
 	u32 saved_wolopts;
 
 	const struct firmware *fw;
-#define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN);
+#define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN)
 };
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
index 800b3a4..57a4dc7 100644
--- a/drivers/net/s2io.h
+++ b/drivers/net/s2io.h
@@ -968,8 +968,8 @@ struct s2io_nic {
 	u8  serial_num[VPD_STRING_LEN];
 };
 
-#define RESET_ERROR 1;
-#define CMD_ERROR   2;
+#define RESET_ERROR 1
+#define CMD_ERROR   2
 
 /*  OS related system calls */
 #ifndef readq
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 17a1d50..6a5c76e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -2624,8 +2624,8 @@ struct iwl_scanstart_notification {
 	__le32 status;
 } __packed;
 
-#define  SCAN_OWNER_STATUS 0x1;
-#define  MEASURE_OWNER_STATUS 0x2;
+#define  SCAN_OWNER_STATUS 0x1
+#define  MEASURE_OWNER_STATUS 0x2
 
 #define IWL_PROBE_STATUS_OK		0
 #define IWL_PROBE_STATUS_TX_FAILED	BIT(0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6ee5f1a..6288d1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2457,8 +2457,8 @@ struct iwl_scanstart_notification {
 	__le32 status;
 } __packed;
 
-#define  SCAN_OWNER_STATUS 0x1;
-#define  MEASURE_OWNER_STATUS 0x2;
+#define  SCAN_OWNER_STATUS 0x1
+#define  MEASURE_OWNER_STATUS 0x2
 
 #define IWL_PROBE_STATUS_OK		0
 #define IWL_PROBE_STATUS_TX_FAILED	BIT(0)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
index 598cecc..5b43749 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -1074,10 +1074,10 @@
 #define _SRL(x)					(((x) & 0x3F) << 8)
 
 #define _SIFS_CCK_CTX(x)			((x) & 0xFF)
-#define _SIFS_CCK_TRX(x)			(((x) & 0xFF) << 8);
+#define _SIFS_CCK_TRX(x)			(((x) & 0xFF) << 8)
 
 #define _SIFS_OFDM_CTX(x)			((x) & 0xFF)
-#define _SIFS_OFDM_TRX(x)			(((x) & 0xFF) << 8);
+#define _SIFS_OFDM_TRX(x)			(((x) & 0xFF) << 8)
 
 #define _TBTT_PROHIBIT_HOLD(x)			(((x) & 0xFF) << 8)
 
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index e7fc70d..2e7c136 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -35,7 +35,7 @@
  * mode page were taken from the LSI RDAC 2.4 GPL'd
  * driver, and then converted to Linux conventions.
  */
-#define RDAC_QUIESCENCE_TIME 20;
+#define RDAC_QUIESCENCE_TIME 20
 /*
  * Page Codes
  */
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 9059524..ab4c4d6 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -2955,18 +2955,18 @@ typedef struct _SLI2_RDSC {
 typedef struct _PCB {
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint32_t type:8;
-#define TYPE_NATIVE_SLI2       0x01;
+#define TYPE_NATIVE_SLI2       0x01
 	uint32_t feature:8;
-#define FEATURE_INITIAL_SLI2   0x01;
+#define FEATURE_INITIAL_SLI2   0x01
 	uint32_t rsvd:12;
 	uint32_t maxRing:4;
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
 	uint32_t maxRing:4;
 	uint32_t rsvd:12;
 	uint32_t feature:8;
-#define FEATURE_INITIAL_SLI2   0x01;
+#define FEATURE_INITIAL_SLI2   0x01
 	uint32_t type:8;
-#define TYPE_NATIVE_SLI2       0x01;
+#define TYPE_NATIVE_SLI2       0x01
 #endif
 
 	uint32_t mailBoxSize;
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index efeb4d1..14f66c3 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -166,7 +166,7 @@ struct twl4030_usb {
 };
 
 /* internal define on top of container_of */
-#define xceiv_to_twl(x)		container_of((x), struct twl4030_usb, otg);
+#define xceiv_to_twl(x)		container_of((x), struct twl4030_usb, otg)
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/video/i810/i810.h b/drivers/video/i810/i810.h
index f37de60..1414b73 100644
--- a/drivers/video/i810/i810.h
+++ b/drivers/video/i810/i810.h
@@ -137,7 +137,7 @@
 #define DRAM_ON                     0x08            
 #define DRAM_OFF                    0xE7
 #define PG_ENABLE_MASK              0x01
-#define RING_SIZE_MASK              (RINGBUFFER_SIZE - 1);
+#define RING_SIZE_MASK              (RINGBUFFER_SIZE - 1)
 
 /* defines for restoring registers partially */
 #define ADDR_MAP_MASK               (0x07 << 5)
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 6365f04..5637551 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -35,7 +35,7 @@
 #define CEPH_OPT_MYIP             (1<<2) /* specified my ip */
 #define CEPH_OPT_NOCRC            (1<<3) /* no data crc on writes */
 
-#define CEPH_OPT_DEFAULT   (0);
+#define CEPH_OPT_DEFAULT   (0)
 
 #define ceph_set_opt(client, opt) \
 	(client)->options->flags |= CEPH_OPT_##opt;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 8bb85b9..73572c6 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -269,7 +269,7 @@
 #define LDO1_SEL_MASK					0xFC
 #define LDO3_SEL_MASK					0x7C
 #define LDO_MIN_VOLT					1000
-#define LDO_MAX_VOLT					3300;
+#define LDO_MAX_VOLT					3300
 
 
 /*Register VDIG1  (0x80) register.RegisterDescription */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 3668903..8001ae4 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -495,7 +495,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
-#define sense_valid(sense)  ((sense) & 0x80);
+#define sense_valid(sense)  ((sense) & 0x80)
 
 /*
  * default timeouts
diff --git a/include/sound/soundfont.h b/include/sound/soundfont.h
index f95d99b..679df05 100644
--- a/include/sound/soundfont.h
+++ b/include/sound/soundfont.h
@@ -121,7 +121,7 @@ int snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
 int snd_sf_calc_parm_hold(int msec);
 int snd_sf_calc_parm_attack(int msec);
 int snd_sf_calc_parm_decay(int msec);
-#define snd_sf_calc_parm_delay(msec) (0x8000 - (msec) * 1000 / 725);
+#define snd_sf_calc_parm_delay(msec) (0x8000 - (msec) * 1000 / 725)
 extern int snd_sf_vol_table[128];
 int snd_sf_linear_to_log(unsigned int amount, int offset, int ratio);
 
diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..5b7f7eb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4058,7 +4058,7 @@ static int any_slab_objects(struct kmem_cache *s)
 #endif
 
 #define to_slab_attr(n) container_of(n, struct slab_attribute, attr)
-#define to_slab(n) container_of(n, struct kmem_cache, kobj);
+#define to_slab(n) container_of(n, struct kmem_cache, kobj)
 
 struct slab_attribute {
 	struct attribute attr;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2b18053..3460108 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -57,29 +57,29 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 #define PREQ_IE_TTL(x)		(*(x + 2))
 #define PREQ_IE_PREQ_ID(x)	u32_field_get(x, 3, 0)
 #define PREQ_IE_ORIG_ADDR(x)	(x + 7)
-#define PREQ_IE_ORIG_SN(x)	u32_field_get(x, 13, 0);
-#define PREQ_IE_LIFETIME(x)	u32_field_get(x, 17, AE_F_SET(x));
-#define PREQ_IE_METRIC(x) 	u32_field_get(x, 21, AE_F_SET(x));
+#define PREQ_IE_ORIG_SN(x)	u32_field_get(x, 13, 0)
+#define PREQ_IE_LIFETIME(x)	u32_field_get(x, 17, AE_F_SET(x))
+#define PREQ_IE_METRIC(x) 	u32_field_get(x, 21, AE_F_SET(x))
 #define PREQ_IE_TARGET_F(x)	(*(AE_F_SET(x) ? x + 32 : x + 26))
 #define PREQ_IE_TARGET_ADDR(x) 	(AE_F_SET(x) ? x + 33 : x + 27)
-#define PREQ_IE_TARGET_SN(x) 	u32_field_get(x, 33, AE_F_SET(x));
+#define PREQ_IE_TARGET_SN(x) 	u32_field_get(x, 33, AE_F_SET(x))
 
 
 #define PREP_IE_FLAGS(x)	PREQ_IE_FLAGS(x)
 #define PREP_IE_HOPCOUNT(x)	PREQ_IE_HOPCOUNT(x)
 #define PREP_IE_TTL(x)		PREQ_IE_TTL(x)
 #define PREP_IE_ORIG_ADDR(x)	(x + 3)
-#define PREP_IE_ORIG_SN(x)	u32_field_get(x, 9, 0);
-#define PREP_IE_LIFETIME(x)	u32_field_get(x, 13, AE_F_SET(x));
-#define PREP_IE_METRIC(x)	u32_field_get(x, 17, AE_F_SET(x));
+#define PREP_IE_ORIG_SN(x)	u32_field_get(x, 9, 0)
+#define PREP_IE_LIFETIME(x)	u32_field_get(x, 13, AE_F_SET(x))
+#define PREP_IE_METRIC(x)	u32_field_get(x, 17, AE_F_SET(x))
 #define PREP_IE_TARGET_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
-#define PREP_IE_TARGET_SN(x)	u32_field_get(x, 27, AE_F_SET(x));
+#define PREP_IE_TARGET_SN(x)	u32_field_get(x, 27, AE_F_SET(x))
 
 #define PERR_IE_TTL(x)		(*(x))
 #define PERR_IE_TARGET_FLAGS(x)	(*(x + 2))
 #define PERR_IE_TARGET_ADDR(x)	(x + 3)
-#define PERR_IE_TARGET_SN(x)	u32_field_get(x, 9, 0);
-#define PERR_IE_TARGET_RCODE(x)	u16_field_get(x, 13, 0);
+#define PERR_IE_TARGET_SN(x)	u32_field_get(x, 9, 0)
+#define PERR_IE_TARGET_RCODE(x)	u16_field_get(x, 13, 0)
 
 #define MSEC_TO_TU(x) (x*1000/1024)
 #define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
-- 
1.7.2.5

