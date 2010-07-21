Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab0GUXkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:40:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35567 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065Ab0GUXkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:40:09 -0400
Subject: [PATCH 3/5] of/platform: remove all of_bus_type and
	of_platform_bus_type references
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:05 -0600
Message-ID: <20100721234005.7782.52867.stgit@angua>
In-Reply-To: <20100721232817.7782.23410.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of_bus_type and of_platform_bus_type are just #define aliases
for the platform bus.  This patch removes all references to them and
switches to the of_register_platform_driver()/of_unregister_platform_driver()
API for registering.

Subsequent patches will convert each user of of_register_platform_driver()
into plain platform_drivers without the of_platform_driver shim.  At which
point the of_register_platform_driver()/of_unregister_platform_driver()
functions can be removed.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/of_platform.c |    3 +--
 arch/powerpc/kernel/of_platform.c    |    3 +--
 arch/sparc/include/asm/of_platform.h |    2 --
 arch/sparc/include/asm/parport.h     |    4 +---
 arch/sparc/kernel/apc.c              |    2 +-
 arch/sparc/kernel/auxio_64.c         |    2 +-
 arch/sparc/kernel/central.c          |    4 ++--
 arch/sparc/kernel/chmc.c             |    4 ++--
 arch/sparc/kernel/of_device_common.c |    2 +-
 arch/sparc/kernel/pci_fire.c         |    2 +-
 arch/sparc/kernel/pci_psycho.c       |    2 +-
 arch/sparc/kernel/pci_sabre.c        |    2 +-
 arch/sparc/kernel/pci_schizo.c       |    2 +-
 arch/sparc/kernel/pci_sun4v.c        |    2 +-
 arch/sparc/kernel/pmc.c              |    2 +-
 arch/sparc/kernel/power.c            |    2 +-
 arch/sparc/kernel/time_32.c          |    2 +-
 arch/sparc/kernel/time_64.c          |    6 +++---
 drivers/atm/fore200e.c               |    6 +++---
 drivers/char/hw_random/n2-drv.c      |    4 ++--
 drivers/crypto/n2_core.c             |   10 +++++-----
 drivers/hwmon/ultra45_env.c          |    4 ++--
 drivers/input/misc/sparcspkr.c       |   12 +++++-------
 drivers/input/serio/i8042-sparcio.h  |    5 ++---
 drivers/mtd/maps/sun_uflash.c        |    4 ++--
 drivers/net/ibm_newemac/core.c       |    4 ++--
 drivers/net/myri_sbus.c              |    4 ++--
 drivers/net/niu.c                    |    6 +++---
 drivers/net/sunbmac.c                |    4 ++--
 drivers/net/sunhme.c                 |    4 ++--
 drivers/net/sunlance.c               |    4 ++--
 drivers/net/sunqe.c                  |    4 ++--
 drivers/parport/parport_sunbpp.c     |    4 ++--
 drivers/sbus/char/bbc_i2c.c          |    4 ++--
 drivers/sbus/char/display7seg.c      |    4 ++--
 drivers/sbus/char/envctrl.c          |    4 ++--
 drivers/sbus/char/flash.c            |    4 ++--
 drivers/sbus/char/uctrl.c            |    4 ++--
 drivers/scsi/qlogicpti.c             |    4 ++--
 drivers/scsi/sun_esp.c               |    4 ++--
 drivers/serial/sunhv.c               |    4 ++--
 drivers/serial/sunsab.c              |    4 ++--
 drivers/serial/sunsu.c               |    2 +-
 drivers/serial/sunzilog.c            |    6 +++---
 drivers/video/bw2.c                  |    4 ++--
 drivers/video/cg14.c                 |    4 ++--
 drivers/video/cg3.c                  |    4 ++--
 drivers/video/cg6.c                  |    4 ++--
 drivers/video/ffb.c                  |    4 ++--
 drivers/video/leo.c                  |    4 ++--
 drivers/video/p9100.c                |    4 ++--
 drivers/video/sunxvr1000.c           |    4 ++--
 drivers/video/tcx.c                  |    4 ++--
 drivers/watchdog/cpwd.c              |    4 ++--
 drivers/watchdog/riowd.c             |    4 ++--
 include/linux/of_platform.h          |    6 ------
 sound/sparc/amd7930.c                |    4 ++--
 sound/sparc/cs4231.c                 |    4 ++--
 sound/sparc/dbri.c                   |    4 ++--
 59 files changed, 109 insertions(+), 124 deletions(-)

diff --git a/arch/microblaze/kernel/of_platform.c b/arch/microblaze/kernel/of_platform.c
index fb28661..80c9c49 100644
--- a/arch/microblaze/kernel/of_platform.c
+++ b/arch/microblaze/kernel/of_platform.c
@@ -57,8 +57,7 @@ struct of_device *of_find_device_by_node(struct device_node *np)
 {
 	struct device *dev;
 
-	dev = bus_find_device(&of_platform_bus_type,
-			      NULL, np, of_dev_node_match);
+	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
 	if (dev)
 		return to_of_device(dev);
 	return NULL;
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index d3497cd..b093d4b 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -61,8 +61,7 @@ struct of_device *of_find_device_by_node(struct device_node *np)
 {
 	struct device *dev;
 
-	dev = bus_find_device(&of_platform_bus_type,
-			      NULL, np, of_dev_node_match);
+	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
 	if (dev)
 		return to_of_device(dev);
 	return NULL;
diff --git a/arch/sparc/include/asm/of_platform.h b/arch/sparc/include/asm/of_platform.h
index 90da990..26540dd 100644
--- a/arch/sparc/include/asm/of_platform.h
+++ b/arch/sparc/include/asm/of_platform.h
@@ -13,6 +13,4 @@
  *
  */
 
-#define of_bus_type	of_platform_bus_type	/* for compatibility */
-
 #endif
diff --git a/arch/sparc/include/asm/parport.h b/arch/sparc/include/asm/parport.h
index 0c34a87..4891fbc 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -243,9 +243,7 @@ static struct of_platform_driver ecpp_driver = {
 
 static int parport_pc_find_nonpci_ports(int autoirq, int autodma)
 {
-	of_register_driver(&ecpp_driver, &of_bus_type);
-
-	return 0;
+	return of_register_platform_driver(&ecpp_driver);
 }
 
 #endif /* !(_ASM_SPARC64_PARPORT_H */
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index b27476c..c471251 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -184,7 +184,7 @@ static struct of_platform_driver apc_driver = {
 
 static int __init apc_init(void)
 {
-	return of_register_driver(&apc_driver, &of_bus_type);
+	return of_register_platform_driver(&apc_driver);
 }
 
 /* This driver is not critical to the boot process
diff --git a/arch/sparc/kernel/auxio_64.c b/arch/sparc/kernel/auxio_64.c
index ddc8412..46ba58a 100644
--- a/arch/sparc/kernel/auxio_64.c
+++ b/arch/sparc/kernel/auxio_64.c
@@ -142,7 +142,7 @@ static struct of_platform_driver auxio_driver = {
 
 static int __init auxio_init(void)
 {
-	return of_register_driver(&auxio_driver, &of_platform_bus_type);
+	return of_register_platform_driver(&auxio_driver);
 }
 
 /* Must be after subsys_initcall() so that busses are probed.  Must
diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index 434335f..b6080c3 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -265,8 +265,8 @@ static struct of_platform_driver fhc_driver = {
 
 static int __init sunfire_init(void)
 {
-	(void) of_register_driver(&fhc_driver, &of_platform_bus_type);
-	(void) of_register_driver(&clock_board_driver, &of_platform_bus_type);
+	(void) of_register_platform_driver(&fhc_driver);
+	(void) of_register_platform_driver(&clock_board_driver);
 	return 0;
 }
 
diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index 870cb65..04bb7df 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -848,7 +848,7 @@ static int __init us3mc_init(void)
 	ret = register_dimm_printer(us3mc_dimm_printer);
 
 	if (!ret) {
-		ret = of_register_driver(&us3mc_driver, &of_bus_type);
+		ret = of_register_platform_driver(&us3mc_driver);
 		if (ret)
 			unregister_dimm_printer(us3mc_dimm_printer);
 	}
@@ -859,7 +859,7 @@ static void __exit us3mc_cleanup(void)
 {
 	if (us3mc_platform()) {
 		unregister_dimm_printer(us3mc_dimm_printer);
-		of_unregister_driver(&us3mc_driver);
+		of_unregister_platform_driver(&us3mc_driver);
 	}
 }
 
diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index 01f380c..2a5c639 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -21,7 +21,7 @@ static int node_match(struct device *dev, void *data)
 
 struct of_device *of_find_device_by_node(struct device_node *dp)
 {
-	struct device *dev = bus_find_device(&of_platform_bus_type, NULL,
+	struct device *dev = bus_find_device(&platform_bus_type, NULL,
 					     dp, node_match);
 
 	if (dev)
diff --git a/arch/sparc/kernel/pci_fire.c b/arch/sparc/kernel/pci_fire.c
index 51cfa09..885f10b 100644
--- a/arch/sparc/kernel/pci_fire.c
+++ b/arch/sparc/kernel/pci_fire.c
@@ -518,7 +518,7 @@ static struct of_platform_driver fire_driver = {
 
 static int __init fire_init(void)
 {
-	return of_register_driver(&fire_driver, &of_bus_type);
+	return of_register_platform_driver(&fire_driver);
 }
 
 subsys_initcall(fire_init);
diff --git a/arch/sparc/kernel/pci_psycho.c b/arch/sparc/kernel/pci_psycho.c
index 93011e6..71550a7 100644
--- a/arch/sparc/kernel/pci_psycho.c
+++ b/arch/sparc/kernel/pci_psycho.c
@@ -612,7 +612,7 @@ static struct of_platform_driver psycho_driver = {
 
 static int __init psycho_init(void)
 {
-	return of_register_driver(&psycho_driver, &of_bus_type);
+	return of_register_platform_driver(&psycho_driver);
 }
 
 subsys_initcall(psycho_init);
diff --git a/arch/sparc/kernel/pci_sabre.c b/arch/sparc/kernel/pci_sabre.c
index 99c6dba..2d7bf30 100644
--- a/arch/sparc/kernel/pci_sabre.c
+++ b/arch/sparc/kernel/pci_sabre.c
@@ -606,7 +606,7 @@ static struct of_platform_driver sabre_driver = {
 
 static int __init sabre_init(void)
 {
-	return of_register_driver(&sabre_driver, &of_bus_type);
+	return of_register_platform_driver(&sabre_driver);
 }
 
 subsys_initcall(sabre_init);
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 9041dae..04f29c4 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -1501,7 +1501,7 @@ static struct of_platform_driver schizo_driver = {
 
 static int __init schizo_init(void)
 {
-	return of_register_driver(&schizo_driver, &of_bus_type);
+	return of_register_platform_driver(&schizo_driver);
 }
 
 subsys_initcall(schizo_init);
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index a24af6f..18ee8b6 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -1019,7 +1019,7 @@ static struct of_platform_driver pci_sun4v_driver = {
 
 static int __init pci_sun4v_init(void)
 {
-	return of_register_driver(&pci_sun4v_driver, &of_bus_type);
+	return of_register_platform_driver(&pci_sun4v_driver);
 }
 
 subsys_initcall(pci_sun4v_init);
diff --git a/arch/sparc/kernel/pmc.c b/arch/sparc/kernel/pmc.c
index 9589d8b..a4c73ed 100644
--- a/arch/sparc/kernel/pmc.c
+++ b/arch/sparc/kernel/pmc.c
@@ -89,7 +89,7 @@ static struct of_platform_driver pmc_driver = {
 
 static int __init pmc_init(void)
 {
-	return of_register_driver(&pmc_driver, &of_bus_type);
+	return of_register_platform_driver(&pmc_driver);
 }
 
 /* This driver is not critical to the boot process
diff --git a/arch/sparc/kernel/power.c b/arch/sparc/kernel/power.c
index 1cfee57..abc194e 100644
--- a/arch/sparc/kernel/power.c
+++ b/arch/sparc/kernel/power.c
@@ -70,7 +70,7 @@ static struct of_platform_driver power_driver = {
 
 static int __init power_init(void)
 {
-	return of_register_driver(&power_driver, &of_platform_bus_type);
+	return of_register_platform_driver(&power_driver);
 }
 
 device_initcall(power_init);
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index e404b06..5dc2021 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -189,7 +189,7 @@ static struct of_platform_driver clock_driver = {
 /* Probe for the mostek real time clock chip. */
 static int __init clock_init(void)
 {
-	return of_register_driver(&clock_driver, &of_platform_bus_type);
+	return of_register_platform_driver(&clock_driver);
 }
 /* Must be after subsys_initcall() so that busses are probed.  Must
  * be before device_initcall() because things like the RTC driver
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 21e9fca..2423b33 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -586,9 +586,9 @@ static int __init clock_init(void)
 	if (tlb_type == hypervisor)
 		return platform_device_register(&rtc_sun4v_device);
 
-	(void) of_register_driver(&rtc_driver, &of_platform_bus_type);
-	(void) of_register_driver(&mostek_driver, &of_platform_bus_type);
-	(void) of_register_driver(&bq4802_driver, &of_platform_bus_type);
+	(void) of_register_platform_driver(&rtc_driver);
+	(void) of_register_platform_driver(&mostek_driver);
+	(void) of_register_platform_driver(&bq4802_driver);
 
 	return 0;
 }
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 38df87b..b7385e0 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2795,7 +2795,7 @@ static int __init fore200e_module_init(void)
 	printk(FORE200E "FORE Systems 200E-series ATM driver - version " FORE200E_VERSION "\n");
 
 #ifdef CONFIG_SBUS
-	err = of_register_driver(&fore200e_sba_driver, &of_bus_type);
+	err = of_register_platform_driver(&fore200e_sba_driver);
 	if (err)
 		return err;
 #endif
@@ -2806,7 +2806,7 @@ static int __init fore200e_module_init(void)
 
 #ifdef CONFIG_SBUS
 	if (err)
-		of_unregister_driver(&fore200e_sba_driver);
+		of_unregister_platform_driver(&fore200e_sba_driver);
 #endif
 
 	return err;
@@ -2818,7 +2818,7 @@ static void __exit fore200e_module_cleanup(void)
 	pci_unregister_driver(&fore200e_pca_driver);
 #endif
 #ifdef CONFIG_SBUS
-	of_unregister_driver(&fore200e_sba_driver);
+	of_unregister_platform_driver(&fore200e_sba_driver);
 #endif
 }
 
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 0f9cbf1..d8a4ca8 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -762,12 +762,12 @@ static struct of_platform_driver n2rng_driver = {
 
 static int __init n2rng_init(void)
 {
-	return of_register_driver(&n2rng_driver, &of_bus_type);
+	return of_register_platform_driver(&n2rng_driver);
 }
 
 static void __exit n2rng_exit(void)
 {
-	of_unregister_driver(&n2rng_driver);
+	of_unregister_platform_driver(&n2rng_driver);
 }
 
 module_init(n2rng_init);
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 23163fd..34ac8ac 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2070,20 +2070,20 @@ static struct of_platform_driver n2_mau_driver = {
 
 static int __init n2_init(void)
 {
-	int err = of_register_driver(&n2_crypto_driver, &of_bus_type);
+	int err = of_register_platform_driver(&n2_crypto_driver);
 
 	if (!err) {
-		err = of_register_driver(&n2_mau_driver, &of_bus_type);
+		err = of_register_platform_driver(&n2_mau_driver);
 		if (err)
-			of_unregister_driver(&n2_crypto_driver);
+			of_unregister_platform_driver(&n2_crypto_driver);
 	}
 	return err;
 }
 
 static void __exit n2_exit(void)
 {
-	of_unregister_driver(&n2_mau_driver);
-	of_unregister_driver(&n2_crypto_driver);
+	of_unregister_platform_driver(&n2_mau_driver);
+	of_unregister_platform_driver(&n2_crypto_driver);
 }
 
 module_init(n2_init);
diff --git a/drivers/hwmon/ultra45_env.c b/drivers/hwmon/ultra45_env.c
index 5da5942..8964326 100644
--- a/drivers/hwmon/ultra45_env.c
+++ b/drivers/hwmon/ultra45_env.c
@@ -311,12 +311,12 @@ static struct of_platform_driver env_driver = {
 
 static int __init env_init(void)
 {
-	return of_register_driver(&env_driver, &of_bus_type);
+	return of_register_platform_driver(&env_driver);
 }
 
 static void __exit env_exit(void)
 {
-	of_unregister_driver(&env_driver);
+	of_unregister_platform_driver(&env_driver);
 }
 
 module_init(env_init);
diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index 1dacae4..f3bb92e 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -353,14 +353,12 @@ static struct of_platform_driver grover_beep_driver = {
 
 static int __init sparcspkr_init(void)
 {
-	int err = of_register_driver(&bbc_beep_driver,
-				     &of_platform_bus_type);
+	int err = of_register_platform_driver(&bbc_beep_driver);
 
 	if (!err) {
-		err = of_register_driver(&grover_beep_driver,
-					 &of_platform_bus_type);
+		err = of_register_platform_driver(&grover_beep_driver);
 		if (err)
-			of_unregister_driver(&bbc_beep_driver);
+			of_unregister_platform_driver(&bbc_beep_driver);
 	}
 
 	return err;
@@ -368,8 +366,8 @@ static int __init sparcspkr_init(void)
 
 static void __exit sparcspkr_exit(void)
 {
-	of_unregister_driver(&bbc_beep_driver);
-	of_unregister_driver(&grover_beep_driver);
+	of_unregister_platform_driver(&bbc_beep_driver);
+	of_unregister_platform_driver(&grover_beep_driver);
 }
 
 module_init(sparcspkr_init);
diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index c7d50ff..cb2a24b 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -116,8 +116,7 @@ static int __init i8042_platform_init(void)
 		if (!kbd_iobase)
 			return -ENODEV;
 	} else {
-		int err = of_register_driver(&sparc_i8042_driver,
-					     &of_bus_type);
+		int err = of_register_platform_driver(&sparc_i8042_driver);
 		if (err)
 			return err;
 
@@ -141,7 +140,7 @@ static inline void i8042_platform_exit(void)
 	struct device_node *root = of_find_node_by_path("/");
 
 	if (strcmp(root->name, "SUNW,JavaStation-1"))
-		of_unregister_driver(&sparc_i8042_driver);
+		of_unregister_platform_driver(&sparc_i8042_driver);
 }
 
 #else /* !CONFIG_PCI */
diff --git a/drivers/mtd/maps/sun_uflash.c b/drivers/mtd/maps/sun_uflash.c
index 0391c25..8984236 100644
--- a/drivers/mtd/maps/sun_uflash.c
+++ b/drivers/mtd/maps/sun_uflash.c
@@ -160,12 +160,12 @@ static struct of_platform_driver uflash_driver = {
 
 static int __init uflash_init(void)
 {
-	return of_register_driver(&uflash_driver, &of_bus_type);
+	return of_register_platform_driver(&uflash_driver);
 }
 
 static void __exit uflash_exit(void)
 {
-	of_unregister_driver(&uflash_driver);
+	of_unregister_platform_driver(&uflash_driver);
 }
 
 module_init(uflash_init);
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index b150c10..f10476f 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2339,11 +2339,11 @@ static int __devinit emac_wait_deps(struct emac_instance *dev)
 		deps[EMAC_DEP_MDIO_IDX].phandle = dev->mdio_ph;
 	if (dev->blist && dev->blist > emac_boot_list)
 		deps[EMAC_DEP_PREV_IDX].phandle = 0xffffffffu;
-	bus_register_notifier(&of_platform_bus_type, &emac_of_bus_notifier);
+	bus_register_notifier(&platform_bus_type, &emac_of_bus_notifier);
 	wait_event_timeout(emac_probe_wait,
 			   emac_check_deps(dev, deps),
 			   EMAC_PROBE_DEP_TIMEOUT);
-	bus_unregister_notifier(&of_platform_bus_type, &emac_of_bus_notifier);
+	bus_unregister_notifier(&platform_bus_type, &emac_of_bus_notifier);
 	err = emac_check_deps(dev, deps) ? 0 : -ENODEV;
 	for (i = 0; i < EMAC_DEP_COUNT; i++) {
 		if (deps[i].node)
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 370d3c1..04e552a 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -1172,12 +1172,12 @@ static struct of_platform_driver myri_sbus_driver = {
 
 static int __init myri_sbus_init(void)
 {
-	return of_register_driver(&myri_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&myri_sbus_driver);
 }
 
 static void __exit myri_sbus_exit(void)
 {
-	of_unregister_driver(&myri_sbus_driver);
+	of_unregister_platform_driver(&myri_sbus_driver);
 }
 
 module_init(myri_sbus_init);
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index f6ecf61..8cb2b30 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -10251,14 +10251,14 @@ static int __init niu_init(void)
 	niu_debug = netif_msg_init(debug, NIU_MSG_DEFAULT);
 
 #ifdef CONFIG_SPARC64
-	err = of_register_driver(&niu_of_driver, &of_bus_type);
+	err = of_register_platform_driver(&niu_of_driver);
 #endif
 
 	if (!err) {
 		err = pci_register_driver(&niu_pci_driver);
 #ifdef CONFIG_SPARC64
 		if (err)
-			of_unregister_driver(&niu_of_driver);
+			of_unregister_platform_driver(&niu_of_driver);
 #endif
 	}
 
@@ -10269,7 +10269,7 @@ static void __exit niu_exit(void)
 {
 	pci_unregister_driver(&niu_pci_driver);
 #ifdef CONFIG_SPARC64
-	of_unregister_driver(&niu_of_driver);
+	of_unregister_platform_driver(&niu_of_driver);
 #endif
 }
 
diff --git a/drivers/net/sunbmac.c b/drivers/net/sunbmac.c
index 0b10d24..09c071b 100644
--- a/drivers/net/sunbmac.c
+++ b/drivers/net/sunbmac.c
@@ -1301,12 +1301,12 @@ static struct of_platform_driver bigmac_sbus_driver = {
 
 static int __init bigmac_init(void)
 {
-	return of_register_driver(&bigmac_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&bigmac_sbus_driver);
 }
 
 static void __exit bigmac_exit(void)
 {
-	of_unregister_driver(&bigmac_sbus_driver);
+	of_unregister_platform_driver(&bigmac_sbus_driver);
 }
 
 module_init(bigmac_init);
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 0a63ebe..eec443f 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -3304,7 +3304,7 @@ static int __init happy_meal_sbus_init(void)
 {
 	int err;
 
-	err = of_register_driver(&hme_sbus_driver, &of_bus_type);
+	err = of_register_platform_driver(&hme_sbus_driver);
 	if (!err)
 		err = quattro_sbus_register_irqs();
 
@@ -3313,7 +3313,7 @@ static int __init happy_meal_sbus_init(void)
 
 static void happy_meal_sbus_exit(void)
 {
-	of_unregister_driver(&hme_sbus_driver);
+	of_unregister_platform_driver(&hme_sbus_driver);
 	quattro_sbus_free_irqs();
 
 	while (qfe_sbus_list) {
diff --git a/drivers/net/sunlance.c b/drivers/net/sunlance.c
index c6bfdad..ee364fa 100644
--- a/drivers/net/sunlance.c
+++ b/drivers/net/sunlance.c
@@ -1558,12 +1558,12 @@ static struct of_platform_driver sunlance_sbus_driver = {
 /* Find all the lance cards on the system and initialize them */
 static int __init sparc_lance_init(void)
 {
-	return of_register_driver(&sunlance_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&sunlance_sbus_driver);
 }
 
 static void __exit sparc_lance_exit(void)
 {
-	of_unregister_driver(&sunlance_sbus_driver);
+	of_unregister_platform_driver(&sunlance_sbus_driver);
 }
 
 module_init(sparc_lance_init);
diff --git a/drivers/net/sunqe.c b/drivers/net/sunqe.c
index 4465174..5f84a5d 100644
--- a/drivers/net/sunqe.c
+++ b/drivers/net/sunqe.c
@@ -988,12 +988,12 @@ static struct of_platform_driver qec_sbus_driver = {
 
 static int __init qec_init(void)
 {
-	return of_register_driver(&qec_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&qec_sbus_driver);
 }
 
 static void __exit qec_exit(void)
 {
-	of_unregister_driver(&qec_sbus_driver);
+	of_unregister_platform_driver(&qec_sbus_driver);
 
 	while (root_qec_dev) {
 		struct sunqec *next = root_qec_dev->next_module;
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 3cdfe96..210a644 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -393,12 +393,12 @@ static struct of_platform_driver bpp_sbus_driver = {
 
 static int __init parport_sunbpp_init(void)
 {
-	return of_register_driver(&bpp_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&bpp_sbus_driver);
 }
 
 static void __exit parport_sunbpp_exit(void)
 {
-	of_unregister_driver(&bpp_sbus_driver);
+	of_unregister_platform_driver(&bpp_sbus_driver);
 }
 
 MODULE_AUTHOR("Derrick J Brashear");
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 40d7a1f..3e89c31 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -425,12 +425,12 @@ static struct of_platform_driver bbc_i2c_driver = {
 
 static int __init bbc_i2c_init(void)
 {
-	return of_register_driver(&bbc_i2c_driver, &of_bus_type);
+	return of_register_platform_driver(&bbc_i2c_driver);
 }
 
 static void __exit bbc_i2c_exit(void)
 {
-	of_unregister_driver(&bbc_i2c_driver);
+	of_unregister_platform_driver(&bbc_i2c_driver);
 }
 
 module_init(bbc_i2c_init);
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 7baf1b6..8fd362e 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -277,12 +277,12 @@ static struct of_platform_driver d7s_driver = {
 
 static int __init d7s_init(void)
 {
-	return of_register_driver(&d7s_driver, &of_bus_type);
+	return of_register_platform_driver(&d7s_driver);
 }
 
 static void __exit d7s_exit(void)
 {
-	of_unregister_driver(&d7s_driver);
+	of_unregister_platform_driver(&d7s_driver);
 }
 
 module_init(d7s_init);
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index c8166ec..2c76f70 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -1142,12 +1142,12 @@ static struct of_platform_driver envctrl_driver = {
 
 static int __init envctrl_init(void)
 {
-	return of_register_driver(&envctrl_driver, &of_bus_type);
+	return of_register_platform_driver(&envctrl_driver);
 }
 
 static void __exit envctrl_exit(void)
 {
-	of_unregister_driver(&envctrl_driver);
+	of_unregister_platform_driver(&envctrl_driver);
 }
 
 module_init(envctrl_init);
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 368d662..d79f386 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -218,12 +218,12 @@ static struct of_platform_driver flash_driver = {
 
 static int __init flash_init(void)
 {
-	return of_register_driver(&flash_driver, &of_bus_type);
+	return of_register_platform_driver(&flash_driver);
 }
 
 static void __exit flash_cleanup(void)
 {
-	of_unregister_driver(&flash_driver);
+	of_unregister_platform_driver(&flash_driver);
 }
 
 module_init(flash_init);
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index b8b40e9..57f0612 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -437,12 +437,12 @@ static struct of_platform_driver uctrl_driver = {
 
 static int __init uctrl_init(void)
 {
-	return of_register_driver(&uctrl_driver, &of_bus_type);
+	return of_register_platform_driver(&uctrl_driver);
 }
 
 static void __exit uctrl_exit(void)
 {
-	of_unregister_driver(&uctrl_driver);
+	of_unregister_platform_driver(&uctrl_driver);
 }
 
 module_init(uctrl_init);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 3f5b541..53d7ed0 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1467,12 +1467,12 @@ static struct of_platform_driver qpti_sbus_driver = {
 
 static int __init qpti_init(void)
 {
-	return of_register_driver(&qpti_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&qpti_sbus_driver);
 }
 
 static void __exit qpti_exit(void)
 {
-	of_unregister_driver(&qpti_sbus_driver);
+	of_unregister_platform_driver(&qpti_sbus_driver);
 }
 
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index ddc221a..89ba6fe 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -644,12 +644,12 @@ static struct of_platform_driver esp_sbus_driver = {
 
 static int __init sunesp_init(void)
 {
-	return of_register_driver(&esp_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&esp_sbus_driver);
 }
 
 static void __exit sunesp_exit(void)
 {
-	of_unregister_driver(&esp_sbus_driver);
+	of_unregister_platform_driver(&esp_sbus_driver);
 }
 
 MODULE_DESCRIPTION("Sun ESP SCSI driver");
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index 36e2448..a779e22 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -644,12 +644,12 @@ static int __init sunhv_init(void)
 	if (tlb_type != hypervisor)
 		return -ENODEV;
 
-	return of_register_driver(&hv_driver, &of_bus_type);
+	return of_register_platform_driver(&hv_driver);
 }
 
 static void __exit sunhv_exit(void)
 {
-	of_unregister_driver(&hv_driver);
+	of_unregister_platform_driver(&hv_driver);
 }
 
 module_init(sunhv_init);
diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index 0a7dd68..9845fb1 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -1130,12 +1130,12 @@ static int __init sunsab_init(void)
 		}
 	}
 
-	return of_register_driver(&sab_driver, &of_bus_type);
+	return of_register_platform_driver(&sab_driver);
 }
 
 static void __exit sunsab_exit(void)
 {
-	of_unregister_driver(&sab_driver);
+	of_unregister_platform_driver(&sab_driver);
 	if (sunsab_reg.nr) {
 		sunserial_unregister_minors(&sunsab_reg, sunsab_reg.nr);
 	}
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index 56d891a..c2bcd15 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1581,7 +1581,7 @@ static int __init sunsu_init(void)
 			return err;
 	}
 
-	err = of_register_driver(&su_driver, &of_bus_type);
+	err = of_register_platform_driver(&su_driver);
 	if (err && num_uart)
 		sunserial_unregister_minors(&sunsu_reg, num_uart);
 
diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index fcbe20d..d1e6bcb 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1576,7 +1576,7 @@ static int __init sunzilog_init(void)
 			goto out_free_tables;
 	}
 
-	err = of_register_driver(&zs_driver, &of_bus_type);
+	err = of_register_platform_driver(&zs_driver);
 	if (err)
 		goto out_unregister_uart;
 
@@ -1604,7 +1604,7 @@ out:
 	return err;
 
 out_unregister_driver:
-	of_unregister_driver(&zs_driver);
+	of_unregister_platform_driver(&zs_driver);
 
 out_unregister_uart:
 	if (num_sunzilog) {
@@ -1619,7 +1619,7 @@ out_free_tables:
 
 static void __exit sunzilog_exit(void)
 {
-	of_unregister_driver(&zs_driver);
+	of_unregister_platform_driver(&zs_driver);
 
 	if (zilog_irq != -1) {
 		struct uart_sunzilog_port *up = sunzilog_irq_chain;
diff --git a/drivers/video/bw2.c b/drivers/video/bw2.c
index 09f1b9b..c779663 100644
--- a/drivers/video/bw2.c
+++ b/drivers/video/bw2.c
@@ -390,12 +390,12 @@ static int __init bw2_init(void)
 	if (fb_get_options("bw2fb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&bw2_driver, &of_bus_type);
+	return of_register_platform_driver(&bw2_driver);
 }
 
 static void __exit bw2_exit(void)
 {
-	of_unregister_driver(&bw2_driver);
+	of_unregister_platform_driver(&bw2_driver);
 }
 
 module_init(bw2_init);
diff --git a/drivers/video/cg14.c b/drivers/video/cg14.c
index e5dc224..d09fde8 100644
--- a/drivers/video/cg14.c
+++ b/drivers/video/cg14.c
@@ -610,12 +610,12 @@ static int __init cg14_init(void)
 	if (fb_get_options("cg14fb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&cg14_driver, &of_bus_type);
+	return of_register_platform_driver(&cg14_driver);
 }
 
 static void __exit cg14_exit(void)
 {
-	of_unregister_driver(&cg14_driver);
+	of_unregister_platform_driver(&cg14_driver);
 }
 
 module_init(cg14_init);
diff --git a/drivers/video/cg3.c b/drivers/video/cg3.c
index 558d73a..64aa298 100644
--- a/drivers/video/cg3.c
+++ b/drivers/video/cg3.c
@@ -477,12 +477,12 @@ static int __init cg3_init(void)
 	if (fb_get_options("cg3fb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&cg3_driver, &of_bus_type);
+	return of_register_platform_driver(&cg3_driver);
 }
 
 static void __exit cg3_exit(void)
 {
-	of_unregister_driver(&cg3_driver);
+	of_unregister_platform_driver(&cg3_driver);
 }
 
 module_init(cg3_init);
diff --git a/drivers/video/cg6.c b/drivers/video/cg6.c
index 480d761..2389a71 100644
--- a/drivers/video/cg6.c
+++ b/drivers/video/cg6.c
@@ -870,12 +870,12 @@ static int __init cg6_init(void)
 	if (fb_get_options("cg6fb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&cg6_driver, &of_bus_type);
+	return of_register_platform_driver(&cg6_driver);
 }
 
 static void __exit cg6_exit(void)
 {
-	of_unregister_driver(&cg6_driver);
+	of_unregister_platform_driver(&cg6_driver);
 }
 
 module_init(cg6_init);
diff --git a/drivers/video/ffb.c b/drivers/video/ffb.c
index 95c0227..f6ecfab 100644
--- a/drivers/video/ffb.c
+++ b/drivers/video/ffb.c
@@ -1067,12 +1067,12 @@ static int __init ffb_init(void)
 	if (fb_get_options("ffb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&ffb_driver, &of_bus_type);
+	return of_register_platform_driver(&ffb_driver);
 }
 
 static void __exit ffb_exit(void)
 {
-	of_unregister_driver(&ffb_driver);
+	of_unregister_platform_driver(&ffb_driver);
 }
 
 module_init(ffb_init);
diff --git a/drivers/video/leo.c b/drivers/video/leo.c
index 9e8bf7d..ad67763 100644
--- a/drivers/video/leo.c
+++ b/drivers/video/leo.c
@@ -677,12 +677,12 @@ static int __init leo_init(void)
 	if (fb_get_options("leofb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&leo_driver, &of_bus_type);
+	return of_register_platform_driver(&leo_driver);
 }
 
 static void __exit leo_exit(void)
 {
-	of_unregister_driver(&leo_driver);
+	of_unregister_platform_driver(&leo_driver);
 }
 
 module_init(leo_init);
diff --git a/drivers/video/p9100.c b/drivers/video/p9100.c
index 6552751..688b055 100644
--- a/drivers/video/p9100.c
+++ b/drivers/video/p9100.c
@@ -367,12 +367,12 @@ static int __init p9100_init(void)
 	if (fb_get_options("p9100fb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&p9100_driver, &of_bus_type);
+	return of_register_platform_driver(&p9100_driver);
 }
 
 static void __exit p9100_exit(void)
 {
-	of_unregister_driver(&p9100_driver);
+	of_unregister_platform_driver(&p9100_driver);
 }
 
 module_init(p9100_init);
diff --git a/drivers/video/sunxvr1000.c b/drivers/video/sunxvr1000.c
index 489b44e..7288934 100644
--- a/drivers/video/sunxvr1000.c
+++ b/drivers/video/sunxvr1000.c
@@ -213,12 +213,12 @@ static int __init gfb_init(void)
 	if (fb_get_options("gfb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&gfb_driver, &of_bus_type);
+	return of_register_platform_driver(&gfb_driver);
 }
 
 static void __exit gfb_exit(void)
 {
-	of_unregister_driver(&gfb_driver);
+	of_unregister_platform_driver(&gfb_driver);
 }
 
 module_init(gfb_init);
diff --git a/drivers/video/tcx.c b/drivers/video/tcx.c
index cc039b3..f375e0d 100644
--- a/drivers/video/tcx.c
+++ b/drivers/video/tcx.c
@@ -526,12 +526,12 @@ static int __init tcx_init(void)
 	if (fb_get_options("tcxfb", NULL))
 		return -ENODEV;
 
-	return of_register_driver(&tcx_driver, &of_bus_type);
+	return of_register_platform_driver(&tcx_driver);
 }
 
 static void __exit tcx_exit(void)
 {
-	of_unregister_driver(&tcx_driver);
+	of_unregister_platform_driver(&tcx_driver);
 }
 
 module_init(tcx_init);
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 8c03fd7..30a2512 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -688,12 +688,12 @@ static struct of_platform_driver cpwd_driver = {
 
 static int __init cpwd_init(void)
 {
-	return of_register_driver(&cpwd_driver, &of_bus_type);
+	return of_register_platform_driver(&cpwd_driver);
 }
 
 static void __exit cpwd_exit(void)
 {
-	of_unregister_driver(&cpwd_driver);
+	of_unregister_platform_driver(&cpwd_driver);
 }
 
 module_init(cpwd_init);
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 5dceedd..4082b4a 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -250,12 +250,12 @@ static struct of_platform_driver riowd_driver = {
 
 static int __init riowd_init(void)
 {
-	return of_register_driver(&riowd_driver, &of_bus_type);
+	return of_register_platform_driver(&riowd_driver);
 }
 
 static void __exit riowd_exit(void)
 {
-	of_unregister_driver(&riowd_driver);
+	of_unregister_platform_driver(&riowd_driver);
 }
 
 module_init(riowd_init);
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 133ecf3..429513a 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -19,12 +19,6 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
-/*
- * of_platform_bus_type isn't it's own bus anymore.  It's now just an alias
- * for the platform bus.
- */
-#define of_platform_bus_type platform_bus_type
-
 extern const struct of_device_id of_default_bus_ids[];
 
 /*
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index 43c63d4..9eb1a4e 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -1075,7 +1075,7 @@ static struct of_platform_driver amd7930_sbus_driver = {
 
 static int __init amd7930_init(void)
 {
-	return of_register_driver(&amd7930_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&amd7930_sbus_driver);
 }
 
 static void __exit amd7930_exit(void)
@@ -1092,7 +1092,7 @@ static void __exit amd7930_exit(void)
 
 	amd7930_list = NULL;
 
-	of_unregister_driver(&amd7930_sbus_driver);
+	of_unregister_platform_driver(&amd7930_sbus_driver);
 }
 
 module_init(amd7930_init);
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index f7f05c2..68570ee 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -2120,12 +2120,12 @@ static struct of_platform_driver cs4231_driver = {
 
 static int __init cs4231_init(void)
 {
-	return of_register_driver(&cs4231_driver, &of_bus_type);
+	return of_register_platform_driver(&cs4231_driver);
 }
 
 static void __exit cs4231_exit(void)
 {
-	of_unregister_driver(&cs4231_driver);
+	of_unregister_platform_driver(&cs4231_driver);
 }
 
 module_init(cs4231_init);
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 491ce71..c421901 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2699,12 +2699,12 @@ static struct of_platform_driver dbri_sbus_driver = {
 /* Probe for the dbri chip and then attach the driver. */
 static int __init dbri_init(void)
 {
-	return of_register_driver(&dbri_sbus_driver, &of_bus_type);
+	return of_register_platform_driver(&dbri_sbus_driver);
 }
 
 static void __exit dbri_exit(void)
 {
-	of_unregister_driver(&dbri_sbus_driver);
+	of_unregister_platform_driver(&dbri_sbus_driver);
 }
 
 module_init(dbri_init);

