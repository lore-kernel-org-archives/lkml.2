Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab1ESNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:15:36 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:53706 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932671Ab1ESNPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:15:35 -0400
Date: Thu, 19 May 2011 14:15:35 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, Wu Zhangjin <wuzhangjin@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Make the struct pci_dev * argument of map_irq const.
Message-ID: <20110519131535.GA27424@linux-mips.org>
References: <cb01d61712b1374a8c62bc765094ea7e@localhost>
 <4DAC7499.5000602@gmail.com>
 <20110513101716.GB25345@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513101716.GB25345@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:17:16AM +0100, Ralf Baechle wrote:

> > NAK.
> > 
> > I think Ralf's idea in the e-mail you referenced is the proper approach.
> > 
> > Change pci_fixup_irqs(...) to take a 'const struct pci_dev *'
> > instead. There is a lot of work going on in the kernel to constify
> > things.  This should be fairly easy to get accepted.
> 
> It's a fairly big manual job but should be just right for spatch.

Turns out not that big after all.

(This patch will only apply after Paul Mundt <lethal@linux-sh.org> has
applied a fix to the botched up prototype for pcibios_map_platform_irq()
in arch/sh/drivers/pci/fixups-se7751.c.)

  Ralf

From: Ralf Baechle <ralf@linux-mips.org>

A pointer to this platform or architecture specific function is being
passed to pci_fixup_irqs() so its prototype changes as well.

There are the usual motivations to make this const.  But this function has
also frequently been abused as a hook for interrupt fixups so I turned
this function const ages ago in the MIPS code but it should probably be
done treewide.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/alpha/kernel/sys_alcor.c           |    2 +-
 arch/alpha/kernel/sys_cabriolet.c       |    6 +++---
 arch/alpha/kernel/sys_dp264.c           |    8 ++++----
 arch/alpha/kernel/sys_eb64p.c           |    2 +-
 arch/alpha/kernel/sys_eiger.c           |    2 +-
 arch/alpha/kernel/sys_marvel.c          |    2 +-
 arch/alpha/kernel/sys_miata.c           |    2 +-
 arch/alpha/kernel/sys_mikasa.c          |    2 +-
 arch/alpha/kernel/sys_nautilus.c        |    2 +-
 arch/alpha/kernel/sys_noritake.c        |    2 +-
 arch/alpha/kernel/sys_rawhide.c         |    2 +-
 arch/alpha/kernel/sys_ruffian.c         |    2 +-
 arch/alpha/kernel/sys_rx164.c           |    2 +-
 arch/alpha/kernel/sys_sable.c           |    4 ++--
 arch/alpha/kernel/sys_sio.c             |    4 ++--
 arch/alpha/kernel/sys_sx164.c           |    2 +-
 arch/alpha/kernel/sys_takara.c          |    4 ++--
 arch/alpha/kernel/sys_titan.c           |    2 +-
 arch/alpha/kernel/sys_wildfire.c        |    2 +-
 arch/arm/kernel/bios32.c                |    2 +-
 arch/sh/drivers/pci/fixups-cayman.c     |    2 +-
 arch/sh/drivers/pci/fixups-dreamcast.c  |    2 +-
 arch/sh/drivers/pci/fixups-landisk.c    |    2 +-
 arch/sh/drivers/pci/fixups-r7780rp.c    |    2 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c |    2 +-
 arch/sh/drivers/pci/fixups-sdk7780.c    |    2 +-
 arch/sh/drivers/pci/fixups-se7751.c     |    2 +-
 arch/sh/drivers/pci/fixups-sh03.c       |    2 +-
 arch/sh/drivers/pci/fixups-snapgear.c   |    2 +-
 arch/sh/drivers/pci/fixups-titan.c      |    2 +-
 arch/sh/drivers/pci/pcie-sh7786.c       |    2 +-
 arch/sh/include/asm/pci.h               |    2 +-
 arch/tile/kernel/pci.c                  |    2 +-
 arch/unicore32/kernel/pci.c             |    2 +-
 arch/x86/pci/visws.c                    |    2 +-
 drivers/pci/setup-irq.c                 |    4 ++--
 include/linux/pci.h                     |    2 +-
 37 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index 0e14399..8606d77 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -183,7 +183,7 @@ alcor_init_irq(void)
  */
 
 static int __init
-alcor_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+alcor_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[7][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
index c8c112d..1029619 100644
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -175,7 +175,7 @@ pc164_init_irq(void)
  */
 
 static inline int __init
-eb66p_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+eb66p_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT  INTA  INTB  INTC   INTD */
@@ -205,7 +205,7 @@ eb66p_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
  */
 
 static inline int __init
-cabriolet_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+cabriolet_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT   INTA  INTB  INTC   INTD */
@@ -289,7 +289,7 @@ cia_cab_init_pci(void)
  */
 
 static inline int __init
-alphapc164_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+alphapc164_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[7][5] __initdata = {
 		/*INT   INTA  INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 5ac00fd..c5abd0b 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -382,7 +382,7 @@ isa_irq_fixup(struct pci_dev *dev, int irq)
 }
 
 static int __init
-dp264_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+dp264_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[6][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -404,7 +404,7 @@ dp264_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 }
 
 static int __init
-monet_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+monet_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[13][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -466,7 +466,7 @@ monet_swizzle(struct pci_dev *dev, u8 *pinp)
 }
 
 static int __init
-webbrick_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+webbrick_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[13][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -488,7 +488,7 @@ webbrick_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 }
 
 static int __init
-clipper_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+clipper_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[7][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
index a7a23b4..3c6c13c 100644
--- a/arch/alpha/kernel/sys_eb64p.c
+++ b/arch/alpha/kernel/sys_eb64p.c
@@ -169,7 +169,7 @@ eb64p_init_irq(void)
  */
 
 static int __init
-eb64p_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+eb64p_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT  INTA  INTB  INTC   INTD */
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index a60cd5b..35f480d 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -144,7 +144,7 @@ eiger_init_irq(void)
 }
 
 static int __init
-eiger_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+eiger_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	u8 irq_orig;
 
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 388b99d..95cfc83 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -318,7 +318,7 @@ marvel_init_irq(void)
 }
 
 static int 
-marvel_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+marvel_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_controller *hose = dev->sysdata;
 	struct io7_port *io7_port = hose->sysdata;
diff --git a/arch/alpha/kernel/sys_miata.c b/arch/alpha/kernel/sys_miata.c
index 61ccd95..258da68 100644
--- a/arch/alpha/kernel/sys_miata.c
+++ b/arch/alpha/kernel/sys_miata.c
@@ -151,7 +151,7 @@ miata_init_irq(void)
  */
 
 static int __init
-miata_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+miata_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
         static char irq_tab[18][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index 0e6e469..c0fd728 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -146,7 +146,7 @@ mikasa_init_irq(void)
  */
 
 static int __init
-mikasa_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+mikasa_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[8][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 99c0f46..4112200 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -65,7 +65,7 @@ nautilus_init_irq(void)
 }
 
 static int __init
-nautilus_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+nautilus_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/* Preserve the IRQ set up by the console.  */
 
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index a00ac70..2172528 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -194,7 +194,7 @@ noritake_init_irq(void)
  */
 
 static int __init
-noritake_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+noritake_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[15][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
index 7f52161..a125d6b 100644
--- a/arch/alpha/kernel/sys_rawhide.c
+++ b/arch/alpha/kernel/sys_rawhide.c
@@ -223,7 +223,7 @@ rawhide_init_irq(void)
  */
 
 static int __init
-rawhide_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+rawhide_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_ruffian.c b/arch/alpha/kernel/sys_ruffian.c
index 8de1046..915b975 100644
--- a/arch/alpha/kernel/sys_ruffian.c
+++ b/arch/alpha/kernel/sys_ruffian.c
@@ -120,7 +120,7 @@ ruffian_kill_arch (int mode)
  */
 
 static int __init
-ruffian_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+ruffian_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
         static char irq_tab[11][5] __initdata = {
 	      /*INT  INTA INTB INTC INTD */
diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
index 216d94d..b172b27 100644
--- a/arch/alpha/kernel/sys_rx164.c
+++ b/arch/alpha/kernel/sys_rx164.c
@@ -144,7 +144,7 @@ rx164_init_irq(void)
  */
 
 static int __init
-rx164_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+rx164_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 #if 0
 	static char irq_tab_pass1[6][5] __initdata = {
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index da714e4..98d1dbf 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -194,7 +194,7 @@ sable_init_irq(void)
  */
 
 static int __init
-sable_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+sable_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[9][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
@@ -376,7 +376,7 @@ lynx_init_irq(void)
  */
 
 static int __init
-lynx_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+lynx_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[19][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index 85b4aea..47bec1e 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -146,7 +146,7 @@ sio_fixup_irq_levels(unsigned int level_bits)
 }
 
 static inline int __init
-noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+noname_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/*
 	 * The Noname board has 5 PCI slots with each of the 4
@@ -185,7 +185,7 @@ noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 }
 
 static inline int __init
-p2k_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+p2k_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[][5] __initdata = {
 		/*INT A   B   C   D */
diff --git a/arch/alpha/kernel/sys_sx164.c b/arch/alpha/kernel/sys_sx164.c
index 41d4ad4..73e1c31 100644
--- a/arch/alpha/kernel/sys_sx164.c
+++ b/arch/alpha/kernel/sys_sx164.c
@@ -95,7 +95,7 @@ sx164_init_irq(void)
  */
 
 static int __init
-sx164_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+sx164_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[5][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/alpha/kernel/sys_takara.c b/arch/alpha/kernel/sys_takara.c
index a31f8cd..2ae99ad 100644
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -157,7 +157,7 @@ takara_init_irq(void)
  */
 
 static int __init
-takara_map_irq_srm(struct pci_dev *dev, u8 slot, u8 pin)
+takara_map_irq_srm(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[15][5] __initdata = {
 		{ 16+3, 16+3, 16+3, 16+3, 16+3},   /* slot  6 == device 3 */
@@ -188,7 +188,7 @@ takara_map_irq_srm(struct pci_dev *dev, u8 slot, u8 pin)
 }
 
 static int __init
-takara_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+takara_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[15][5] __initdata = {
 		{ 16+3, 16+3, 16+3, 16+3, 16+3},   /* slot  6 == device 3 */
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index fea0e46..003a55f 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -304,7 +304,7 @@ titan_late_init(void)
 }
 
 static int __devinit
-titan_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+titan_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	u8 intline;
 	int irq;
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index d92cdc7..17c85a6 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -290,7 +290,7 @@ wildfire_device_interrupt(unsigned long vector)
  */
 
 static int __init
-wildfire_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+wildfire_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	static char irq_tab[8][5] __initdata = {
 		/*INT    INTA   INTB   INTC   INTD */
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index e4ee050..d6df359 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -476,7 +476,7 @@ static u8 __devinit pcibios_swizzle(struct pci_dev *dev, u8 *pin)
 /*
  * Map a slot/pin to an IRQ.
  */
-static int pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_sys_data *sys = dev->sysdata;
 	int irq = -1;
diff --git a/arch/sh/drivers/pci/fixups-cayman.c b/arch/sh/drivers/pci/fixups-cayman.c
index b68b61d..edc2fb7 100644
--- a/arch/sh/drivers/pci/fixups-cayman.c
+++ b/arch/sh/drivers/pci/fixups-cayman.c
@@ -5,7 +5,7 @@
 #include <cpu/irq.h>
 #include "pci-sh5.h"
 
-int __init pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int result = -1;
 
diff --git a/arch/sh/drivers/pci/fixups-dreamcast.c b/arch/sh/drivers/pci/fixups-dreamcast.c
index 942ef4f..edeea89 100644
--- a/arch/sh/drivers/pci/fixups-dreamcast.c
+++ b/arch/sh/drivers/pci/fixups-dreamcast.c
@@ -64,7 +64,7 @@ static void __init gapspci_fixup_resources(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, gapspci_fixup_resources);
 
-int __init pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/*
 	 * The interrupt routing semantics here are quite trivial.
diff --git a/arch/sh/drivers/pci/fixups-landisk.c b/arch/sh/drivers/pci/fixups-landisk.c
index 95c6e2d..ecb1d10 100644
--- a/arch/sh/drivers/pci/fixups-landisk.c
+++ b/arch/sh/drivers/pci/fixups-landisk.c
@@ -19,7 +19,7 @@
 #define PCIMCR_MRSET_OFF	0xBFFFFFFF
 #define PCIMCR_RFSH_OFF		0xFFFFFFFB
 
-int pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	/*
 	 * slot0: pin1-4 = irq5,6,7,8
diff --git a/arch/sh/drivers/pci/fixups-r7780rp.c b/arch/sh/drivers/pci/fixups-r7780rp.c
index 08b2d86..f9370dc 100644
--- a/arch/sh/drivers/pci/fixups-r7780rp.c
+++ b/arch/sh/drivers/pci/fixups-r7780rp.c
@@ -18,7 +18,7 @@ static char irq_tab[] __initdata = {
 	65, 66, 67, 68,
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	return irq_tab[slot];
 }
diff --git a/arch/sh/drivers/pci/fixups-rts7751r2d.c b/arch/sh/drivers/pci/fixups-rts7751r2d.c
index e248516..eaddb56 100644
--- a/arch/sh/drivers/pci/fixups-rts7751r2d.c
+++ b/arch/sh/drivers/pci/fixups-rts7751r2d.c
@@ -31,7 +31,7 @@ static char lboxre2_irq_tab[] __initdata = {
 	IRQ_ETH0, IRQ_ETH1, IRQ_INTA, IRQ_INTD,
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	if (mach_is_lboxre2())
 		return lboxre2_irq_tab[slot];
diff --git a/arch/sh/drivers/pci/fixups-sdk7780.c b/arch/sh/drivers/pci/fixups-sdk7780.c
index 0930f98..0b84725 100644
--- a/arch/sh/drivers/pci/fixups-sdk7780.c
+++ b/arch/sh/drivers/pci/fixups-sdk7780.c
@@ -27,7 +27,7 @@ static char sdk7780_irq_tab[4][16] __initdata = {
 	{ 68, 67, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
        return sdk7780_irq_tab[pin-1][slot];
 }
diff --git a/arch/sh/drivers/pci/fixups-se7751.c b/arch/sh/drivers/pci/fixups-se7751.c
index fd3e6b0..2ec146c 100644
--- a/arch/sh/drivers/pci/fixups-se7751.c
+++ b/arch/sh/drivers/pci/fixups-se7751.c
@@ -6,7 +6,7 @@
 #include <linux/io.h>
 #include "pci-sh4.h"
 
-int __init pcibios_map_platform_irq(struct pci_dev *, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *, u8 slot, u8 pin)
 {
         switch (slot) {
         case 0: return 13;
diff --git a/arch/sh/drivers/pci/fixups-sh03.c b/arch/sh/drivers/pci/fixups-sh03.c
index 2e8a18b..1615e59 100644
--- a/arch/sh/drivers/pci/fixups-sh03.c
+++ b/arch/sh/drivers/pci/fixups-sh03.c
@@ -3,7 +3,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-int __init pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
diff --git a/arch/sh/drivers/pci/fixups-snapgear.c b/arch/sh/drivers/pci/fixups-snapgear.c
index 5a39ecc..4a093c6 100644
--- a/arch/sh/drivers/pci/fixups-snapgear.c
+++ b/arch/sh/drivers/pci/fixups-snapgear.c
@@ -18,7 +18,7 @@
 #include <linux/pci.h>
 #include "pci-sh4.h"
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	int irq = -1;
 
diff --git a/arch/sh/drivers/pci/fixups-titan.c b/arch/sh/drivers/pci/fixups-titan.c
index 3a79fa8..bd1addb 100644
--- a/arch/sh/drivers/pci/fixups-titan.c
+++ b/arch/sh/drivers/pci/fixups-titan.c
@@ -27,7 +27,7 @@ static char titan_irq_tab[] __initdata = {
 	TITAN_IRQ_USB,
 };
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
 	int irq = titan_irq_tab[slot];
 
diff --git a/arch/sh/drivers/pci/pcie-sh7786.c b/arch/sh/drivers/pci/pcie-sh7786.c
index 4418f90..4df27c4f 100644
--- a/arch/sh/drivers/pci/pcie-sh7786.c
+++ b/arch/sh/drivers/pci/pcie-sh7786.c
@@ -466,7 +466,7 @@ static int __init pcie_init(struct sh7786_pcie_port *port)
 	return 0;
 }
 
-int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
+int __init pcibios_map_platform_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 {
         return 71;
 }
diff --git a/arch/sh/include/asm/pci.h b/arch/sh/include/asm/pci.h
index f0efe97..cb21e23 100644
--- a/arch/sh/include/asm/pci.h
+++ b/arch/sh/include/asm/pci.h
@@ -112,7 +112,7 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 #endif
 
 /* Board-specific fixup routines. */
-int pcibios_map_platform_irq(struct pci_dev *dev, u8 slot, u8 pin);
+int pcibios_map_platform_irq(const struct pci_dev *dev, u8 slot, u8 pin);
 
 extern void pcibios_resource_to_bus(struct pci_dev *dev,
 	struct pci_bus_region *region, struct resource *res);
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index ea38f0c..3f3e20f 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -224,7 +224,7 @@ err_cont:
  * (pin - 1) converts from the PCI standard's [1:4] convention to
  * a normal [0:3] range.
  */
-static int tile_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int tile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_controller *controller =
 		(struct pci_controller *)dev->sysdata;
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index 100eab8..4892fbb 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -102,7 +102,7 @@ void pci_puv3_preinit(void)
 	writel(readl(PCIBRI_CMD) | PCIBRI_CMD_IO | PCIBRI_CMD_MEM, PCIBRI_CMD);
 }
 
-static int __init pci_puv3_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init pci_puv3_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->bus->number == 0) {
 #ifdef CONFIG_ARCH_FPGA /* 4 pci slots */
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 03008f7..6f2f8ee 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -24,7 +24,7 @@ static void pci_visws_disable_irq(struct pci_dev *dev) { }
 
 unsigned int pci_bus0, pci_bus1;
 
-static int __init visws_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+static int __init visws_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq, bus = dev->bus->number;
 
diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index eec9738..eb219a1 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -21,7 +21,7 @@
 static void __init
 pdev_fixup_irq(struct pci_dev *dev,
 	       u8 (*swizzle)(struct pci_dev *, u8 *),
-	       int (*map_irq)(struct pci_dev *, u8, u8))
+	       int (*map_irq)(const struct pci_dev *, u8, u8))
 {
 	u8 pin, slot;
 	int irq = 0;
@@ -56,7 +56,7 @@ pdev_fixup_irq(struct pci_dev *dev,
 
 void __init
 pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
-	       int (*map_irq)(struct pci_dev *, u8, u8))
+	       int (*map_irq)(const struct pci_dev *, u8, u8))
 {
 	struct pci_dev *dev = NULL;
 	for_each_pci_dev(dev)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96f70d7..f132fdf 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -853,7 +853,7 @@ void pdev_enable_device(struct pci_dev *);
 void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
-		    int (*)(struct pci_dev *, u8, u8));
+		    int (*)(const struct pci_dev *, u8, u8));
 #define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
