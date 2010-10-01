Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0JAL7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:50 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:43416 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab0JAL7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:46 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Ryan Mallon <ryan@bluewatersys.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 58/69] SPEAR3xx: Rename register/irq defines to remove naming conflicts
Date: Fri,  1 Oct 2010 17:26:18 +0530
Message-Id: <87945784c19f72c45f7fc5e70046697c2101a2b0.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Mallon <ryan@bluewatersys.com>

Prefix register and irq defintions to remove naming conflicts between
the three SPEAr3xx platforms.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/generic.h  |    4 +-
 arch/arm/mach-spear3xx/include/mach/gpio.h     |    3 +-
 arch/arm/mach-spear3xx/include/mach/irqs.h     |  207 ++++++++++++------------
 arch/arm/mach-spear3xx/include/mach/spear300.h |   26 ++--
 arch/arm/mach-spear3xx/include/mach/spear310.h |   44 +++---
 arch/arm/mach-spear3xx/include/mach/spear320.h |   48 +++---
 arch/arm/mach-spear3xx/spear300.c              |   73 ++++-----
 arch/arm/mach-spear3xx/spear310.c              |  108 ++++++------
 arch/arm/mach-spear3xx/spear320.c              |  158 +++++++++---------
 arch/arm/mach-spear3xx/spear3xx.c              |   25 ++--
 10 files changed, 349 insertions(+), 347 deletions(-)

diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 0412808..328f8f5 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -27,8 +27,8 @@
  * Following GPT channels will be used as clock source and clockevent
  */
 #define SPEAR_GPT0_BASE		SPEAR3XX_ML1_TMR_BASE
-#define SPEAR_GPT0_CHAN0_IRQ	IRQ_CPU_GPT1_1
-#define SPEAR_GPT0_CHAN1_IRQ	IRQ_CPU_GPT1_2
+#define SPEAR_GPT0_CHAN0_IRQ	SPEAR3XX_IRQ_CPU_GPT1_1
+#define SPEAR_GPT0_CHAN1_IRQ	SPEAR3XX_IRQ_CPU_GPT1_2
 
 /* Add spear3xx family device structure declarations here */
 extern struct amba_device gpio_device;
diff --git a/arch/arm/mach-spear3xx/include/mach/gpio.h b/arch/arm/mach-spear3xx/include/mach/gpio.h
index e531f6d..f15248c 100644
--- a/arch/arm/mach-spear3xx/include/mach/gpio.h
+++ b/arch/arm/mach-spear3xx/include/mach/gpio.h
@@ -51,8 +51,9 @@
 #define RAS_GPIO_5		13
 #define RAS_GPIO_6		14
 #define RAS_GPIO_7		15
+#endif
 
-#elif defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
+#if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
 #define PLGPIO_0		8
 #define PLGPIO_1		9
 #define PLGPIO_2		10
diff --git a/arch/arm/mach-spear3xx/include/mach/irqs.h b/arch/arm/mach-spear3xx/include/mach/irqs.h
index df0c1f3..6e26544 100644
--- a/arch/arm/mach-spear3xx/include/mach/irqs.h
+++ b/arch/arm/mach-spear3xx/include/mach/irqs.h
@@ -15,139 +15,140 @@
 #define __MACH_IRQS_H
 
 /* SPEAr3xx IRQ definitions */
-#define IRQ_HW_ACCEL_MOD_0			0
-#define IRQ_INTRCOMM_RAS_ARM			1
-#define IRQ_CPU_GPT1_1				2
-#define IRQ_CPU_GPT1_2				3
-#define IRQ_BASIC_GPT1_1			4
-#define IRQ_BASIC_GPT1_2			5
-#define IRQ_BASIC_GPT2_1			6
-#define IRQ_BASIC_GPT2_2			7
-#define IRQ_BASIC_DMA				8
-#define IRQ_BASIC_SMI				9
-#define IRQ_BASIC_RTC				10
-#define IRQ_BASIC_GPIO				11
-#define IRQ_BASIC_WDT				12
-#define IRQ_DDR_CONTROLLER			13
-#define IRQ_SYS_ERROR				14
-#define IRQ_WAKEUP_RCV				15
-#define IRQ_JPEG				16
-#define IRQ_IRDA				17
-#define IRQ_ADC					18
-#define IRQ_UART				19
-#define IRQ_SSP					20
-#define IRQ_I2C					21
-#define IRQ_MAC_1				22
-#define IRQ_MAC_2				23
-#define IRQ_USB_DEV				24
-#define IRQ_USB_H_OHCI_0			25
-#define IRQ_USB_H_EHCI_0			26
-#define IRQ_USB_H_EHCI_1			IRQ_USB_H_EHCI_0
-#define IRQ_USB_H_OHCI_1			27
-#define IRQ_GEN_RAS_1				28
-#define IRQ_GEN_RAS_2				29
-#define IRQ_GEN_RAS_3				30
-#define IRQ_HW_ACCEL_MOD_1			31
-#define IRQ_VIC_END				32
-
-#define VIRQ_START				IRQ_VIC_END
+#define SPEAR3XX_IRQ_HW_ACCEL_MOD_0		0
+#define SPEAR3XX_IRQ_INTRCOMM_RAS_ARM		1
+#define SPEAR3XX_IRQ_CPU_GPT1_1			2
+#define SPEAR3XX_IRQ_CPU_GPT1_2			3
+#define SPEAR3XX_IRQ_BASIC_GPT1_1		4
+#define SPEAR3XX_IRQ_BASIC_GPT1_2		5
+#define SPEAR3XX_IRQ_BASIC_GPT2_1		6
+#define SPEAR3XX_IRQ_BASIC_GPT2_2		7
+#define SPEAR3XX_IRQ_BASIC_DMA			8
+#define SPEAR3XX_IRQ_BASIC_SMI			9
+#define SPEAR3XX_IRQ_BASIC_RTC			10
+#define SPEAR3XX_IRQ_BASIC_GPIO			11
+#define SPEAR3XX_IRQ_BASIC_WDT			12
+#define SPEAR3XX_IRQ_DDR_CONTROLLER		13
+#define SPEAR3XX_IRQ_SYS_ERROR			14
+#define SPEAR3XX_IRQ_WAKEUP_RCV			15
+#define SPEAR3XX_IRQ_JPEG			16
+#define SPEAR3XX_IRQ_IRDA			17
+#define SPEAR3XX_IRQ_ADC			18
+#define SPEAR3XX_IRQ_UART			19
+#define SPEAR3XX_IRQ_SSP			20
+#define SPEAR3XX_IRQ_I2C			21
+#define SPEAR3XX_IRQ_MAC_1			22
+#define SPEAR3XX_IRQ_MAC_2			23
+#define SPEAR3XX_IRQ_USB_DEV			24
+#define SPEAR3XX_IRQ_USB_H_OHCI_0		25
+#define SPEAR3XX_IRQ_USB_H_EHCI_0		26
+#define SPEAR3XX_IRQ_USB_H_EHCI_1		SPEAR3XX_IRQ_USB_H_EHCI_0
+#define SPEAR3XX_IRQ_USB_H_OHCI_1		27
+#define SPEAR3XX_IRQ_GEN_RAS_1			28
+#define SPEAR3XX_IRQ_GEN_RAS_2			29
+#define SPEAR3XX_IRQ_GEN_RAS_3			30
+#define SPEAR3XX_IRQ_HW_ACCEL_MOD_1		31
+#define SPEAR3XX_IRQ_VIC_END			32
+
+#define SPEAR3XX_VIRQ_START			SPEAR3XX_IRQ_VIC_END
 
 /* SPEAr300 Virtual irq definitions */
-#ifdef CONFIG_MACH_SPEAR300
 /* IRQs sharing IRQ_GEN_RAS_1 */
-#define VIRQ_IT_PERS_S				(VIRQ_START + 0)
-#define VIRQ_IT_CHANGE_S			(VIRQ_START + 1)
-#define VIRQ_I2S				(VIRQ_START + 2)
-#define VIRQ_TDM				(VIRQ_START + 3)
-#define VIRQ_CAMERA_L				(VIRQ_START + 4)
-#define VIRQ_CAMERA_F				(VIRQ_START + 5)
-#define VIRQ_CAMERA_V				(VIRQ_START + 6)
-#define VIRQ_KEYBOARD				(VIRQ_START + 7)
-#define VIRQ_GPIO1				(VIRQ_START + 8)
+#define SPEAR300_VIRQ_IT_PERS_S			(SPEAR3XX_VIRQ_START + 0)
+#define SPEAR300_VIRQ_IT_CHANGE_S		(SPEAR3XX_VIRQ_START + 1)
+#define SPEAR300_VIRQ_I2S			(SPEAR3XX_VIRQ_START + 2)
+#define SPEAR300_VIRQ_TDM			(SPEAR3XX_VIRQ_START + 3)
+#define SPEAR300_VIRQ_CAMERA_L			(SPEAR3XX_VIRQ_START + 4)
+#define SPEAR300_VIRQ_CAMERA_F			(SPEAR3XX_VIRQ_START + 5)
+#define SPEAR300_VIRQ_CAMERA_V			(SPEAR3XX_VIRQ_START + 6)
+#define SPEAR300_VIRQ_KEYBOARD			(SPEAR3XX_VIRQ_START + 7)
+#define SPEAR300_VIRQ_GPIO1			(SPEAR3XX_VIRQ_START + 8)
 
 /* IRQs sharing IRQ_GEN_RAS_3 */
-#define IRQ_CLCD				IRQ_GEN_RAS_3
+#define SPEAR300_IRQ_CLCD			SPEAR3XX_IRQ_GEN_RAS_3
 
 /* IRQs sharing IRQ_INTRCOMM_RAS_ARM */
-#define IRQ_SDHCI				IRQ_INTRCOMM_RAS_ARM
-
-/* GPIO pins virtual irqs */
-#define SPEAR_GPIO_INT_BASE			(VIRQ_START + 9)
-#define SPEAR_GPIO1_INT_BASE			(SPEAR_GPIO_INT_BASE + 8)
-#define SPEAR_GPIO_INT_END			(SPEAR_GPIO1_INT_BASE + 8)
+#define SPEAR300_IRQ_SDHCI			SPEAR3XX_IRQ_INTRCOMM_RAS_ARM
 
 /* SPEAr310 Virtual irq definitions */
-#elif defined(CONFIG_MACH_SPEAR310)
 /* IRQs sharing IRQ_GEN_RAS_1 */
-#define VIRQ_SMII0				(VIRQ_START + 0)
-#define VIRQ_SMII1				(VIRQ_START + 1)
-#define VIRQ_SMII2				(VIRQ_START + 2)
-#define VIRQ_SMII3				(VIRQ_START + 3)
-#define VIRQ_WAKEUP_SMII0			(VIRQ_START + 4)
-#define VIRQ_WAKEUP_SMII1			(VIRQ_START + 5)
-#define VIRQ_WAKEUP_SMII2			(VIRQ_START + 6)
-#define VIRQ_WAKEUP_SMII3			(VIRQ_START + 7)
+#define SPEAR310_VIRQ_SMII0			(SPEAR3XX_VIRQ_START + 0)
+#define SPEAR310_VIRQ_SMII1			(SPEAR3XX_VIRQ_START + 1)
+#define SPEAR310_VIRQ_SMII2			(SPEAR3XX_VIRQ_START + 2)
+#define SPEAR310_VIRQ_SMII3			(SPEAR3XX_VIRQ_START + 3)
+#define SPEAR310_VIRQ_WAKEUP_SMII0		(SPEAR3XX_VIRQ_START + 4)
+#define SPEAR310_VIRQ_WAKEUP_SMII1		(SPEAR3XX_VIRQ_START + 5)
+#define SPEAR310_VIRQ_WAKEUP_SMII2		(SPEAR3XX_VIRQ_START + 6)
+#define SPEAR310_VIRQ_WAKEUP_SMII3		(SPEAR3XX_VIRQ_START + 7)
 
 /* IRQs sharing IRQ_GEN_RAS_2 */
-#define VIRQ_UART1				(VIRQ_START + 8)
-#define VIRQ_UART2				(VIRQ_START + 9)
-#define VIRQ_UART3				(VIRQ_START + 10)
-#define VIRQ_UART4				(VIRQ_START + 11)
-#define VIRQ_UART5				(VIRQ_START + 12)
+#define SPEAR310_VIRQ_UART1			(SPEAR3XX_VIRQ_START + 8)
+#define SPEAR310_VIRQ_UART2			(SPEAR3XX_VIRQ_START + 9)
+#define SPEAR310_VIRQ_UART3			(SPEAR3XX_VIRQ_START + 10)
+#define SPEAR310_VIRQ_UART4			(SPEAR3XX_VIRQ_START + 11)
+#define SPEAR310_VIRQ_UART5			(SPEAR3XX_VIRQ_START + 12)
 
 /* IRQs sharing IRQ_GEN_RAS_3 */
-#define VIRQ_EMI				(VIRQ_START + 13)
-#define VIRQ_PLGPIO				(VIRQ_START + 14)
+#define SPEAR310_VIRQ_EMI			(SPEAR3XX_VIRQ_START + 13)
+#define SPEAR310_VIRQ_PLGPIO			(SPEAR3XX_VIRQ_START + 14)
 
 /* IRQs sharing IRQ_INTRCOMM_RAS_ARM */
-#define VIRQ_TDM_HDLC				(VIRQ_START + 15)
-#define VIRQ_RS485_0				(VIRQ_START + 16)
-#define VIRQ_RS485_1				(VIRQ_START + 17)
-
-/* GPIO pins virtual irqs */
-#define SPEAR_GPIO_INT_BASE			(VIRQ_START + 18)
+#define SPEAR310_VIRQ_TDM_HDLC			(SPEAR3XX_VIRQ_START + 15)
+#define SPEAR310_VIRQ_RS485_0			(SPEAR3XX_VIRQ_START + 16)
+#define SPEAR310_VIRQ_RS485_1			(SPEAR3XX_VIRQ_START + 17)
 
 /* SPEAr320 Virtual irq definitions */
-#else
 /* IRQs sharing IRQ_GEN_RAS_1 */
-#define VIRQ_EMI				(VIRQ_START + 0)
-#define VIRQ_CLCD				(VIRQ_START + 1)
-#define VIRQ_SPP				(VIRQ_START + 2)
+#define SPEAR320_VIRQ_EMI			(SPEAR3XX_VIRQ_START + 0)
+#define SPEAR320_VIRQ_CLCD			(SPEAR3XX_VIRQ_START + 1)
+#define SPEAR320_VIRQ_SPP			(SPEAR3XX_VIRQ_START + 2)
 
 /* IRQs sharing IRQ_GEN_RAS_2 */
-#define IRQ_SDHCI				IRQ_GEN_RAS_2
+#define SPEAR320_IRQ_SDHCI			SPEAR3XX_IRQ_GEN_RAS_2
 
 /* IRQs sharing IRQ_GEN_RAS_3 */
-#define VIRQ_PLGPIO				(VIRQ_START + 3)
-#define VIRQ_I2S_PLAY				(VIRQ_START + 4)
-#define VIRQ_I2S_REC				(VIRQ_START + 5)
+#define SPEAR320_VIRQ_PLGPIO			(SPEAR3XX_VIRQ_START + 3)
+#define SPEAR320_VIRQ_I2S_PLAY			(SPEAR3XX_VIRQ_START + 4)
+#define SPEAR320_VIRQ_I2S_REC			(SPEAR3XX_VIRQ_START + 5)
 
 /* IRQs sharing IRQ_INTRCOMM_RAS_ARM */
-#define VIRQ_CANU				(VIRQ_START + 6)
-#define VIRQ_CANL				(VIRQ_START + 7)
-#define VIRQ_UART1				(VIRQ_START + 8)
-#define VIRQ_UART2				(VIRQ_START + 9)
-#define VIRQ_SSP1				(VIRQ_START + 10)
-#define VIRQ_SSP2				(VIRQ_START + 11)
-#define VIRQ_SMII0				(VIRQ_START + 12)
-#define VIRQ_MII1_SMII1				(VIRQ_START + 13)
-#define VIRQ_WAKEUP_SMII0			(VIRQ_START + 14)
-#define VIRQ_WAKEUP_MII1_SMII1			(VIRQ_START + 15)
-#define VIRQ_I2C1				(VIRQ_START + 16)
-
-/* GPIO pins virtual irqs */
-#define SPEAR_GPIO_INT_BASE			(VIRQ_START + 17)
+#define SPEAR320_VIRQ_CANU			(SPEAR3XX_VIRQ_START + 6)
+#define SPEAR320_VIRQ_CANL			(SPEAR3XX_VIRQ_START + 7)
+#define SPEAR320_VIRQ_UART1			(SPEAR3XX_VIRQ_START + 8)
+#define SPEAR320_VIRQ_UART2			(SPEAR3XX_VIRQ_START + 9)
+#define SPEAR320_VIRQ_SSP1			(SPEAR3XX_VIRQ_START + 10)
+#define SPEAR320_VIRQ_SSP2			(SPEAR3XX_VIRQ_START + 11)
+#define SPEAR320_VIRQ_SMII0			(SPEAR3XX_VIRQ_START + 12)
+#define SPEAR320_VIRQ_MII1_SMII1		(SPEAR3XX_VIRQ_START + 13)
+#define SPEAR320_VIRQ_WAKEUP_SMII0		(SPEAR3XX_VIRQ_START + 14)
+#define SPEAR320_VIRQ_WAKEUP_MII1_SMII1		(SPEAR3XX_VIRQ_START + 15)
+#define SPEAR320_VIRQ_I2C1			(SPEAR3XX_VIRQ_START + 16)
 
+/*
+ * GPIO pins virtual irqs
+ * Use the lowest number for the GPIO virtual IRQs base on which subarchs
+ * we have compiled in
+ */
+#if defined(CONFIG_MACH_SPEAR310)
+#define SPEAR3XX_GPIO_INT_BASE			(SPEAR3XX_VIRQ_START + 18)
+#elif defined(CONFIG_MACH_SPEAR320)
+#define SPEAR3XX_GPIO_INT_BASE			(SPEAR3XX_VIRQ_START + 17)
+#else
+#define SPEAR3XX_GPIO_INT_BASE			(SPEAR3XX_VIRQ_START + 9)
 #endif
 
-/* PLGPIO Virtual IRQs */
-#define SPEAR_PLGPIO_COUNT	102
+#define SPEAR300_GPIO1_INT_BASE			(SPEAR3XX_GPIO_INT_BASE + 8)
+#define SPEAR3XX_PLGPIO_COUNT	102
+
 #if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
-#define SPEAR_PLGPIO_INT_BASE	(SPEAR_GPIO_INT_BASE + 8)
-#define SPEAR_GPIO_INT_END	(SPEAR_PLGPIO_INT_BASE + SPEAR_PLGPIO_COUNT)
+#define SPEAR3XX_PLGPIO_INT_BASE		(SPEAR3XX_GPIO_INT_BASE + 8)
+#define SPEAR3XX_GPIO_INT_END			(SPEAR3XX_PLGPIO_INT_BASE + \
+							SPEAR3XX_PLGPIO_COUNT)
+#else
+#define SPEAR3XX_GPIO_INT_END	(SPEAR300_GPIO1_INT_BASE + 8)
 #endif
 
-#define VIRQ_END		SPEAR_GPIO_INT_END
-#define NR_IRQS			VIRQ_END
+#define SPEAR3XX_VIRQ_END	SPEAR3XX_GPIO_INT_END
+#define NR_IRQS			SPEAR3XX_VIRQ_END
 
 #endif /* __MACH_IRQS_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/spear300.h b/arch/arm/mach-spear3xx/include/mach/spear300.h
index 4fd2d22..7d5db76 100644
--- a/arch/arm/mach-spear3xx/include/mach/spear300.h
+++ b/arch/arm/mach-spear3xx/include/mach/spear300.h
@@ -20,19 +20,19 @@
 #define SPEAR300_TELECOM_BASE		UL(0x50000000)
 
 /* Interrupt registers offsets and masks */
-#define INT_ENB_MASK_REG		0x54
-#define INT_STS_MASK_REG		0x58
-#define IT_PERS_S_IRQ_MASK		(1 << 0)
-#define IT_CHANGE_S_IRQ_MASK		(1 << 1)
-#define I2S_IRQ_MASK			(1 << 2)
-#define TDM_IRQ_MASK			(1 << 3)
-#define CAMERA_L_IRQ_MASK		(1 << 4)
-#define CAMERA_F_IRQ_MASK		(1 << 5)
-#define CAMERA_V_IRQ_MASK		(1 << 6)
-#define KEYBOARD_IRQ_MASK		(1 << 7)
-#define GPIO1_IRQ_MASK			(1 << 8)
-
-#define SHIRQ_RAS1_MASK			0x1FF
+#define SPEAR300_INT_ENB_MASK_REG	0x54
+#define SPEAR300_INT_STS_MASK_REG	0x58
+#define SPEAR300_IT_PERS_S_IRQ_MASK	(1 << 0)
+#define SPEAR300_IT_CHANGE_S_IRQ_MASK	(1 << 1)
+#define SPEAR300_I2S_IRQ_MASK		(1 << 2)
+#define SPEAR300_TDM_IRQ_MASK		(1 << 3)
+#define SPEAR300_CAMERA_L_IRQ_MASK	(1 << 4)
+#define SPEAR300_CAMERA_F_IRQ_MASK	(1 << 5)
+#define SPEAR300_CAMERA_V_IRQ_MASK	(1 << 6)
+#define SPEAR300_KEYBOARD_IRQ_MASK	(1 << 7)
+#define SPEAR300_GPIO1_IRQ_MASK		(1 << 8)
+
+#define SPEAR300_SHIRQ_RAS1_MASK	0x1FF
 
 #define SPEAR300_CLCD_BASE		UL(0x60000000)
 #define SPEAR300_SDHCI_BASE		UL(0x70000000)
diff --git a/arch/arm/mach-spear3xx/include/mach/spear310.h b/arch/arm/mach-spear3xx/include/mach/spear310.h
index 37556b6..0780c47 100644
--- a/arch/arm/mach-spear3xx/include/mach/spear310.h
+++ b/arch/arm/mach-spear3xx/include/mach/spear310.h
@@ -38,29 +38,29 @@
 #define SPEAR310_SOC_CONFIG_BASE	UL(0xB4000000)
 
 /* Interrupt registers offsets and masks */
-#define INT_STS_MASK_REG		0x04
-#define SMII0_IRQ_MASK			(1 << 0)
-#define SMII1_IRQ_MASK			(1 << 1)
-#define SMII2_IRQ_MASK			(1 << 2)
-#define SMII3_IRQ_MASK			(1 << 3)
-#define WAKEUP_SMII0_IRQ_MASK		(1 << 4)
-#define WAKEUP_SMII1_IRQ_MASK		(1 << 5)
-#define WAKEUP_SMII2_IRQ_MASK		(1 << 6)
-#define WAKEUP_SMII3_IRQ_MASK		(1 << 7)
-#define UART1_IRQ_MASK			(1 << 8)
-#define UART2_IRQ_MASK			(1 << 9)
-#define UART3_IRQ_MASK			(1 << 10)
-#define UART4_IRQ_MASK			(1 << 11)
-#define UART5_IRQ_MASK			(1 << 12)
-#define EMI_IRQ_MASK			(1 << 13)
-#define TDM_HDLC_IRQ_MASK		(1 << 14)
-#define RS485_0_IRQ_MASK		(1 << 15)
-#define RS485_1_IRQ_MASK		(1 << 16)
+#define SPEAR310_INT_STS_MASK_REG	0x04
+#define SPEAR310_SMII0_IRQ_MASK		(1 << 0)
+#define SPEAR310_SMII1_IRQ_MASK		(1 << 1)
+#define SPEAR310_SMII2_IRQ_MASK		(1 << 2)
+#define SPEAR310_SMII3_IRQ_MASK		(1 << 3)
+#define SPEAR310_WAKEUP_SMII0_IRQ_MASK	(1 << 4)
+#define SPEAR310_WAKEUP_SMII1_IRQ_MASK	(1 << 5)
+#define SPEAR310_WAKEUP_SMII2_IRQ_MASK	(1 << 6)
+#define SPEAR310_WAKEUP_SMII3_IRQ_MASK	(1 << 7)
+#define SPEAR310_UART1_IRQ_MASK		(1 << 8)
+#define SPEAR310_UART2_IRQ_MASK		(1 << 9)
+#define SPEAR310_UART3_IRQ_MASK		(1 << 10)
+#define SPEAR310_UART4_IRQ_MASK		(1 << 11)
+#define SPEAR310_UART5_IRQ_MASK		(1 << 12)
+#define SPEAR310_EMI_IRQ_MASK		(1 << 13)
+#define SPEAR310_TDM_HDLC_IRQ_MASK	(1 << 14)
+#define SPEAR310_RS485_0_IRQ_MASK	(1 << 15)
+#define SPEAR310_RS485_1_IRQ_MASK	(1 << 16)
 
-#define SHIRQ_RAS1_MASK			0x000FF
-#define SHIRQ_RAS2_MASK			0x01F00
-#define SHIRQ_RAS3_MASK			0x02000
-#define SHIRQ_INTRCOMM_RAS_MASK		0x1C000
+#define SPEAR310_SHIRQ_RAS1_MASK	0x000FF
+#define SPEAR310_SHIRQ_RAS2_MASK	0x01F00
+#define SPEAR310_SHIRQ_RAS3_MASK	0x02000
+#define SPEAR310_SHIRQ_INTRCOMM_RAS_MASK	0x1C000
 
 #endif /* __MACH_SPEAR310_H */
 
diff --git a/arch/arm/mach-spear3xx/include/mach/spear320.h b/arch/arm/mach-spear3xx/include/mach/spear320.h
index 4f60073..30ea941 100644
--- a/arch/arm/mach-spear3xx/include/mach/spear320.h
+++ b/arch/arm/mach-spear3xx/include/mach/spear320.h
@@ -42,31 +42,31 @@
 #define SPEAR320_SOC_CONFIG_BASE	UL(0xB3000000)
 
 /* Interrupt registers offsets and masks */
-#define INT_STS_MASK_REG		0x04
-#define INT_CLR_MASK_REG		0x04
-#define INT_ENB_MASK_REG		0x08
-#define GPIO_IRQ_MASK			(1 << 0)
-#define I2S_PLAY_IRQ_MASK		(1 << 1)
-#define I2S_REC_IRQ_MASK		(1 << 2)
-#define EMI_IRQ_MASK			(1 << 7)
-#define CLCD_IRQ_MASK			(1 << 8)
-#define SPP_IRQ_MASK			(1 << 9)
-#define SDHCI_IRQ_MASK			(1 << 10)
-#define CAN_U_IRQ_MASK			(1 << 11)
-#define CAN_L_IRQ_MASK			(1 << 12)
-#define UART1_IRQ_MASK			(1 << 13)
-#define UART2_IRQ_MASK			(1 << 14)
-#define SSP1_IRQ_MASK			(1 << 15)
-#define SSP2_IRQ_MASK			(1 << 16)
-#define SMII0_IRQ_MASK			(1 << 17)
-#define MII1_SMII1_IRQ_MASK		(1 << 18)
-#define WAKEUP_SMII0_IRQ_MASK		(1 << 19)
-#define WAKEUP_MII1_SMII1_IRQ_MASK	(1 << 20)
-#define I2C1_IRQ_MASK			(1 << 21)
+#define SPEAR320_INT_STS_MASK_REG		0x04
+#define SPEAR320_INT_CLR_MASK_REG		0x04
+#define SPEAR320_INT_ENB_MASK_REG		0x08
+#define SPEAR320_GPIO_IRQ_MASK			(1 << 0)
+#define SPEAR320_I2S_PLAY_IRQ_MASK		(1 << 1)
+#define SPEAR320_I2S_REC_IRQ_MASK		(1 << 2)
+#define SPEAR320_EMI_IRQ_MASK			(1 << 7)
+#define SPEAR320_CLCD_IRQ_MASK			(1 << 8)
+#define SPEAR320_SPP_IRQ_MASK			(1 << 9)
+#define SPEAR320_SDHCI_IRQ_MASK			(1 << 10)
+#define SPEAR320_CAN_U_IRQ_MASK			(1 << 11)
+#define SPEAR320_CAN_L_IRQ_MASK			(1 << 12)
+#define SPEAR320_UART1_IRQ_MASK			(1 << 13)
+#define SPEAR320_UART2_IRQ_MASK			(1 << 14)
+#define SPEAR320_SSP1_IRQ_MASK			(1 << 15)
+#define SPEAR320_SSP2_IRQ_MASK			(1 << 16)
+#define SPEAR320_SMII0_IRQ_MASK			(1 << 17)
+#define SPEAR320_MII1_SMII1_IRQ_MASK		(1 << 18)
+#define SPEAR320_WAKEUP_SMII0_IRQ_MASK		(1 << 19)
+#define SPEAR320_WAKEUP_MII1_SMII1_IRQ_MASK	(1 << 20)
+#define SPEAR320_I2C1_IRQ_MASK			(1 << 21)
 
-#define SHIRQ_RAS1_MASK			0x000380
-#define SHIRQ_RAS3_MASK			0x000007
-#define SHIRQ_INTRCOMM_RAS_MASK		0x3FF800
+#define SPEAR320_SHIRQ_RAS1_MASK		0x000380
+#define SPEAR320_SHIRQ_RAS3_MASK		0x000007
+#define SPEAR320_SHIRQ_INTRCOMM_RAS_MASK	0x3FF800
 
 #endif /* __MACH_SPEAR320_H */
 
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index bbaf872..b041427 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -538,13 +538,13 @@ struct amba_device clcd_device = {
 		.flags = IORESOURCE_MEM,
 	},
 	.dma_mask = ~0,
-	.irq = {IRQ_CLCD, NO_IRQ},
+	.irq = {SPEAR300_IRQ_CLCD, NO_IRQ},
 };
 
 /* arm gpio1 device registeration */
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
-	.irq_base	= SPEAR_GPIO1_INT_BASE,
+	.irq_base	= SPEAR300_GPIO1_INT_BASE,
 };
 
 struct amba_device gpio1_device = {
@@ -557,7 +557,7 @@ struct amba_device gpio1_device = {
 		.end = SPEAR300_GPIO_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_GPIO1, NO_IRQ},
+	.irq = {SPEAR300_VIRQ_GPIO1, NO_IRQ},
 };
 
 /* keyboard device registration */
@@ -567,7 +567,7 @@ static struct resource kbd_resources[] = {
 		.end = SPEAR300_KEYBOARD_BASE + SZ_1K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = VIRQ_KEYBOARD,
+		.start = SPEAR300_VIRQ_KEYBOARD,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -683,7 +683,7 @@ static struct resource sdhci_resources[] = {
 		.end	= SPEAR300_SDHCI_BASE + SZ_256 - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
-		.start	= IRQ_SDHCI,
+		.start	= SPEAR300_IRQ_SDHCI,
 		.flags	= IORESOURCE_IRQ,
 	}
 };
@@ -701,53 +701,52 @@ struct platform_device sdhci_device = {
 /* spear3xx shared irq */
 static struct shirq_dev_config shirq_ras1_config[] = {
 	{
-		.virq = VIRQ_IT_PERS_S,
-		.enb_mask = IT_PERS_S_IRQ_MASK,
-		.status_mask = IT_PERS_S_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_IT_PERS_S,
+		.enb_mask = SPEAR300_IT_PERS_S_IRQ_MASK,
+		.status_mask = SPEAR300_IT_PERS_S_IRQ_MASK,
 	}, {
-		.virq = VIRQ_IT_CHANGE_S,
-		.enb_mask = IT_CHANGE_S_IRQ_MASK,
-		.status_mask = IT_CHANGE_S_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_IT_CHANGE_S,
+		.enb_mask = SPEAR300_IT_CHANGE_S_IRQ_MASK,
+		.status_mask = SPEAR300_IT_CHANGE_S_IRQ_MASK,
 	}, {
-		.virq = VIRQ_I2S,
-		.enb_mask = I2S_IRQ_MASK,
-		.status_mask = I2S_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_I2S,
+		.enb_mask = SPEAR300_I2S_IRQ_MASK,
+		.status_mask = SPEAR300_I2S_IRQ_MASK,
 	}, {
-		.virq = VIRQ_TDM,
-		.enb_mask = TDM_IRQ_MASK,
-		.status_mask = TDM_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_TDM,
+		.enb_mask = SPEAR300_TDM_IRQ_MASK,
+		.status_mask = SPEAR300_TDM_IRQ_MASK,
 	}, {
-		.virq = VIRQ_CAMERA_L,
-		.enb_mask = CAMERA_L_IRQ_MASK,
-		.status_mask = CAMERA_L_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_CAMERA_L,
+		.enb_mask = SPEAR300_CAMERA_L_IRQ_MASK,
+		.status_mask = SPEAR300_CAMERA_L_IRQ_MASK,
 	}, {
-		.virq = VIRQ_CAMERA_F,
-		.enb_mask = CAMERA_F_IRQ_MASK,
-		.status_mask = CAMERA_F_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_CAMERA_F,
+		.enb_mask = SPEAR300_CAMERA_F_IRQ_MASK,
+		.status_mask = SPEAR300_CAMERA_F_IRQ_MASK,
 	}, {
-		.virq = VIRQ_CAMERA_V,
-		.enb_mask = CAMERA_V_IRQ_MASK,
-		.status_mask = CAMERA_V_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_CAMERA_V,
+		.enb_mask = SPEAR300_CAMERA_V_IRQ_MASK,
+		.status_mask = SPEAR300_CAMERA_V_IRQ_MASK,
 	}, {
-		.virq = VIRQ_KEYBOARD,
-		.enb_mask = KEYBOARD_IRQ_MASK,
-		.status_mask = KEYBOARD_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_KEYBOARD,
+		.enb_mask = SPEAR300_KEYBOARD_IRQ_MASK,
+		.status_mask = SPEAR300_KEYBOARD_IRQ_MASK,
 	}, {
-		.virq = VIRQ_GPIO1,
-		.enb_mask = GPIO1_IRQ_MASK,
-		.status_mask = GPIO1_IRQ_MASK,
+		.virq = SPEAR300_VIRQ_GPIO1,
+		.enb_mask = SPEAR300_GPIO1_IRQ_MASK,
+		.status_mask = SPEAR300_GPIO1_IRQ_MASK,
 	},
 };
 
-
 static struct spear_shirq shirq_ras1 = {
-	.irq = IRQ_GEN_RAS_1,
+	.irq = SPEAR3XX_IRQ_GEN_RAS_1,
 	.dev_config = shirq_ras1_config,
 	.dev_count = ARRAY_SIZE(shirq_ras1_config),
 	.regs = {
-		.enb_reg = INT_ENB_MASK_REG,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_RAS1_MASK,
+		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
+		.status_reg = SPEAR300_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR300_SHIRQ_RAS1_MASK,
 		.clear_reg = -1,
 	},
 };
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 7d4ff0e..6fb20c3 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -205,7 +205,7 @@ struct amba_device uart1_device = {
 		.end = SPEAR310_UART1_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART1, NO_IRQ},
+	.irq = {SPEAR310_VIRQ_UART1, NO_IRQ},
 };
 
 /* uart2 device registeration */
@@ -218,7 +218,7 @@ struct amba_device uart2_device = {
 		.end = SPEAR310_UART2_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART2, NO_IRQ},
+	.irq = {SPEAR310_VIRQ_UART2, NO_IRQ},
 };
 
 /* uart3 device registeration */
@@ -231,7 +231,7 @@ struct amba_device uart3_device = {
 		.end = SPEAR310_UART3_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART3, NO_IRQ},
+	.irq = {SPEAR310_VIRQ_UART3, NO_IRQ},
 };
 
 /* uart4 device registeration */
@@ -244,7 +244,7 @@ struct amba_device uart4_device = {
 		.end = SPEAR310_UART4_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART4, NO_IRQ},
+	.irq = {SPEAR310_VIRQ_UART4, NO_IRQ},
 };
 
 /* uart5 device registeration */
@@ -257,7 +257,7 @@ struct amba_device uart5_device = {
 		.end = SPEAR310_UART5_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART5, NO_IRQ},
+	.irq = {SPEAR310_VIRQ_UART5, NO_IRQ},
 };
 
 /* nand device registeration */
@@ -331,8 +331,8 @@ struct platform_device emi_nor_device = {
 
 static struct plgpio_platform_data plgpio_plat_data = {
 	.gpio_base = 8,
-	.irq_base = SPEAR_PLGPIO_INT_BASE,
-	.gpio_count = SPEAR_PLGPIO_COUNT,
+	.irq_base = SPEAR3XX_PLGPIO_INT_BASE,
+	.gpio_count = SPEAR3XX_PLGPIO_COUNT,
 	.p2o = spear300_p2o,
 	.o2p = spear300_o2p,
 	/* list of registers with inconsistency */
@@ -346,7 +346,7 @@ static struct resource plgpio_resources[] = {
 		.end = SPEAR310_SOC_CONFIG_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = VIRQ_PLGPIO,
+		.start = SPEAR310_VIRQ_PLGPIO,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -365,115 +365,115 @@ struct platform_device plgpio_device = {
 /* spear3xx shared irq */
 static struct shirq_dev_config shirq_ras1_config[] = {
 	{
-		.virq = VIRQ_SMII0,
-		.status_mask = SMII0_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_SMII0,
+		.status_mask = SPEAR310_SMII0_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SMII1,
-		.status_mask = SMII1_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_SMII1,
+		.status_mask = SPEAR310_SMII1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SMII2,
-		.status_mask = SMII2_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_SMII2,
+		.status_mask = SPEAR310_SMII2_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SMII3,
-		.status_mask = SMII3_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_SMII3,
+		.status_mask = SPEAR310_SMII3_IRQ_MASK,
 	}, {
-		.virq = VIRQ_WAKEUP_SMII0,
-		.status_mask = WAKEUP_SMII0_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_WAKEUP_SMII0,
+		.status_mask = SPEAR310_WAKEUP_SMII0_IRQ_MASK,
 	}, {
-		.virq = VIRQ_WAKEUP_SMII1,
-		.status_mask = WAKEUP_SMII1_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_WAKEUP_SMII1,
+		.status_mask = SPEAR310_WAKEUP_SMII1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_WAKEUP_SMII2,
-		.status_mask = WAKEUP_SMII2_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_WAKEUP_SMII2,
+		.status_mask = SPEAR310_WAKEUP_SMII2_IRQ_MASK,
 	}, {
-		.virq = VIRQ_WAKEUP_SMII3,
-		.status_mask = WAKEUP_SMII3_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_WAKEUP_SMII3,
+		.status_mask = SPEAR310_WAKEUP_SMII3_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_ras1 = {
-	.irq = IRQ_GEN_RAS_1,
+	.irq = SPEAR3XX_IRQ_GEN_RAS_1,
 	.dev_config = shirq_ras1_config,
 	.dev_count = ARRAY_SIZE(shirq_ras1_config),
 	.regs = {
 		.enb_reg = -1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_RAS1_MASK,
+		.status_reg = SPEAR310_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR310_SHIRQ_RAS1_MASK,
 		.clear_reg = -1,
 	},
 };
 
 static struct shirq_dev_config shirq_ras2_config[] = {
 	{
-		.virq = VIRQ_UART1,
-		.status_mask = UART1_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_UART1,
+		.status_mask = SPEAR310_UART1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_UART2,
-		.status_mask = UART2_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_UART2,
+		.status_mask = SPEAR310_UART2_IRQ_MASK,
 	}, {
-		.virq = VIRQ_UART3,
-		.status_mask = UART3_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_UART3,
+		.status_mask = SPEAR310_UART3_IRQ_MASK,
 	}, {
-		.virq = VIRQ_UART4,
-		.status_mask = UART4_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_UART4,
+		.status_mask = SPEAR310_UART4_IRQ_MASK,
 	}, {
-		.virq = VIRQ_UART5,
-		.status_mask = UART5_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_UART5,
+		.status_mask = SPEAR310_UART5_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_ras2 = {
-	.irq = IRQ_GEN_RAS_2,
+	.irq = SPEAR3XX_IRQ_GEN_RAS_2,
 	.dev_config = shirq_ras2_config,
 	.dev_count = ARRAY_SIZE(shirq_ras2_config),
 	.regs = {
 		.enb_reg = -1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_RAS2_MASK,
+		.status_reg = SPEAR310_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR310_SHIRQ_RAS2_MASK,
 		.clear_reg = -1,
 	},
 };
 
 static struct shirq_dev_config shirq_ras3_config[] = {
 	{
-		.virq = VIRQ_EMI,
-		.status_mask = EMI_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_EMI,
+		.status_mask = SPEAR310_EMI_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_ras3 = {
-	.irq = IRQ_GEN_RAS_3,
+	.irq = SPEAR3XX_IRQ_GEN_RAS_3,
 	.dev_config = shirq_ras3_config,
 	.dev_count = ARRAY_SIZE(shirq_ras3_config),
 	.regs = {
 		.enb_reg = -1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_RAS3_MASK,
+		.status_reg = SPEAR310_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR310_SHIRQ_RAS3_MASK,
 		.clear_reg = -1,
 	},
 };
 
 static struct shirq_dev_config shirq_intrcomm_ras_config[] = {
 	{
-		.virq = VIRQ_TDM_HDLC,
-		.status_mask = TDM_HDLC_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_TDM_HDLC,
+		.status_mask = SPEAR310_TDM_HDLC_IRQ_MASK,
 	}, {
-		.virq = VIRQ_RS485_0,
-		.status_mask = RS485_0_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_RS485_0,
+		.status_mask = SPEAR310_RS485_0_IRQ_MASK,
 	}, {
-		.virq = VIRQ_RS485_1,
-		.status_mask = RS485_1_IRQ_MASK,
+		.virq = SPEAR310_VIRQ_RS485_1,
+		.status_mask = SPEAR310_RS485_1_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_intrcomm_ras = {
-	.irq = IRQ_INTRCOMM_RAS_ARM,
+	.irq = SPEAR3XX_IRQ_INTRCOMM_RAS_ARM,
 	.dev_config = shirq_intrcomm_ras_config,
 	.dev_count = ARRAY_SIZE(shirq_intrcomm_ras_config),
 	.regs = {
 		.enb_reg = -1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_INTRCOMM_RAS_MASK,
+		.status_reg = SPEAR310_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR310_SHIRQ_INTRCOMM_RAS_MASK,
 		.clear_reg = -1,
 	},
 };
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index 948ca8e..03d3486 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -606,7 +606,7 @@ struct amba_device clcd_device = {
 		.flags = IORESOURCE_MEM,
 	},
 	.dma_mask = ~0,
-	.irq = {VIRQ_CLCD, NO_IRQ},
+	.irq = {SPEAR320_VIRQ_CLCD, NO_IRQ},
 };
 
 /* ssp device registeration */
@@ -634,7 +634,7 @@ struct amba_device ssp_device[] = {
 			.end = SPEAR320_SSP0_BASE + SZ_4K - 1,
 			.flags = IORESOURCE_MEM,
 		},
-		.irq = {VIRQ_SSP1, NO_IRQ},
+		.irq = {SPEAR320_VIRQ_SSP1, NO_IRQ},
 	}, {
 		.dev = {
 			.coherent_dma_mask = ~0,
@@ -646,7 +646,7 @@ struct amba_device ssp_device[] = {
 			.end = SPEAR320_SSP1_BASE + SZ_4K - 1,
 			.flags = IORESOURCE_MEM,
 		},
-		.irq = {VIRQ_SSP2, NO_IRQ},
+		.irq = {SPEAR320_VIRQ_SSP2, NO_IRQ},
 	}
 };
 
@@ -660,7 +660,7 @@ struct amba_device uart1_device = {
 		.end = SPEAR320_UART1_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART1, NO_IRQ},
+	.irq = {SPEAR320_VIRQ_UART1, NO_IRQ},
 };
 
 /* uart2 device registeration */
@@ -673,7 +673,7 @@ struct amba_device uart2_device = {
 		.end = SPEAR320_UART2_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {VIRQ_UART2, NO_IRQ},
+	.irq = {SPEAR320_VIRQ_UART2, NO_IRQ},
 };
 
 /* emi nor flash device registeration */
@@ -687,8 +687,8 @@ struct platform_device emi_nor_device = {
 /* plgpio device registeration */
 static struct plgpio_platform_data plgpio_plat_data = {
 	.gpio_base = 8,
-	.irq_base = SPEAR_PLGPIO_INT_BASE,
-	.gpio_count = SPEAR_PLGPIO_COUNT,
+	.irq_base = SPEAR3XX_PLGPIO_INT_BASE,
+	.gpio_count = SPEAR3XX_PLGPIO_COUNT,
 };
 
 /* CAN device registeration */
@@ -698,7 +698,7 @@ static struct resource can0_resources[] = {
 		.end = SPEAR320_CAN0_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = VIRQ_CANU,
+		.start = SPEAR320_VIRQ_CANU,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -716,7 +716,7 @@ static struct resource can1_resources[] = {
 		.end = SPEAR320_CAN1_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = VIRQ_CANL,
+		.start = SPEAR320_VIRQ_CANL,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -735,7 +735,7 @@ static struct resource i2c1_resources[] = {
 		.end = SPEAR320_I2C_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = VIRQ_I2C1 ,
+		.start = SPEAR320_VIRQ_I2C1 ,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -781,7 +781,7 @@ static struct resource plgpio_resources[] = {
 		.end = SPEAR320_SOC_CONFIG_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = VIRQ_PLGPIO,
+		.start = SPEAR320_VIRQ_PLGPIO,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -819,7 +819,7 @@ static struct resource sdhci_resources[] = {
 		.end	= SPEAR320_SDHCI_BASE + SZ_256 - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
-		.start	= IRQ_SDHCI,
+		.start	= SPEAR320_IRQ_SDHCI,
 		.flags	= IORESOURCE_IRQ,
 	}
 };
@@ -837,123 +837,123 @@ struct platform_device sdhci_device = {
 /* spear3xx shared irq */
 static struct shirq_dev_config shirq_ras1_config[] = {
 	{
-		.virq = VIRQ_EMI,
-		.status_mask = EMI_IRQ_MASK,
-		.clear_mask = EMI_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_EMI,
+		.status_mask = SPEAR320_EMI_IRQ_MASK,
+		.clear_mask = SPEAR320_EMI_IRQ_MASK,
 	}, {
-		.virq = VIRQ_CLCD,
-		.status_mask = CLCD_IRQ_MASK,
-		.clear_mask = CLCD_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_CLCD,
+		.status_mask = SPEAR320_CLCD_IRQ_MASK,
+		.clear_mask = SPEAR320_CLCD_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SPP,
-		.status_mask = SPP_IRQ_MASK,
-		.clear_mask = SPP_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_SPP,
+		.status_mask = SPEAR320_SPP_IRQ_MASK,
+		.clear_mask = SPEAR320_SPP_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_ras1 = {
-	.irq = IRQ_GEN_RAS_1,
+	.irq = SPEAR3XX_IRQ_GEN_RAS_1,
 	.dev_config = shirq_ras1_config,
 	.dev_count = ARRAY_SIZE(shirq_ras1_config),
 	.regs = {
 		.enb_reg = -1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_RAS1_MASK,
-		.clear_reg = INT_CLR_MASK_REG,
+		.status_reg = SPEAR320_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR320_SHIRQ_RAS1_MASK,
+		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
 		.reset_to_clear = 1,
 	},
 };
 
 static struct shirq_dev_config shirq_ras3_config[] = {
 	{
-		.virq = VIRQ_PLGPIO,
-		.enb_mask = GPIO_IRQ_MASK,
-		.status_mask = GPIO_IRQ_MASK,
-		.clear_mask = GPIO_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_PLGPIO,
+		.enb_mask = SPEAR320_GPIO_IRQ_MASK,
+		.status_mask = SPEAR320_GPIO_IRQ_MASK,
+		.clear_mask = SPEAR320_GPIO_IRQ_MASK,
 	}, {
-		.virq = VIRQ_I2S_PLAY,
-		.enb_mask = I2S_PLAY_IRQ_MASK,
-		.status_mask = I2S_PLAY_IRQ_MASK,
-		.clear_mask = I2S_PLAY_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_I2S_PLAY,
+		.enb_mask = SPEAR320_I2S_PLAY_IRQ_MASK,
+		.status_mask = SPEAR320_I2S_PLAY_IRQ_MASK,
+		.clear_mask = SPEAR320_I2S_PLAY_IRQ_MASK,
 	}, {
-		.virq = VIRQ_I2S_REC,
-		.enb_mask = I2S_REC_IRQ_MASK,
-		.status_mask = I2S_REC_IRQ_MASK,
-		.clear_mask = I2S_REC_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_I2S_REC,
+		.enb_mask = SPEAR320_I2S_REC_IRQ_MASK,
+		.status_mask = SPEAR320_I2S_REC_IRQ_MASK,
+		.clear_mask = SPEAR320_I2S_REC_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_ras3 = {
-	.irq = IRQ_GEN_RAS_3,
+	.irq = SPEAR3XX_IRQ_GEN_RAS_3,
 	.dev_config = shirq_ras3_config,
 	.dev_count = ARRAY_SIZE(shirq_ras3_config),
 	.regs = {
-		.enb_reg = INT_ENB_MASK_REG,
+		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
 		.reset_to_enb = 1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_RAS3_MASK,
-		.clear_reg = INT_CLR_MASK_REG,
+		.status_reg = SPEAR320_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR320_SHIRQ_RAS3_MASK,
+		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
 		.reset_to_clear = 1,
 	},
 };
 
 static struct shirq_dev_config shirq_intrcomm_ras_config[] = {
 	{
-		.virq = VIRQ_CANU,
-		.status_mask = CAN_U_IRQ_MASK,
-		.clear_mask = CAN_U_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_CANU,
+		.status_mask = SPEAR320_CAN_U_IRQ_MASK,
+		.clear_mask = SPEAR320_CAN_U_IRQ_MASK,
 	}, {
-		.virq = VIRQ_CANL,
-		.status_mask = CAN_L_IRQ_MASK,
-		.clear_mask = CAN_L_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_CANL,
+		.status_mask = SPEAR320_CAN_L_IRQ_MASK,
+		.clear_mask = SPEAR320_CAN_L_IRQ_MASK,
 	}, {
-		.virq = VIRQ_UART1,
-		.status_mask = UART1_IRQ_MASK,
-		.clear_mask = UART1_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_UART1,
+		.status_mask = SPEAR320_UART1_IRQ_MASK,
+		.clear_mask = SPEAR320_UART1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_UART2,
-		.status_mask = UART2_IRQ_MASK,
-		.clear_mask = UART2_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_UART2,
+		.status_mask = SPEAR320_UART2_IRQ_MASK,
+		.clear_mask = SPEAR320_UART2_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SSP1,
-		.status_mask = SSP1_IRQ_MASK,
-		.clear_mask = SSP1_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_SSP1,
+		.status_mask = SPEAR320_SSP1_IRQ_MASK,
+		.clear_mask = SPEAR320_SSP1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SSP2,
-		.status_mask = SSP2_IRQ_MASK,
-		.clear_mask = SSP2_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_SSP2,
+		.status_mask = SPEAR320_SSP2_IRQ_MASK,
+		.clear_mask = SPEAR320_SSP2_IRQ_MASK,
 	}, {
-		.virq = VIRQ_SMII0,
-		.status_mask = SMII0_IRQ_MASK,
-		.clear_mask = SMII0_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_SMII0,
+		.status_mask = SPEAR320_SMII0_IRQ_MASK,
+		.clear_mask = SPEAR320_SMII0_IRQ_MASK,
 	}, {
-		.virq = VIRQ_MII1_SMII1,
-		.status_mask = MII1_SMII1_IRQ_MASK,
-		.clear_mask = MII1_SMII1_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_MII1_SMII1,
+		.status_mask = SPEAR320_MII1_SMII1_IRQ_MASK,
+		.clear_mask = SPEAR320_MII1_SMII1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_WAKEUP_SMII0,
-		.status_mask = WAKEUP_SMII0_IRQ_MASK,
-		.clear_mask = WAKEUP_SMII0_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_WAKEUP_SMII0,
+		.status_mask = SPEAR320_WAKEUP_SMII0_IRQ_MASK,
+		.clear_mask = SPEAR320_WAKEUP_SMII0_IRQ_MASK,
 	}, {
-		.virq = VIRQ_WAKEUP_MII1_SMII1,
-		.status_mask = WAKEUP_MII1_SMII1_IRQ_MASK,
-		.clear_mask = WAKEUP_MII1_SMII1_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_WAKEUP_MII1_SMII1,
+		.status_mask = SPEAR320_WAKEUP_MII1_SMII1_IRQ_MASK,
+		.clear_mask = SPEAR320_WAKEUP_MII1_SMII1_IRQ_MASK,
 	}, {
-		.virq = VIRQ_I2C1,
-		.status_mask = I2C1_IRQ_MASK,
-		.clear_mask = I2C1_IRQ_MASK,
+		.virq = SPEAR320_VIRQ_I2C1,
+		.status_mask = SPEAR320_I2C1_IRQ_MASK,
+		.clear_mask = SPEAR320_I2C1_IRQ_MASK,
 	},
 };
 
 static struct spear_shirq shirq_intrcomm_ras = {
-	.irq = IRQ_INTRCOMM_RAS_ARM,
+	.irq = SPEAR3XX_IRQ_INTRCOMM_RAS_ARM,
 	.dev_config = shirq_intrcomm_ras_config,
 	.dev_count = ARRAY_SIZE(shirq_intrcomm_ras_config),
 	.regs = {
 		.enb_reg = -1,
-		.status_reg = INT_STS_MASK_REG,
-		.status_reg_mask = SHIRQ_INTRCOMM_RAS_MASK,
-		.clear_reg = INT_CLR_MASK_REG,
+		.status_reg = SPEAR320_INT_STS_MASK_REG,
+		.status_reg_mask = SPEAR320_SHIRQ_INTRCOMM_RAS_MASK,
+		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
 		.reset_to_clear = 1,
 	},
 };
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 544072d..2765d32 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -22,13 +22,14 @@
 #include <mach/generic.h>
 #include <mach/spear.h>
 
-#define SPEAR3XX_WKUP_SRCS	(1 << IRQ_MAC_1 | 1 << IRQ_USB_DEV | \
-				1 << IRQ_BASIC_RTC | 1 << IRQ_BASIC_GPIO)
+#define SPEAR3XX_WKUP_SRCS	(1 << SPEAR3XX_IRQ_MAC_1 | 1 << \
+		SPEAR3XX_IRQ_USB_DEV | 1 << SPEAR3XX_IRQ_BASIC_RTC | 1 << \
+		SPEAR3XX_IRQ_BASIC_GPIO)
 /* Add spear3xx machines common devices here */
 /* gpio device registeration */
 static struct pl061_platform_data gpio_plat_data = {
 	.gpio_base	= 0,
-	.irq_base	= SPEAR_GPIO_INT_BASE,
+	.irq_base	= SPEAR3XX_GPIO_INT_BASE,
 };
 
 struct amba_device gpio_device = {
@@ -41,7 +42,7 @@ struct amba_device gpio_device = {
 		.end = SPEAR3XX_ICM3_GPIO_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {IRQ_BASIC_GPIO, NO_IRQ},
+	.irq = {SPEAR3XX_IRQ_BASIC_GPIO, NO_IRQ},
 };
 
 /* ssp device registeration */
@@ -71,7 +72,7 @@ struct amba_device ssp0_device = {
 		.end = SPEAR3XX_ICM1_SSP_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {IRQ_SSP, NO_IRQ},
+	.irq = {SPEAR3XX_IRQ_SSP, NO_IRQ},
 };
 
 /* uart device registeration */
@@ -84,7 +85,7 @@ struct amba_device uart_device = {
 		.end = SPEAR3XX_ICM1_UART_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	},
-	.irq = {IRQ_UART, NO_IRQ},
+	.irq = {SPEAR3XX_IRQ_UART, NO_IRQ},
 };
 
 /* watchdog device registeration */
@@ -106,7 +107,7 @@ static struct resource i2c_resources[] = {
 		.end = SPEAR3XX_ICM1_I2C_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = IRQ_I2C,
+		.start = SPEAR3XX_IRQ_I2C,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -129,7 +130,7 @@ static struct resource ehci_resources[] = {
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
-		.start = IRQ_USB_H_EHCI_0,
+		.start = SPEAR3XX_IRQ_USB_H_EHCI_0,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -141,7 +142,7 @@ static struct resource ohci0_resources[] = {
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
-		.start = IRQ_USB_H_OHCI_0,
+		.start = SPEAR3XX_IRQ_USB_H_OHCI_0,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -153,7 +154,7 @@ static struct resource ohci1_resources[] = {
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
-		.start = IRQ_USB_H_OHCI_1,
+		.start = SPEAR3XX_IRQ_USB_H_OHCI_1,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -208,7 +209,7 @@ static struct resource rtc_resources[] = {
 		.end = SPEAR3XX_ICM3_RTC_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = IRQ_BASIC_RTC,
+		.start = SPEAR3XX_IRQ_BASIC_RTC,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -227,7 +228,7 @@ static struct resource smi_resources[] = {
 		.end = SPEAR3XX_ICM3_SMI_CTRL_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = IRQ_BASIC_SMI,
+		.start = SPEAR3XX_IRQ_BASIC_SMI,
 		.flags = IORESOURCE_IRQ,
 	},
 };
-- 
1.7.2.2

