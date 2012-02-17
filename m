Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2BQRvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:51:15 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:1084 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab2BQRvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:51:01 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/18] ARM: at91: make matrix register base soc independent
Date: Fri, 17 Feb 2012 18:49:55 +0100
Message-Id: <4b71fdf7ee746a09b7ee468aa3bc60d6c34d4c20.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-at91/at91sam9260.c                   |    1 +
 arch/arm/mach-at91/at91sam9260_devices.c           |    9 +-
 arch/arm/mach-at91/at91sam9261.c                   |    1 +
 arch/arm/mach-at91/at91sam9261_devices.c           |    5 +-
 arch/arm/mach-at91/at91sam9263.c                   |    1 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    9 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    1 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |    5 +-
 arch/arm/mach-at91/at91sam9rl.c                    |    1 +
 arch/arm/mach-at91/at91sam9rl_devices.c            |    5 +-
 arch/arm/mach-at91/board-cpu9krea.c                |    5 +-
 arch/arm/mach-at91/generic.h                       |    3 +
 arch/arm/mach-at91/include/mach/at91_matrix.h      |   23 ++++++
 arch/arm/mach-at91/include/mach/at91rm9200.h       |    2 -
 arch/arm/mach-at91/include/mach/at91sam9260.h      |    2 +-
 .../mach-at91/include/mach/at91sam9260_matrix.h    |   36 ++++----
 arch/arm/mach-at91/include/mach/at91sam9261.h      |    2 +-
 .../mach-at91/include/mach/at91sam9261_matrix.h    |   18 ++--
 arch/arm/mach-at91/include/mach/at91sam9263.h      |    2 +-
 .../mach-at91/include/mach/at91sam9263_matrix.h    |   74 +++++++++---------
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |    2 +-
 .../mach-at91/include/mach/at91sam9g45_matrix.h    |   84 ++++++++++----------
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |    2 +-
 .../arm/mach-at91/include/mach/at91sam9rl_matrix.h |   42 +++++-----
 arch/arm/mach-at91/setup.c                         |    9 ++
 drivers/usb/gadget/at91_udc.c                      |    9 +-
 26 files changed, 199 insertions(+), 154 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91_matrix.h

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index e965332..5c15d14 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -327,6 +327,7 @@ static void __init at91sam9260_ioremap_registers(void)
 	at91_ioremap_rstc(AT91SAM9260_BASE_RSTC);
 	at91sam926x_ioremap_pit(AT91SAM9260_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
+	at91_ioremap_matrix(AT91SAM9260_BASE_MATRIX);
 }
 
 static void __init at91sam9260_initialize(void)
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 642ccb6..b93a337 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -21,6 +21,7 @@
 #include <mach/cpu.h>
 #include <mach/at91sam9260.h>
 #include <mach/at91sam9260_matrix.h>
+#include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
 
 #include "generic.h"
@@ -422,8 +423,8 @@ void __init at91_add_device_nand(struct atmel_nand_data *data)
 	if (!data)
 		return;
 
-	csa = at91_sys_read(AT91_MATRIX_EBICSA);
-	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
+	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
+	at91_matrix_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* enable pin */
 	if (gpio_is_valid(data->enable_pin))
@@ -1265,7 +1266,7 @@ void __init at91_add_device_cf(struct at91_cf_data *data)
 	if (!data)
 		return;
 
-	csa = at91_sys_read(AT91_MATRIX_EBICSA);
+	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
 
 	switch (data->chipselect) {
 	case 4:
@@ -1288,7 +1289,7 @@ void __init at91_add_device_cf(struct at91_cf_data *data)
 		return;
 	}
 
-	at91_sys_write(AT91_MATRIX_EBICSA, csa);
+	at91_matrix_write(AT91_MATRIX_EBICSA, csa);
 
 	if (gpio_is_valid(data->rst_pin)) {
 		at91_set_multi_drive(data->rst_pin, 0);
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index d7f51d6..50971e6 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -285,6 +285,7 @@ static void __init at91sam9261_ioremap_registers(void)
 	at91_ioremap_rstc(AT91SAM9261_BASE_RSTC);
 	at91sam926x_ioremap_pit(AT91SAM9261_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
+	at91_ioremap_matrix(AT91SAM9261_BASE_MATRIX);
 }
 
 static void __init at91sam9261_initialize(void)
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index fc59cbd..52c1f1a 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -24,6 +24,7 @@
 #include <mach/board.h>
 #include <mach/at91sam9261.h>
 #include <mach/at91sam9261_matrix.h>
+#include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
 
 #include "generic.h"
@@ -236,8 +237,8 @@ void __init at91_add_device_nand(struct atmel_nand_data *data)
 	if (!data)
 		return;
 
-	csa = at91_sys_read(AT91_MATRIX_EBICSA);
-	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
+	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
+	at91_matrix_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* enable pin */
 	if (gpio_is_valid(data->enable_pin))
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 8bdba2a..5fd6fe8 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -306,6 +306,7 @@ static void __init at91sam9263_ioremap_registers(void)
 	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
 	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
+	at91_ioremap_matrix(AT91SAM9263_BASE_MATRIX);
 }
 
 static void __init at91sam9263_initialize(void)
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 49aa6a9..545826b 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -23,6 +23,7 @@
 #include <mach/board.h>
 #include <mach/at91sam9263.h>
 #include <mach/at91sam9263_matrix.h>
+#include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
 
 #include "generic.h"
@@ -409,7 +410,7 @@ void __init at91_add_device_cf(struct at91_cf_data *data)
 	 * we assume SMC timings are configured by board code,
 	 * except True IDE where timings are controlled by driver
 	 */
-	ebi0_csa = at91_sys_read(AT91_MATRIX_EBI0CSA);
+	ebi0_csa = at91_matrix_read(AT91_MATRIX_EBI0CSA);
 	switch (data->chipselect) {
 	case 4:
 		at91_set_A_periph(AT91_PIN_PD6, 0);  /* EBI0_NCS4/CFCS0 */
@@ -428,7 +429,7 @@ void __init at91_add_device_cf(struct at91_cf_data *data)
 		       data->chipselect);
 		return;
 	}
-	at91_sys_write(AT91_MATRIX_EBI0CSA, ebi0_csa);
+	at91_matrix_write(AT91_MATRIX_EBI0CSA, ebi0_csa);
 
 	if (gpio_is_valid(data->det_pin)) {
 		at91_set_gpio_input(data->det_pin, 1);
@@ -496,8 +497,8 @@ void __init at91_add_device_nand(struct atmel_nand_data *data)
 	if (!data)
 		return;
 
-	csa = at91_sys_read(AT91_MATRIX_EBI0CSA);
-	at91_sys_write(AT91_MATRIX_EBI0CSA, csa | AT91_MATRIX_EBI0_CS3A_SMC_SMARTMEDIA);
+	csa = at91_matrix_read(AT91_MATRIX_EBI0CSA);
+	at91_matrix_write(AT91_MATRIX_EBI0CSA, csa | AT91_MATRIX_EBI0_CS3A_SMC_SMARTMEDIA);
 
 	/* enable pin */
 	if (gpio_is_valid(data->enable_pin))
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 5d2ff90..3726160 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -333,6 +333,7 @@ static void __init at91sam9g45_ioremap_registers(void)
 	at91_ioremap_rstc(AT91SAM9G45_BASE_RSTC);
 	at91sam926x_ioremap_pit(AT91SAM9G45_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9G45_BASE_SMC);
+	at91_ioremap_matrix(AT91SAM9G45_BASE_MATRIX);
 }
 
 static void __init at91sam9g45_initialize(void)
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index bd4e68c..8c036ff 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -25,6 +25,7 @@
 #include <mach/board.h>
 #include <mach/at91sam9g45.h>
 #include <mach/at91sam9g45_matrix.h>
+#include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/at_hdmac.h>
 #include <mach/atmel-mci.h>
@@ -557,8 +558,8 @@ void __init at91_add_device_nand(struct atmel_nand_data *data)
 	if (!data)
 		return;
 
-	csa = at91_sys_read(AT91_MATRIX_EBICSA);
-	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_EBI_CS3A_SMC_SMARTMEDIA);
+	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
+	at91_matrix_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_EBI_CS3A_SMC_SMARTMEDIA);
 
 	/* enable pin */
 	if (gpio_is_valid(data->enable_pin))
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index e86c50b..d95ff97 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -290,6 +290,7 @@ static void __init at91sam9rl_ioremap_registers(void)
 	at91_ioremap_rstc(AT91SAM9RL_BASE_RSTC);
 	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
+	at91_ioremap_matrix(AT91SAM9RL_BASE_MATRIX);
 }
 
 static void __init at91sam9rl_initialize(void)
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 9be71c1..936cf20 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -20,6 +20,7 @@
 #include <mach/board.h>
 #include <mach/at91sam9rl.h>
 #include <mach/at91sam9rl_matrix.h>
+#include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/at_hdmac.h>
 
@@ -265,8 +266,8 @@ void __init at91_add_device_nand(struct atmel_nand_data *data)
 	if (!data)
 		return;
 
-	csa = at91_sys_read(AT91_MATRIX_EBICSA);
-	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
+	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
+	at91_matrix_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* enable pin */
 	if (gpio_is_valid(data->enable_pin))
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 9ab3d1e..989e1c5 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -43,6 +43,7 @@
 #include <mach/board.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/at91sam9260_matrix.h>
+#include <mach/at91_matrix.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
@@ -238,8 +239,8 @@ static __init void cpu9krea_add_device_nor(void)
 {
 	unsigned long csa;
 
-	csa = at91_sys_read(AT91_MATRIX_EBICSA);
-	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_VDDIOMSEL_3_3V);
+	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
+	at91_matrix_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_VDDIOMSEL_3_3V);
 
 	/* configure chip-select 0 (NOR) */
 	sam9_smc_configure(0, 0, &cpu9krea_nor_smc_config);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 4e322f34..dc74ec0 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -67,6 +67,9 @@ extern void at91sam9g45_restart(char, const char *);
 /* shutdown */
 extern void at91_ioremap_shdwc(u32 base_addr);
 
+/* Matrix */
+extern void at91_ioremap_matrix(u32 base_addr);
+
  /* GPIO */
 #define AT91RM9200_PQFP		3	/* AT91RM9200 PQFP package has 3 banks */
 #define AT91RM9200_BGA		4	/* AT91RM9200 BGA package has 4 banks */
diff --git a/arch/arm/mach-at91/include/mach/at91_matrix.h b/arch/arm/mach-at91/include/mach/at91_matrix.h
new file mode 100644
index 0000000..02fae9d
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91_matrix.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+ *
+ * Under GPLv2
+ */
+
+#ifndef __MACH_AT91_MATRIX_H__
+#define __MACH_AT91_MATRIX_H__
+
+#ifndef __ASSEMBLY__
+extern void __iomem *at91_matrix_base;
+
+#define at91_matrix_read(field) \
+	__raw_readl(at91_matrix_base + field)
+
+#define at91_matrix_write(field, value) \
+	__raw_writel(value, at91_matrix_base + field);
+
+#else
+.extern at91_matrix_base
+#endif
+
+#endif /* __MACH_AT91_MATRIX_H__ */
diff --git a/arch/arm/mach-at91/include/mach/at91rm9200.h b/arch/arm/mach-at91/include/mach/at91rm9200.h
index bacb511..fbde306 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200.h
@@ -95,8 +95,6 @@
 #define AT91_USART2	AT91RM9200_BASE_US2
 #define AT91_USART3	AT91RM9200_BASE_US3
 
-#define AT91_MATRIX	0	/* not supported */
-
 /*
  * Internal Memory.
  */
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
index fa5ca27..2bde649 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9260.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
@@ -81,12 +81,12 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
-#define AT91_MATRIX	(0xffffee00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
 
 #define AT91SAM9260_BASE_ECC	0xffffe800
 #define AT91SAM9260_BASE_SMC	0xffffec00
+#define AT91SAM9260_BASE_MATRIX	0xffffee00
 #define AT91SAM9260_BASE_DBGU	AT91_BASE_DBGU0
 #define AT91SAM9260_BASE_PIOA	0xfffff400
 #define AT91SAM9260_BASE_PIOB	0xfffff600
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260_matrix.h b/arch/arm/mach-at91/include/mach/at91sam9260_matrix.h
index 020f02e..f459df4 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9260_matrix.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9260_matrix.h
@@ -15,12 +15,12 @@
 #ifndef AT91SAM9260_MATRIX_H
 #define AT91SAM9260_MATRIX_H
 
-#define AT91_MATRIX_MCFG0	(AT91_MATRIX + 0x00)	/* Master Configuration Register 0 */
-#define AT91_MATRIX_MCFG1	(AT91_MATRIX + 0x04)	/* Master Configuration Register 1 */
-#define AT91_MATRIX_MCFG2	(AT91_MATRIX + 0x08)	/* Master Configuration Register 2 */
-#define AT91_MATRIX_MCFG3	(AT91_MATRIX + 0x0C)	/* Master Configuration Register 3 */
-#define AT91_MATRIX_MCFG4	(AT91_MATRIX + 0x10)	/* Master Configuration Register 4 */
-#define AT91_MATRIX_MCFG5	(AT91_MATRIX + 0x14)	/* Master Configuration Register 5 */
+#define AT91_MATRIX_MCFG0	0x00			/* Master Configuration Register 0 */
+#define AT91_MATRIX_MCFG1	0x04			/* Master Configuration Register 1 */
+#define AT91_MATRIX_MCFG2	0x08			/* Master Configuration Register 2 */
+#define AT91_MATRIX_MCFG3	0x0C			/* Master Configuration Register 3 */
+#define AT91_MATRIX_MCFG4	0x10			/* Master Configuration Register 4 */
+#define AT91_MATRIX_MCFG5	0x14			/* Master Configuration Register 5 */
 #define		AT91_MATRIX_ULBT		(7 << 0)	/* Undefined Length Burst Type */
 #define			AT91_MATRIX_ULBT_INFINITE	(0 << 0)
 #define			AT91_MATRIX_ULBT_SINGLE		(1 << 0)
@@ -28,11 +28,11 @@
 #define			AT91_MATRIX_ULBT_EIGHT		(3 << 0)
 #define			AT91_MATRIX_ULBT_SIXTEEN	(4 << 0)
 
-#define AT91_MATRIX_SCFG0	(AT91_MATRIX + 0x40)	/* Slave Configuration Register 0 */
-#define AT91_MATRIX_SCFG1	(AT91_MATRIX + 0x44)	/* Slave Configuration Register 1 */
-#define AT91_MATRIX_SCFG2	(AT91_MATRIX + 0x48)	/* Slave Configuration Register 2 */
-#define AT91_MATRIX_SCFG3	(AT91_MATRIX + 0x4C)	/* Slave Configuration Register 3 */
-#define AT91_MATRIX_SCFG4	(AT91_MATRIX + 0x50)	/* Slave Configuration Register 4 */
+#define AT91_MATRIX_SCFG0	0x40			/* Slave Configuration Register 0 */
+#define AT91_MATRIX_SCFG1	0x44			/* Slave Configuration Register 1 */
+#define AT91_MATRIX_SCFG2	0x48			/* Slave Configuration Register 2 */
+#define AT91_MATRIX_SCFG3	0x4C			/* Slave Configuration Register 3 */
+#define AT91_MATRIX_SCFG4	0x50			/* Slave Configuration Register 4 */
 #define		AT91_MATRIX_SLOT_CYCLE		(0xff <<  0)	/* Maximum Number of Allowed Cycles for a Burst */
 #define		AT91_MATRIX_DEFMSTR_TYPE	(3    << 16)	/* Default Master Type */
 #define			AT91_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
@@ -43,11 +43,11 @@
 #define			AT91_MATRIX_ARBT_ROUND_ROBIN	(0 << 24)
 #define			AT91_MATRIX_ARBT_FIXED_PRIORITY	(1 << 24)
 
-#define AT91_MATRIX_PRAS0	(AT91_MATRIX + 0x80)	/* Priority Register A for Slave 0 */
-#define AT91_MATRIX_PRAS1	(AT91_MATRIX + 0x88)	/* Priority Register A for Slave 1 */
-#define AT91_MATRIX_PRAS2	(AT91_MATRIX + 0x90)	/* Priority Register A for Slave 2 */
-#define AT91_MATRIX_PRAS3	(AT91_MATRIX + 0x98)	/* Priority Register A for Slave 3 */
-#define AT91_MATRIX_PRAS4	(AT91_MATRIX + 0xA0)	/* Priority Register A for Slave 4 */
+#define AT91_MATRIX_PRAS0	0x80			/* Priority Register A for Slave 0 */
+#define AT91_MATRIX_PRAS1	0x88			/* Priority Register A for Slave 1 */
+#define AT91_MATRIX_PRAS2	0x90			/* Priority Register A for Slave 2 */
+#define AT91_MATRIX_PRAS3	0x98			/* Priority Register A for Slave 3 */
+#define AT91_MATRIX_PRAS4	0xA0			/* Priority Register A for Slave 4 */
 #define		AT91_MATRIX_M0PR		(3 << 0)	/* Master 0 Priority */
 #define		AT91_MATRIX_M1PR		(3 << 4)	/* Master 1 Priority */
 #define		AT91_MATRIX_M2PR		(3 << 8)	/* Master 2 Priority */
@@ -55,11 +55,11 @@
 #define		AT91_MATRIX_M4PR		(3 << 16)	/* Master 4 Priority */
 #define		AT91_MATRIX_M5PR		(3 << 20)	/* Master 5 Priority */
 
-#define AT91_MATRIX_MRCR	(AT91_MATRIX + 0x100)	/* Master Remap Control Register */
+#define AT91_MATRIX_MRCR	0x100			/* Master Remap Control Register */
 #define		AT91_MATRIX_RCB0		(1 << 0)	/* Remap Command for AHB Master 0 (ARM926EJ-S Instruction Master) */
 #define		AT91_MATRIX_RCB1		(1 << 1)	/* Remap Command for AHB Master 1 (ARM926EJ-S Data Master) */
 
-#define AT91_MATRIX_EBICSA	(AT91_MATRIX + 0x11C)	/* EBI Chip Select Assignment Register */
+#define AT91_MATRIX_EBICSA	0x11C			/* EBI Chip Select Assignment Register */
 #define		AT91_MATRIX_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
 #define			AT91_MATRIX_CS1A_SMC		(0 << 1)
 #define			AT91_MATRIX_CS1A_SDRAMC		(1 << 1)
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
index 7cde2d3..6dcff27 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
@@ -66,11 +66,11 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
-#define AT91_MATRIX	(0xffffee00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
 
 #define AT91SAM9261_BASE_SMC	0xffffec00
+#define AT91SAM9261_BASE_MATRIX	0xffffee00
 #define AT91SAM9261_BASE_DBGU	AT91_BASE_DBGU0
 #define AT91SAM9261_BASE_PIOA	0xfffff400
 #define AT91SAM9261_BASE_PIOB	0xfffff600
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261_matrix.h b/arch/arm/mach-at91/include/mach/at91sam9261_matrix.h
index 69c6501..a50cdf8 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261_matrix.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261_matrix.h
@@ -15,15 +15,15 @@
 #ifndef AT91SAM9261_MATRIX_H
 #define AT91SAM9261_MATRIX_H
 
-#define AT91_MATRIX_MCFG	(AT91_MATRIX + 0x00)	/* Master Configuration Register */
+#define AT91_MATRIX_MCFG	0x00			/* Master Configuration Register */
 #define		AT91_MATRIX_RCB0	(1 << 0)		/* Remap Command for AHB Master 0 (ARM926EJ-S Instruction Master) */
 #define		AT91_MATRIX_RCB1	(1 << 1)		/* Remap Command for AHB Master 1 (ARM926EJ-S Data Master) */
 
-#define AT91_MATRIX_SCFG0	(AT91_MATRIX + 0x04)	/* Slave Configuration Register 0 */
-#define AT91_MATRIX_SCFG1	(AT91_MATRIX + 0x08)	/* Slave Configuration Register 1 */
-#define AT91_MATRIX_SCFG2	(AT91_MATRIX + 0x0C)	/* Slave Configuration Register 2 */
-#define AT91_MATRIX_SCFG3	(AT91_MATRIX + 0x10)	/* Slave Configuration Register 3 */
-#define AT91_MATRIX_SCFG4	(AT91_MATRIX + 0x14)	/* Slave Configuration Register 4 */
+#define AT91_MATRIX_SCFG0	0x04			/* Slave Configuration Register 0 */
+#define AT91_MATRIX_SCFG1	0x08			/* Slave Configuration Register 1 */
+#define AT91_MATRIX_SCFG2	0x0C			/* Slave Configuration Register 2 */
+#define AT91_MATRIX_SCFG3	0x10			/* Slave Configuration Register 3 */
+#define AT91_MATRIX_SCFG4	0x14			/* Slave Configuration Register 4 */
 #define		AT91_MATRIX_SLOT_CYCLE		(0xff << 0)	/* Maximum Number of Allowed Cycles for a Burst */
 #define		AT91_MATRIX_DEFMSTR_TYPE	(3    << 16)	/* Default Master Type */
 #define			AT91_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
@@ -31,7 +31,7 @@
 #define			AT91_MATRIX_DEFMSTR_TYPE_FIXED	(2 << 16)
 #define		AT91_MATRIX_FIXED_DEFMSTR	(7    << 18)	/* Fixed Index of Default Master */
 
-#define AT91_MATRIX_TCR		(AT91_MATRIX + 0x24)	/* TCM Configuration Register */
+#define AT91_MATRIX_TCR		0x24			/* TCM Configuration Register */
 #define		AT91_MATRIX_ITCM_SIZE		(0xf << 0)	/* Size of ITCM enabled memory block */
 #define			AT91_MATRIX_ITCM_0		(0 << 0)
 #define			AT91_MATRIX_ITCM_16		(5 << 0)
@@ -43,7 +43,7 @@
 #define			AT91_MATRIX_DTCM_32		(6 << 4)
 #define			AT91_MATRIX_DTCM_64		(7 << 4)
 
-#define AT91_MATRIX_EBICSA	(AT91_MATRIX + 0x30)	/* EBI Chip Select Assignment Register */
+#define AT91_MATRIX_EBICSA	0x30			/* EBI Chip Select Assignment Register */
 #define		AT91_MATRIX_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
 #define			AT91_MATRIX_CS1A_SMC		(0 << 1)
 #define			AT91_MATRIX_CS1A_SDRAMC		(1 << 1)
@@ -58,7 +58,7 @@
 #define			AT91_MATRIX_CS5A_SMC_CF2	(1 << 5)
 #define		AT91_MATRIX_DBPUC		(1 << 8)	/* Data Bus Pull-up Configuration */
 
-#define AT91_MATRIX_USBPUCR	(AT91_MATRIX + 0x34)	/* USB Pad Pull-Up Control Register */
+#define AT91_MATRIX_USBPUCR	0x34			/* USB Pad Pull-Up Control Register */
 #define		AT91_MATRIX_USBPUCR_PUON	(1 << 30)	/* USB Device PAD Pull-up Enable */
 
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9263.h b/arch/arm/mach-at91/include/mach/at91sam9263.h
index 5949abd..fe73bfa 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9263.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9263.h
@@ -76,7 +76,6 @@
  */
 #define AT91_SDRAMC0	(0xffffe200 - AT91_BASE_SYS)
 #define AT91_SDRAMC1	(0xffffe800 - AT91_BASE_SYS)
-#define AT91_MATRIX	(0xffffec00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
 
@@ -84,6 +83,7 @@
 #define AT91SAM9263_BASE_SMC0	0xffffe400
 #define AT91SAM9263_BASE_ECC1	0xffffe600
 #define AT91SAM9263_BASE_SMC1	0xffffea00
+#define AT91SAM9263_BASE_MATRIX	0xffffec00
 #define AT91SAM9263_BASE_DBGU	AT91_BASE_DBGU1
 #define AT91SAM9263_BASE_PIOA	0xfffff200
 #define AT91SAM9263_BASE_PIOB	0xfffff400
diff --git a/arch/arm/mach-at91/include/mach/at91sam9263_matrix.h b/arch/arm/mach-at91/include/mach/at91sam9263_matrix.h
index 9b3efd3..ebb5fdb 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9263_matrix.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9263_matrix.h
@@ -15,15 +15,15 @@
 #ifndef AT91SAM9263_MATRIX_H
 #define AT91SAM9263_MATRIX_H
 
-#define AT91_MATRIX_MCFG0	(AT91_MATRIX + 0x00)	/* Master Configuration Register 0 */
-#define AT91_MATRIX_MCFG1	(AT91_MATRIX + 0x04)	/* Master Configuration Register 1 */
-#define AT91_MATRIX_MCFG2	(AT91_MATRIX + 0x08)	/* Master Configuration Register 2 */
-#define AT91_MATRIX_MCFG3	(AT91_MATRIX + 0x0C)	/* Master Configuration Register 3 */
-#define AT91_MATRIX_MCFG4	(AT91_MATRIX + 0x10)	/* Master Configuration Register 4 */
-#define AT91_MATRIX_MCFG5	(AT91_MATRIX + 0x14)	/* Master Configuration Register 5 */
-#define AT91_MATRIX_MCFG6	(AT91_MATRIX + 0x18)	/* Master Configuration Register 6 */
-#define AT91_MATRIX_MCFG7	(AT91_MATRIX + 0x1C)	/* Master Configuration Register 7 */
-#define AT91_MATRIX_MCFG8	(AT91_MATRIX + 0x20)	/* Master Configuration Register 8 */
+#define AT91_MATRIX_MCFG0	0x00			/* Master Configuration Register 0 */
+#define AT91_MATRIX_MCFG1	0x04			/* Master Configuration Register 1 */
+#define AT91_MATRIX_MCFG2	0x08			/* Master Configuration Register 2 */
+#define AT91_MATRIX_MCFG3	0x0C			/* Master Configuration Register 3 */
+#define AT91_MATRIX_MCFG4	0x10			/* Master Configuration Register 4 */
+#define AT91_MATRIX_MCFG5	0x14			/* Master Configuration Register 5 */
+#define AT91_MATRIX_MCFG6	0x18			/* Master Configuration Register 6 */
+#define AT91_MATRIX_MCFG7	0x1C			/* Master Configuration Register 7 */
+#define AT91_MATRIX_MCFG8	0x20			/* Master Configuration Register 8 */
 #define		AT91_MATRIX_ULBT	(7 << 0)	/* Undefined Length Burst Type */
 #define			AT91_MATRIX_ULBT_INFINITE	(0 << 0)
 #define			AT91_MATRIX_ULBT_SINGLE		(1 << 0)
@@ -31,14 +31,14 @@
 #define			AT91_MATRIX_ULBT_EIGHT		(3 << 0)
 #define			AT91_MATRIX_ULBT_SIXTEEN	(4 << 0)
 
-#define AT91_MATRIX_SCFG0	(AT91_MATRIX + 0x40)	/* Slave Configuration Register 0 */
-#define AT91_MATRIX_SCFG1	(AT91_MATRIX + 0x44)	/* Slave Configuration Register 1 */
-#define AT91_MATRIX_SCFG2	(AT91_MATRIX + 0x48)	/* Slave Configuration Register 2 */
-#define AT91_MATRIX_SCFG3	(AT91_MATRIX + 0x4C)	/* Slave Configuration Register 3 */
-#define AT91_MATRIX_SCFG4	(AT91_MATRIX + 0x50)	/* Slave Configuration Register 4 */
-#define AT91_MATRIX_SCFG5	(AT91_MATRIX + 0x54)	/* Slave Configuration Register 5 */
-#define AT91_MATRIX_SCFG6	(AT91_MATRIX + 0x58)	/* Slave Configuration Register 6 */
-#define AT91_MATRIX_SCFG7	(AT91_MATRIX + 0x5C)	/* Slave Configuration Register 7 */
+#define AT91_MATRIX_SCFG0	0x40			/* Slave Configuration Register 0 */
+#define AT91_MATRIX_SCFG1	0x44			/* Slave Configuration Register 1 */
+#define AT91_MATRIX_SCFG2	0x48			/* Slave Configuration Register 2 */
+#define AT91_MATRIX_SCFG3	0x4C			/* Slave Configuration Register 3 */
+#define AT91_MATRIX_SCFG4	0x50			/* Slave Configuration Register 4 */
+#define AT91_MATRIX_SCFG5	0x54			/* Slave Configuration Register 5 */
+#define AT91_MATRIX_SCFG6	0x58			/* Slave Configuration Register 6 */
+#define AT91_MATRIX_SCFG7	0x5C			/* Slave Configuration Register 7 */
 #define		AT91_MATRIX_SLOT_CYCLE		(0xff << 0)	/* Maximum Number of Allowed Cycles for a Burst */
 #define		AT91_MATRIX_DEFMSTR_TYPE	(3    << 16)	/* Default Master Type */
 #define			AT91_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
@@ -49,22 +49,22 @@
 #define			AT91_MATRIX_ARBT_ROUND_ROBIN	(0 << 24)
 #define			AT91_MATRIX_ARBT_FIXED_PRIORITY	(1 << 24)
 
-#define AT91_MATRIX_PRAS0	(AT91_MATRIX + 0x80)	/* Priority Register A for Slave 0 */
-#define AT91_MATRIX_PRBS0	(AT91_MATRIX + 0x84)	/* Priority Register B for Slave 0 */
-#define AT91_MATRIX_PRAS1	(AT91_MATRIX + 0x88)	/* Priority Register A for Slave 1 */
-#define AT91_MATRIX_PRBS1	(AT91_MATRIX + 0x8C)	/* Priority Register B for Slave 1 */
-#define AT91_MATRIX_PRAS2	(AT91_MATRIX + 0x90)	/* Priority Register A for Slave 2 */
-#define AT91_MATRIX_PRBS2	(AT91_MATRIX + 0x94)	/* Priority Register B for Slave 2 */
-#define AT91_MATRIX_PRAS3	(AT91_MATRIX + 0x98)	/* Priority Register A for Slave 3 */
-#define AT91_MATRIX_PRBS3	(AT91_MATRIX + 0x9C)	/* Priority Register B for Slave 3 */
-#define AT91_MATRIX_PRAS4	(AT91_MATRIX + 0xA0)	/* Priority Register A for Slave 4 */
-#define AT91_MATRIX_PRBS4	(AT91_MATRIX + 0xA4)	/* Priority Register B for Slave 4 */
-#define AT91_MATRIX_PRAS5	(AT91_MATRIX + 0xA8)	/* Priority Register A for Slave 5 */
-#define AT91_MATRIX_PRBS5	(AT91_MATRIX + 0xAC)	/* Priority Register B for Slave 5 */
-#define AT91_MATRIX_PRAS6	(AT91_MATRIX + 0xB0)	/* Priority Register A for Slave 6 */
-#define AT91_MATRIX_PRBS6	(AT91_MATRIX + 0xB4)	/* Priority Register B for Slave 6 */
-#define AT91_MATRIX_PRAS7	(AT91_MATRIX + 0xB8)	/* Priority Register A for Slave 7 */
-#define AT91_MATRIX_PRBS7	(AT91_MATRIX + 0xBC)	/* Priority Register B for Slave 7 */
+#define AT91_MATRIX_PRAS0	0x80			/* Priority Register A for Slave 0 */
+#define AT91_MATRIX_PRBS0	0x84			/* Priority Register B for Slave 0 */
+#define AT91_MATRIX_PRAS1	0x88			/* Priority Register A for Slave 1 */
+#define AT91_MATRIX_PRBS1	0x8C			/* Priority Register B for Slave 1 */
+#define AT91_MATRIX_PRAS2	0x90			/* Priority Register A for Slave 2 */
+#define AT91_MATRIX_PRBS2	0x94			/* Priority Register B for Slave 2 */
+#define AT91_MATRIX_PRAS3	0x98			/* Priority Register A for Slave 3 */
+#define AT91_MATRIX_PRBS3	0x9C			/* Priority Register B for Slave 3 */
+#define AT91_MATRIX_PRAS4	0xA0			/* Priority Register A for Slave 4 */
+#define AT91_MATRIX_PRBS4	0xA4			/* Priority Register B for Slave 4 */
+#define AT91_MATRIX_PRAS5	0xA8			/* Priority Register A for Slave 5 */
+#define AT91_MATRIX_PRBS5	0xAC			/* Priority Register B for Slave 5 */
+#define AT91_MATRIX_PRAS6	0xB0			/* Priority Register A for Slave 6 */
+#define AT91_MATRIX_PRBS6	0xB4			/* Priority Register B for Slave 6 */
+#define AT91_MATRIX_PRAS7	0xB8			/* Priority Register A for Slave 7 */
+#define AT91_MATRIX_PRBS7	0xBC			/* Priority Register B for Slave 7 */
 #define		AT91_MATRIX_M0PR		(3 << 0)	/* Master 0 Priority */
 #define		AT91_MATRIX_M1PR		(3 << 4)	/* Master 1 Priority */
 #define		AT91_MATRIX_M2PR		(3 << 8)	/* Master 2 Priority */
@@ -75,7 +75,7 @@
 #define		AT91_MATRIX_M7PR		(3 << 28)	/* Master 7 Priority */
 #define		AT91_MATRIX_M8PR		(3 << 0)	/* Master 8 Priority (in Register B) */
 
-#define AT91_MATRIX_MRCR	(AT91_MATRIX + 0x100)	/* Master Remap Control Register */
+#define AT91_MATRIX_MRCR	0x100			/* Master Remap Control Register */
 #define		AT91_MATRIX_RCB0		(1 << 0)	/* Remap Command for AHB Master 0 (ARM926EJ-S Instruction Master) */
 #define		AT91_MATRIX_RCB1		(1 << 1)	/* Remap Command for AHB Master 1 (ARM926EJ-S Data Master) */
 #define		AT91_MATRIX_RCB2		(1 << 2)
@@ -86,7 +86,7 @@
 #define		AT91_MATRIX_RCB7		(1 << 7)
 #define		AT91_MATRIX_RCB8		(1 << 8)
 
-#define AT91_MATRIX_TCMR	(AT91_MATRIX + 0x114)	/* TCM Configuration Register */
+#define AT91_MATRIX_TCMR	0x114			/* TCM Configuration Register */
 #define		AT91_MATRIX_ITCM_SIZE		(0xf << 0)	/* Size of ITCM enabled memory block */
 #define			AT91_MATRIX_ITCM_0		(0 << 0)
 #define			AT91_MATRIX_ITCM_16		(5 << 0)
@@ -96,7 +96,7 @@
 #define			AT91_MATRIX_DTCM_16		(5 << 4)
 #define			AT91_MATRIX_DTCM_32		(6 << 4)
 
-#define AT91_MATRIX_EBI0CSA	(AT91_MATRIX + 0x120)	/* EBI0 Chip Select Assignment Register */
+#define AT91_MATRIX_EBI0CSA	0x120			/* EBI0 Chip Select Assignment Register */
 #define		AT91_MATRIX_EBI0_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
 #define			AT91_MATRIX_EBI0_CS1A_SMC		(0 << 1)
 #define			AT91_MATRIX_EBI0_CS1A_SDRAMC		(1 << 1)
@@ -114,7 +114,7 @@
 #define			AT91_MATRIX_EBI0_VDDIOMSEL_1_8V		(0 << 16)
 #define			AT91_MATRIX_EBI0_VDDIOMSEL_3_3V		(1 << 16)
 
-#define AT91_MATRIX_EBI1CSA	(AT91_MATRIX + 0x124)	/* EBI1 Chip Select Assignment Register */
+#define AT91_MATRIX_EBI1CSA	0x124			/* EBI1 Chip Select Assignment Register */
 #define		AT91_MATRIX_EBI1_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
 #define			AT91_MATRIX_EBI1_CS1A_SMC		(0 << 1)
 #define			AT91_MATRIX_EBI1_CS1A_SDRAMC		(1 << 1)
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
index dd9c95e..c8fe455 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -88,13 +88,13 @@
  */
 #define AT91_DDRSDRC1	(0xffffe400 - AT91_BASE_SYS)
 #define AT91_DDRSDRC0	(0xffffe600 - AT91_BASE_SYS)
-#define AT91_MATRIX	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
 
 #define AT91SAM9G45_BASE_ECC	0xffffe200
 #define AT91SAM9G45_BASE_DMA	0xffffec00
 #define AT91SAM9G45_BASE_SMC	0xffffe800
+#define AT91SAM9G45_BASE_MATRIX	0xffffea00
 #define AT91SAM9G45_BASE_DBGU	AT91_BASE_DBGU1
 #define AT91SAM9G45_BASE_PIOA	0xfffff200
 #define AT91SAM9G45_BASE_PIOB	0xfffff400
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45_matrix.h b/arch/arm/mach-at91/include/mach/at91sam9g45_matrix.h
index c972d60..b76e2ed 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45_matrix.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45_matrix.h
@@ -15,18 +15,18 @@
 #ifndef AT91SAM9G45_MATRIX_H
 #define AT91SAM9G45_MATRIX_H
 
-#define AT91_MATRIX_MCFG0	(AT91_MATRIX + 0x00)	/* Master Configuration Register 0 */
-#define AT91_MATRIX_MCFG1	(AT91_MATRIX + 0x04)	/* Master Configuration Register 1 */
-#define AT91_MATRIX_MCFG2	(AT91_MATRIX + 0x08)	/* Master Configuration Register 2 */
-#define AT91_MATRIX_MCFG3	(AT91_MATRIX + 0x0C)	/* Master Configuration Register 3 */
-#define AT91_MATRIX_MCFG4	(AT91_MATRIX + 0x10)	/* Master Configuration Register 4 */
-#define AT91_MATRIX_MCFG5	(AT91_MATRIX + 0x14)	/* Master Configuration Register 5 */
-#define AT91_MATRIX_MCFG6	(AT91_MATRIX + 0x18)	/* Master Configuration Register 6 */
-#define AT91_MATRIX_MCFG7	(AT91_MATRIX + 0x1C)	/* Master Configuration Register 7 */
-#define AT91_MATRIX_MCFG8	(AT91_MATRIX + 0x20)	/* Master Configuration Register 8 */
-#define AT91_MATRIX_MCFG9	(AT91_MATRIX + 0x24)	/* Master Configuration Register 9 */
-#define AT91_MATRIX_MCFG10	(AT91_MATRIX + 0x28)	/* Master Configuration Register 10 */
-#define AT91_MATRIX_MCFG11	(AT91_MATRIX + 0x2C)	/* Master Configuration Register 11 */
+#define AT91_MATRIX_MCFG0	0x00			/* Master Configuration Register 0 */
+#define AT91_MATRIX_MCFG1	0x04			/* Master Configuration Register 1 */
+#define AT91_MATRIX_MCFG2	0x08			/* Master Configuration Register 2 */
+#define AT91_MATRIX_MCFG3	0x0C			/* Master Configuration Register 3 */
+#define AT91_MATRIX_MCFG4	0x10			/* Master Configuration Register 4 */
+#define AT91_MATRIX_MCFG5	0x14			/* Master Configuration Register 5 */
+#define AT91_MATRIX_MCFG6	0x18			/* Master Configuration Register 6 */
+#define AT91_MATRIX_MCFG7	0x1C			/* Master Configuration Register 7 */
+#define AT91_MATRIX_MCFG8	0x20			/* Master Configuration Register 8 */
+#define AT91_MATRIX_MCFG9	0x24			/* Master Configuration Register 9 */
+#define AT91_MATRIX_MCFG10	0x28			/* Master Configuration Register 10 */
+#define AT91_MATRIX_MCFG11	0x2C			/* Master Configuration Register 11 */
 #define		AT91_MATRIX_ULBT	(7 << 0)	/* Undefined Length Burst Type */
 #define			AT91_MATRIX_ULBT_INFINITE	(0 << 0)
 #define			AT91_MATRIX_ULBT_SINGLE		(1 << 0)
@@ -37,14 +37,14 @@
 #define			AT91_MATRIX_ULBT_SIXTYFOUR	(6 << 0)
 #define			AT91_MATRIX_ULBT_128		(7 << 0)
 
-#define AT91_MATRIX_SCFG0	(AT91_MATRIX + 0x40)	/* Slave Configuration Register 0 */
-#define AT91_MATRIX_SCFG1	(AT91_MATRIX + 0x44)	/* Slave Configuration Register 1 */
-#define AT91_MATRIX_SCFG2	(AT91_MATRIX + 0x48)	/* Slave Configuration Register 2 */
-#define AT91_MATRIX_SCFG3	(AT91_MATRIX + 0x4C)	/* Slave Configuration Register 3 */
-#define AT91_MATRIX_SCFG4	(AT91_MATRIX + 0x50)	/* Slave Configuration Register 4 */
-#define AT91_MATRIX_SCFG5	(AT91_MATRIX + 0x54)	/* Slave Configuration Register 5 */
-#define AT91_MATRIX_SCFG6	(AT91_MATRIX + 0x58)	/* Slave Configuration Register 6 */
-#define AT91_MATRIX_SCFG7	(AT91_MATRIX + 0x5C)	/* Slave Configuration Register 7 */
+#define AT91_MATRIX_SCFG0	0x40			/* Slave Configuration Register 0 */
+#define AT91_MATRIX_SCFG1	0x44			/* Slave Configuration Register 1 */
+#define AT91_MATRIX_SCFG2	0x48			/* Slave Configuration Register 2 */
+#define AT91_MATRIX_SCFG3	0x4C			/* Slave Configuration Register 3 */
+#define AT91_MATRIX_SCFG4	0x50			/* Slave Configuration Register 4 */
+#define AT91_MATRIX_SCFG5	0x54			/* Slave Configuration Register 5 */
+#define AT91_MATRIX_SCFG6	0x58			/* Slave Configuration Register 6 */
+#define AT91_MATRIX_SCFG7	0x5C			/* Slave Configuration Register 7 */
 #define		AT91_MATRIX_SLOT_CYCLE		(0x1ff << 0)	/* Maximum Number of Allowed Cycles for a Burst */
 #define		AT91_MATRIX_DEFMSTR_TYPE	(3    << 16)	/* Default Master Type */
 #define			AT91_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
@@ -52,22 +52,22 @@
 #define			AT91_MATRIX_DEFMSTR_TYPE_FIXED	(2 << 16)
 #define		AT91_MATRIX_FIXED_DEFMSTR	(0xf  << 18)	/* Fixed Index of Default Master */
 
-#define AT91_MATRIX_PRAS0	(AT91_MATRIX + 0x80)	/* Priority Register A for Slave 0 */
-#define AT91_MATRIX_PRBS0	(AT91_MATRIX + 0x84)	/* Priority Register B for Slave 0 */
-#define AT91_MATRIX_PRAS1	(AT91_MATRIX + 0x88)	/* Priority Register A for Slave 1 */
-#define AT91_MATRIX_PRBS1	(AT91_MATRIX + 0x8C)	/* Priority Register B for Slave 1 */
-#define AT91_MATRIX_PRAS2	(AT91_MATRIX + 0x90)	/* Priority Register A for Slave 2 */
-#define AT91_MATRIX_PRBS2	(AT91_MATRIX + 0x94)	/* Priority Register B for Slave 2 */
-#define AT91_MATRIX_PRAS3	(AT91_MATRIX + 0x98)	/* Priority Register A for Slave 3 */
-#define AT91_MATRIX_PRBS3	(AT91_MATRIX + 0x9C)	/* Priority Register B for Slave 3 */
-#define AT91_MATRIX_PRAS4	(AT91_MATRIX + 0xA0)	/* Priority Register A for Slave 4 */
-#define AT91_MATRIX_PRBS4	(AT91_MATRIX + 0xA4)	/* Priority Register B for Slave 4 */
-#define AT91_MATRIX_PRAS5	(AT91_MATRIX + 0xA8)	/* Priority Register A for Slave 5 */
-#define AT91_MATRIX_PRBS5	(AT91_MATRIX + 0xAC)	/* Priority Register B for Slave 5 */
-#define AT91_MATRIX_PRAS6	(AT91_MATRIX + 0xB0)	/* Priority Register A for Slave 6 */
-#define AT91_MATRIX_PRBS6	(AT91_MATRIX + 0xB4)	/* Priority Register B for Slave 6 */
-#define AT91_MATRIX_PRAS7	(AT91_MATRIX + 0xB8)	/* Priority Register A for Slave 7 */
-#define AT91_MATRIX_PRBS7	(AT91_MATRIX + 0xBC)	/* Priority Register B for Slave 7 */
+#define AT91_MATRIX_PRAS0	0x80			/* Priority Register A for Slave 0 */
+#define AT91_MATRIX_PRBS0	0x84			/* Priority Register B for Slave 0 */
+#define AT91_MATRIX_PRAS1	0x88			/* Priority Register A for Slave 1 */
+#define AT91_MATRIX_PRBS1	0x8C			/* Priority Register B for Slave 1 */
+#define AT91_MATRIX_PRAS2	0x90			/* Priority Register A for Slave 2 */
+#define AT91_MATRIX_PRBS2	0x94			/* Priority Register B for Slave 2 */
+#define AT91_MATRIX_PRAS3	0x98			/* Priority Register A for Slave 3 */
+#define AT91_MATRIX_PRBS3	0x9C			/* Priority Register B for Slave 3 */
+#define AT91_MATRIX_PRAS4	0xA0			/* Priority Register A for Slave 4 */
+#define AT91_MATRIX_PRBS4	0xA4			/* Priority Register B for Slave 4 */
+#define AT91_MATRIX_PRAS5	0xA8			/* Priority Register A for Slave 5 */
+#define AT91_MATRIX_PRBS5	0xAC			/* Priority Register B for Slave 5 */
+#define AT91_MATRIX_PRAS6	0xB0			/* Priority Register A for Slave 6 */
+#define AT91_MATRIX_PRBS6	0xB4			/* Priority Register B for Slave 6 */
+#define AT91_MATRIX_PRAS7	0xB8			/* Priority Register A for Slave 7 */
+#define AT91_MATRIX_PRBS7	0xBC			/* Priority Register B for Slave 7 */
 #define		AT91_MATRIX_M0PR		(3 << 0)	/* Master 0 Priority */
 #define		AT91_MATRIX_M1PR		(3 << 4)	/* Master 1 Priority */
 #define		AT91_MATRIX_M2PR		(3 << 8)	/* Master 2 Priority */
@@ -81,7 +81,7 @@
 #define		AT91_MATRIX_M10PR		(3 << 8)	/* Master 10 Priority (in Register B) */
 #define		AT91_MATRIX_M11PR		(3 << 12)	/* Master 11 Priority (in Register B) */
 
-#define AT91_MATRIX_MRCR	(AT91_MATRIX + 0x100)	/* Master Remap Control Register */
+#define AT91_MATRIX_MRCR	0x100			/* Master Remap Control Register */
 #define		AT91_MATRIX_RCB0		(1 << 0)	/* Remap Command for AHB Master 0 (ARM926EJ-S Instruction Master) */
 #define		AT91_MATRIX_RCB1		(1 << 1)	/* Remap Command for AHB Master 1 (ARM926EJ-S Data Master) */
 #define		AT91_MATRIX_RCB2		(1 << 2)
@@ -95,7 +95,7 @@
 #define		AT91_MATRIX_RCB10		(1 << 10)
 #define		AT91_MATRIX_RCB11		(1 << 11)
 
-#define AT91_MATRIX_TCMR	(AT91_MATRIX + 0x110)	/* TCM Configuration Register */
+#define AT91_MATRIX_TCMR	0x110			/* TCM Configuration Register */
 #define		AT91_MATRIX_ITCM_SIZE		(0xf << 0)	/* Size of ITCM enabled memory block */
 #define			AT91_MATRIX_ITCM_0		(0 << 0)
 #define			AT91_MATRIX_ITCM_32		(6 << 0)
@@ -107,12 +107,12 @@
 #define			AT91_MATRIX_TCM_NO_WS		(0x0 << 11)
 #define			AT91_MATRIX_TCM_ONE_WS		(0x1 << 11)
 
-#define AT91_MATRIX_VIDEO	(AT91_MATRIX + 0x118)	/* Video Mode Configuration Register */
+#define AT91_MATRIX_VIDEO	0x118			/* Video Mode Configuration Register */
 #define		AT91C_VDEC_SEL			(0x1 <<  0) /* Video Mode Selection */
 #define			AT91C_VDEC_SEL_OFF		(0 << 0)
 #define			AT91C_VDEC_SEL_ON		(1 << 0)
 
-#define AT91_MATRIX_EBICSA	(AT91_MATRIX + 0x128)	/* EBI Chip Select Assignment Register */
+#define AT91_MATRIX_EBICSA	0x128			/* EBI Chip Select Assignment Register */
 #define		AT91_MATRIX_EBI_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
 #define			AT91_MATRIX_EBI_CS1A_SMC		(0 << 1)
 #define			AT91_MATRIX_EBI_CS1A_SDRAMC		(1 << 1)
@@ -138,13 +138,13 @@
 #define			AT91_MATRIX_EBI_DDR_IOSR_REDUCED	(0 << 18)
 #define			AT91_MATRIX_EBI_DDR_IOSR_NORMAL		(1 << 18)
 
-#define AT91_MATRIX_WPMR	(AT91_MATRIX + 0x1E4)	/* Write Protect Mode Register */
+#define AT91_MATRIX_WPMR	0x1E4			/* Write Protect Mode Register */
 #define		AT91_MATRIX_WPMR_WPEN		(1 << 0)	/* Write Protect ENable */
 #define			AT91_MATRIX_WPMR_WP_WPDIS		(0 << 0)
 #define			AT91_MATRIX_WPMR_WP_WPEN		(1 << 0)
 #define		AT91_MATRIX_WPMR_WPKEY		(0xFFFFFF << 8)	/* Write Protect KEY */
 
-#define AT91_MATRIX_WPSR	(AT91_MATRIX + 0x1E8)	/* Write Protect Status Register */
+#define AT91_MATRIX_WPSR	0x1E8			/* Write Protect Status Register */
 #define		AT91_MATRIX_WPSR_WPVS		(1 << 0)	/* Write Protect Violation Status */
 #define			AT91_MATRIX_WPSR_NO_WPV		(0 << 0)
 #define			AT91_MATRIX_WPSR_WPV		(1 << 0)
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
index d7bead7..51edc25 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9rl.h
@@ -70,7 +70,6 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
-#define AT91_MATRIX	(0xffffee00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_SCKCR	(0xfffffd50 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
@@ -78,6 +77,7 @@
 #define AT91SAM9RL_BASE_DMA	0xffffe600
 #define AT91SAM9RL_BASE_ECC	0xffffe800
 #define AT91SAM9RL_BASE_SMC	0xffffec00
+#define AT91SAM9RL_BASE_MATRIX	0xffffee00
 #define AT91SAM9RL_BASE_DBGU	AT91_BASE_DBGU0
 #define AT91SAM9RL_BASE_PIOA	0xfffff400
 #define AT91SAM9RL_BASE_PIOB	0xfffff600
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl_matrix.h b/arch/arm/mach-at91/include/mach/at91sam9rl_matrix.h
index 5f91490..6d160ad 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9rl_matrix.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9rl_matrix.h
@@ -14,12 +14,12 @@
 #ifndef AT91SAM9RL_MATRIX_H
 #define AT91SAM9RL_MATRIX_H
 
-#define AT91_MATRIX_MCFG0	(AT91_MATRIX + 0x00)	/* Master Configuration Register 0 */
-#define AT91_MATRIX_MCFG1	(AT91_MATRIX + 0x04)	/* Master Configuration Register 1 */
-#define AT91_MATRIX_MCFG2	(AT91_MATRIX + 0x08)	/* Master Configuration Register 2 */
-#define AT91_MATRIX_MCFG3	(AT91_MATRIX + 0x0C)	/* Master Configuration Register 3 */
-#define AT91_MATRIX_MCFG4	(AT91_MATRIX + 0x10)	/* Master Configuration Register 4 */
-#define AT91_MATRIX_MCFG5	(AT91_MATRIX + 0x14)	/* Master Configuration Register 5 */
+#define AT91_MATRIX_MCFG0	0x00			/* Master Configuration Register 0 */
+#define AT91_MATRIX_MCFG1	0x04			/* Master Configuration Register 1 */
+#define AT91_MATRIX_MCFG2	0x08			/* Master Configuration Register 2 */
+#define AT91_MATRIX_MCFG3	0x0C			/* Master Configuration Register 3 */
+#define AT91_MATRIX_MCFG4	0x10			/* Master Configuration Register 4 */
+#define AT91_MATRIX_MCFG5	0x14			/* Master Configuration Register 5 */
 #define		AT91_MATRIX_ULBT	(7 << 0)	/* Undefined Length Burst Type */
 #define			AT91_MATRIX_ULBT_INFINITE	(0 << 0)
 #define			AT91_MATRIX_ULBT_SINGLE		(1 << 0)
@@ -27,12 +27,12 @@
 #define			AT91_MATRIX_ULBT_EIGHT		(3 << 0)
 #define			AT91_MATRIX_ULBT_SIXTEEN	(4 << 0)
 
-#define AT91_MATRIX_SCFG0	(AT91_MATRIX + 0x40)	/* Slave Configuration Register 0 */
-#define AT91_MATRIX_SCFG1	(AT91_MATRIX + 0x44)	/* Slave Configuration Register 1 */
-#define AT91_MATRIX_SCFG2	(AT91_MATRIX + 0x48)	/* Slave Configuration Register 2 */
-#define AT91_MATRIX_SCFG3	(AT91_MATRIX + 0x4C)	/* Slave Configuration Register 3 */
-#define AT91_MATRIX_SCFG4	(AT91_MATRIX + 0x50)	/* Slave Configuration Register 4 */
-#define AT91_MATRIX_SCFG5	(AT91_MATRIX + 0x54)	/* Slave Configuration Register 5 */
+#define AT91_MATRIX_SCFG0	0x40			/* Slave Configuration Register 0 */
+#define AT91_MATRIX_SCFG1	0x44			/* Slave Configuration Register 1 */
+#define AT91_MATRIX_SCFG2	0x48			/* Slave Configuration Register 2 */
+#define AT91_MATRIX_SCFG3	0x4C			/* Slave Configuration Register 3 */
+#define AT91_MATRIX_SCFG4	0x50			/* Slave Configuration Register 4 */
+#define AT91_MATRIX_SCFG5	0x54			/* Slave Configuration Register 5 */
 #define		AT91_MATRIX_SLOT_CYCLE		(0xff << 0)	/* Maximum Number of Allowed Cycles for a Burst */
 #define		AT91_MATRIX_DEFMSTR_TYPE	(3    << 16)	/* Default Master Type */
 #define			AT91_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
@@ -43,12 +43,12 @@
 #define			AT91_MATRIX_ARBT_ROUND_ROBIN	(0 << 24)
 #define			AT91_MATRIX_ARBT_FIXED_PRIORITY	(1 << 24)
 
-#define AT91_MATRIX_PRAS0	(AT91_MATRIX + 0x80)	/* Priority Register A for Slave 0 */
-#define AT91_MATRIX_PRAS1	(AT91_MATRIX + 0x88)	/* Priority Register A for Slave 1 */
-#define AT91_MATRIX_PRAS2	(AT91_MATRIX + 0x90)	/* Priority Register A for Slave 2 */
-#define AT91_MATRIX_PRAS3	(AT91_MATRIX + 0x98)	/* Priority Register A for Slave 3 */
-#define AT91_MATRIX_PRAS4	(AT91_MATRIX + 0xA0)	/* Priority Register A for Slave 4 */
-#define AT91_MATRIX_PRAS5	(AT91_MATRIX + 0xA8)	/* Priority Register A for Slave 5 */
+#define AT91_MATRIX_PRAS0	0x80			/* Priority Register A for Slave 0 */
+#define AT91_MATRIX_PRAS1	0x88			/* Priority Register A for Slave 1 */
+#define AT91_MATRIX_PRAS2	0x90			/* Priority Register A for Slave 2 */
+#define AT91_MATRIX_PRAS3	0x98			/* Priority Register A for Slave 3 */
+#define AT91_MATRIX_PRAS4	0xA0			/* Priority Register A for Slave 4 */
+#define AT91_MATRIX_PRAS5	0xA8			/* Priority Register A for Slave 5 */
 #define		AT91_MATRIX_M0PR		(3 << 0)	/* Master 0 Priority */
 #define		AT91_MATRIX_M1PR		(3 << 4)	/* Master 1 Priority */
 #define		AT91_MATRIX_M2PR		(3 << 8)	/* Master 2 Priority */
@@ -56,7 +56,7 @@
 #define		AT91_MATRIX_M4PR		(3 << 16)	/* Master 4 Priority */
 #define		AT91_MATRIX_M5PR		(3 << 20)	/* Master 5 Priority */
 
-#define AT91_MATRIX_MRCR	(AT91_MATRIX + 0x100)	/* Master Remap Control Register */
+#define AT91_MATRIX_MRCR	0x100			/* Master Remap Control Register */
 #define		AT91_MATRIX_RCB0		(1 << 0)	/* Remap Command for AHB Master 0 (ARM926EJ-S Instruction Master) */
 #define		AT91_MATRIX_RCB1		(1 << 1)	/* Remap Command for AHB Master 1 (ARM926EJ-S Data Master) */
 #define		AT91_MATRIX_RCB2		(1 << 2)
@@ -64,7 +64,7 @@
 #define		AT91_MATRIX_RCB4		(1 << 4)
 #define		AT91_MATRIX_RCB5		(1 << 5)
 
-#define AT91_MATRIX_TCMR	(AT91_MATRIX + 0x114)	/* TCM Configuration Register */
+#define AT91_MATRIX_TCMR	0x114			/* TCM Configuration Register */
 #define		AT91_MATRIX_ITCM_SIZE		(0xf << 0)	/* Size of ITCM enabled memory block */
 #define			AT91_MATRIX_ITCM_0		(0 << 0)
 #define			AT91_MATRIX_ITCM_16		(5 << 0)
@@ -74,7 +74,7 @@
 #define			AT91_MATRIX_DTCM_16		(5 << 4)
 #define			AT91_MATRIX_DTCM_32		(6 << 4)
 
-#define AT91_MATRIX_EBICSA	(AT91_MATRIX + 0x120)	/* EBI0 Chip Select Assignment Register */
+#define AT91_MATRIX_EBICSA	0x120			/* EBI0 Chip Select Assignment Register */
 #define		AT91_MATRIX_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
 #define			AT91_MATRIX_CS1A_SMC		(0 << 1)
 #define			AT91_MATRIX_CS1A_SDRAMC		(1 << 1)
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 620c67e..372396c 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -276,6 +276,15 @@ void __init at91_ioremap_rstc(u32 base_addr)
 		panic("Impossible to ioremap at91_rstc_base\n");
 }
 
+void __iomem *at91_matrix_base;
+
+void __init at91_ioremap_matrix(u32 base_addr)
+{
+	at91_matrix_base = ioremap(base_addr, 512);
+	if (!at91_matrix_base)
+		panic("Impossible to ioremap at91_matrix_base\n");
+}
+
 void __init at91_initialize(unsigned long main_clock)
 {
 	at91_boot_soc.ioremap_registers();
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 143a725..f99b3dc 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -41,6 +41,7 @@
 #include <mach/board.h>
 #include <mach/cpu.h>
 #include <mach/at91sam9261_matrix.h>
+#include <mach/at91_matrix.h>
 
 #include "at91_udc.h"
 
@@ -910,9 +911,9 @@ static void pullup(struct at91_udc *udc, int is_on)
 		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
 			u32	usbpucr;
 
-			usbpucr = at91_sys_read(AT91_MATRIX_USBPUCR);
+			usbpucr = at91_matrix_read(AT91_MATRIX_USBPUCR);
 			usbpucr |= AT91_MATRIX_USBPUCR_PUON;
-			at91_sys_write(AT91_MATRIX_USBPUCR, usbpucr);
+			at91_matrix_write(AT91_MATRIX_USBPUCR, usbpucr);
 		}
 	} else {
 		stop_activity(udc);
@@ -928,9 +929,9 @@ static void pullup(struct at91_udc *udc, int is_on)
 		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
 			u32	usbpucr;
 
-			usbpucr = at91_sys_read(AT91_MATRIX_USBPUCR);
+			usbpucr = at91_matrix_read(AT91_MATRIX_USBPUCR);
 			usbpucr &= ~AT91_MATRIX_USBPUCR_PUON;
-			at91_sys_write(AT91_MATRIX_USBPUCR, usbpucr);
+			at91_matrix_write(AT91_MATRIX_USBPUCR, usbpucr);
 		}
 		clk_off(udc);
 	}
-- 
1.7.9

