Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0ESTNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:13:50 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:54625 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0ESTNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:13:45 -0400
Date: Wed, 19 May 2010 23:13:19 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@blala.de
To: Greg KH <greg@kroah.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi: fixing 8255 and DAS08 Kconfig
 dependancies.
In-Reply-To: <20100518212859.GA26944@kroah.com>
Message-ID: <alpine.DEB.1.10.1005192309290.4000@blala.de>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com> <alpine.DEB.1.10.1005151604320.26254@blala.de> <20100518212859.GA26944@kroah.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 64bc3d065d852f0aab308c37d7e8778f29e384f8 Mon Sep 17 00:00:00 2001
From: Alexander Kurz <linux@kbdbabel.org>
Date: Wed, 19 May 2010 20:31:20 +0200
Subject: [PATCH] staging/comedi: fixing 8255 and DAS08 Kconfig dependancies.
 Both drivers support directly or indirectly multiple bus types,
 hence both are listed independent of bus types.

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
---
 drivers/staging/comedi/Kconfig          |   78 ++++++++++++++++++++++--------
 drivers/staging/comedi/drivers/Makefile |    4 +-
 2 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 75e060f..ebc68ee 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -100,15 +100,6 @@ menuconfig COMEDI_ISA_DRIVERS
 
 if COMEDI_ISA_DRIVERS && ISA
 
-config COMEDI_8255
-	tristate "Generic 8255 support"
-	default N
-	---help---
-	  Enable generic 8255 support.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called 8255.
-
 config COMEDI_ACL7225B
 	tristate "ADlink NuDAQ ACL-7225b and compatibles support"
 	default N
@@ -130,6 +121,7 @@ config COMEDI_PCL711
 
 config COMEDI_PCL724
 	tristate "Advantech PCL-722/724/731 and ADlink ACL-7122/7124/PET-48DIO"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Advantech PCL-724, PCL-722, PCL-731 and
@@ -198,6 +190,7 @@ config COMEDI_PCL818
 
 config COMEDI_PCM3724
 	tristate "Advantech PCM-3724 PC/104 card support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Advantech PCM-3724 PC/104 cards.
@@ -232,18 +225,9 @@ config COMEDI_RTI802
 	  To compile this driver as a module, choose M here: the module will be
 	  called rti802.
 
-config COMEDI_DAS08
-	tristate "DAS-08 compatible ISA, PC/104 and PCMCIA card support"
-	default N
-	---help---
-	  Enable support for Keithley Metrabyte/ComputerBoards DAS08
-	  and compatible ISA and PC/104 cards
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called das08.
-
 config COMEDI_DAS16M1
 	tristate "MeasurementComputing CIO-DAS16/M1DAS-16 ISA card support"
+	select COMEDI_8255
 	select COMEDI_FC
 	default N
 	---help---
@@ -254,6 +238,7 @@ config COMEDI_DAS16M1
 
 config COMEDI_DAS16
 	tristate "DAS-16 compatible ISA and PC/104 card support"
+	select COMEDI_8255
 	select COMEDI_FC
 	default N
 	---help---
@@ -385,6 +370,7 @@ config COMEDI_FL512
 
 config COMEDI_AIO_AIO12_8
 	tristate "I/O Products PC/104 AIO12-8 Analog I/O Board support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for I/O Products PC/104 AIO12-8 Analog I/O Board
@@ -466,6 +452,7 @@ config COMEDI_NI_ATMIO
 config COMEDI_NI_ATMIO16D
 	tristate "NI AT-MIO16/AT-MIO16D series ISA-PNP card support"
 	depends on ISAPNP && COMEDI_NI_COMMON
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for National Instruments AT-MIO16/AT-MIO16D cards.
@@ -667,6 +654,7 @@ config COMEDI_ADDI_APCI_3XXX
 
 config COMEDI_ADL_PCI6208
 	tristate "ADLink PCI-6208A support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for ADLink PCI-6208A cards
@@ -742,6 +730,7 @@ config COMEDI_ADV_PCI1723
 
 config COMEDI_ADV_PCI_DIO
 	tristate "Advantech PCI DIO card support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Advantech PCI DIO cards
@@ -753,6 +742,7 @@ config COMEDI_ADV_PCI_DIO
 
 config COMEDI_AMPLC_DIO200
 	tristate "Amplicon PC272E and PCI272 DIO board support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Amplicon PC272E and PCI272 DIO boards
@@ -762,6 +752,7 @@ config COMEDI_AMPLC_DIO200
 
 config COMEDI_AMPLC_PC236
 	tristate "Amplicon PC36AT and PCI236 DIO board support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Amplicon PC36AT and PCI236 DIO boards
@@ -790,6 +781,7 @@ config COMEDI_AMPLC_PCI224
 
 config COMEDI_AMPLC_PCI230
 	tristate "Amplicon PCI230 and PCI260 support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Amplicon PCI230 and PCI260 Multifunction I/O
@@ -860,6 +852,7 @@ config COMEDI_II_PCI20KC
 
 config COMEDI_DAQBOARD2000
 	tristate "IOtech DAQboard/2000 support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for the IOtech DAQboard/2000
@@ -887,6 +880,7 @@ config COMEDI_KE_COUNTER
 
 config COMEDI_CB_PCIDAS64
 	tristate "MeasurementComputing PCI-DAS 64xx, 60xx, and 4020 support"
+	select COMEDI_8255
 	select COMEDI_FC
 	default N
 	---help---
@@ -898,6 +892,7 @@ config COMEDI_CB_PCIDAS64
 
 config COMEDI_CB_PCIDAS
 	tristate "MeasurementComputing PCI-DAS support"
+	select COMEDI_8255
 	select COMEDI_FC
 	default N
 	---help---
@@ -911,6 +906,7 @@ config COMEDI_CB_PCIDAS
 
 config COMEDI_CB_PCIDDA
 	tristate "MeasurementComputing PCI-DDA series support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DDA
@@ -922,6 +918,7 @@ config COMEDI_CB_PCIDDA
 
 config COMEDI_CB_PCIDIO
 	tristate "MeasurementComputing PCI-DIO series support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DIO series
@@ -932,6 +929,7 @@ config COMEDI_CB_PCIDIO
 
 config COMEDI_CB_PCIMDAS
 	tristate "MeasurementComputing PCIM-DAS1602/16 support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI Migration
@@ -942,6 +940,7 @@ config COMEDI_CB_PCIMDAS
 
 config COMEDI_CB_PCIMDDA
 	tristate "MeasurementComputing PCIM-DDA06-16 support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCIM-DDA06-16
@@ -1017,6 +1016,7 @@ config COMEDI_NI_670X
 config COMEDI_NI_PCIDIO
 	tristate "NI PCI-DIO32HS, PCI-DIO96, PCI-6533, PCI-6503 support"
 	depends on COMEDI_MITE
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for National Instruments PCI-DIO-32HS, PXI-6533,
@@ -1049,6 +1049,7 @@ config COMEDI_NI_PCIMIO
 
 config COMEDI_RTD520
 	tristate "Real Time Devices PCI4520/DM7520 support"
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for Real Time Devices PCI4520/DM7520
@@ -1088,7 +1089,7 @@ endif # COMEDI_PCI_DRIVERS
 
 menuconfig COMEDI_PCMCIA_DRIVERS
 	tristate "Comedi PCMCIA drivers"
-	depends on COMEDI && PCMCIA && PCCARD
+	depends on COMEDI && (PCMCIA || PCCARD)
 	default N
 	---help---
 	  Enable comedi PCMCIA and PCCARD drivers to be built
@@ -1133,6 +1134,7 @@ config COMEDI_NI_DAQ_700_CS
 config COMEDI_NI_DAQ_DIO24_CS
 	tristate "NI DAQ-Card DIO-24 PCMCIA support"
 	depends on COMEDI_NI_COMMON
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQ-Card DIO-24
@@ -1153,8 +1155,8 @@ config COMEDI_NI_LABPC_CS
 config COMEDI_NI_MIO_CS
 	tristate "NI DAQCard E series PCMCIA support"
 	depends on COMEDI_NI_TIO && COMEDI_NI_COMMON
-	default N
 	select COMEDI_FC
+	default N
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard E series
 	  DAQCard-ai-16xe-50, DAQCard-ai-16e-4, DAQCard-6062E, DAQCard-6024E
@@ -1256,6 +1258,7 @@ config COMEDI_MITE
 
 config COMEDI_NI_TIO
 	tristate "NI general purpose counter support"
+	select COMEDI_8255
 	select COMEDI_MITE
 	default N
 	---help---
@@ -1269,6 +1272,7 @@ config COMEDI_NI_TIO
 
 config COMEDI_NI_LABPC
 	tristate "NI Lab-PC and compatibles ISA and PCI support"
+	select COMEDI_8255
 	select COMEDI_FC
 	default N
 	---help---
@@ -1282,8 +1286,40 @@ config COMEDI_NI_LABPC
 
 endif # COMEDI_NI_COMMON
 
+config COMEDI_8255
+	tristate "Generic 8255 support"
+	depends on COMEDI
+	default N
+	---help---
+	  Enable generic 8255 support.
+
+	  You should enable compilation this driver if you plan to use a board
+	  that has an 8255 chip. For multifunction boards, the main driver will
+	  configure the 8255 subdevice automatically.
+
+	  Note that most PCI 8255 boards do NOT work with this driver, and
+	  need a separate driver as a wrapper.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called 8255.
+
+config COMEDI_DAS08
+	tristate "DAS-08 compatible support"
+	depends on COMEDI
+	select COMEDI_8255
+	default N
+	---help---
+	  Enable support for DAS08 and compatible ISA, PC/104 and PCI cards.
+
+	  Note that PCMCIA DAS08 cards are not directly supported by this
+	  driver, and need a separate driver as a wrapper.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called das08.
+
 config COMEDI_FC
 	tristate "Comedi shared functions for low-level driver support"
+	depends on COMEDI
 	default N
 	---help---
 	  Enable support for shared functions for low-level drivers.
diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
index 3880b5a..1b58ed0 100644
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_COMEDI_SERIAL2002)		+= serial2002.o
 obj-$(CONFIG_COMEDI_SKEL)		+= skel.o
 
 # Comedi ISA drivers
-obj-$(CONFIG_COMEDI_8255)		+= 8255.o
 obj-$(CONFIG_COMEDI_ACL7225B)		+= acl7225b.o
 obj-$(CONFIG_COMEDI_PCL711)		+= pcl711.o
 obj-$(CONFIG_COMEDI_PCL724)		+= pcl724.o
@@ -26,7 +25,6 @@ obj-$(CONFIG_COMEDI_PCM3724)		+= pcm3724.o
 obj-$(CONFIG_COMEDI_PCM3730)		+= pcm3730.o
 obj-$(CONFIG_COMEDI_RTI800)		+= rti800.o
 obj-$(CONFIG_COMEDI_RTI802)		+= rti802.o
-obj-$(CONFIG_COMEDI_DAS08)		+= das08.o
 obj-$(CONFIG_COMEDI_DAS16M1)		+= das16m1.o
 obj-$(CONFIG_COMEDI_DAS16)		+= das16.o
 obj-$(CONFIG_COMEDI_DAS800)		+= das800.o
@@ -133,4 +131,6 @@ obj-$(CONFIG_COMEDI_NI_TIO)		+= ni_tio.o
 obj-$(CONFIG_COMEDI_NI_TIO)		+= ni_tiocmd.o
 obj-$(CONFIG_COMEDI_NI_LABPC)		+= ni_labpc.o
 
+obj-$(CONFIG_COMEDI_8255)		+= 8255.o
+obj-$(CONFIG_COMEDI_DAS08)		+= das08.o
 obj-$(CONFIG_COMEDI_FC)			+= comedi_fc.o
-- 
1.7.1


