Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0EDLHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:07:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0EDLHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:07:11 -0400
Date: Tue, 4 May 2010 13:07:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB_SERIAL_KEYSPAN_* dependency on FIRMWARE_IN_KERNEL
Message-ID: <20100504110707.GA17177@sepie.suse.cz>
References: <4BD8A78B.6070906@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD8A78B.6070906@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:24:27PM +0200, Michal Marek wrote:
> Hi David,
> 
> I recently disabled CONFIG_FIRMWARE_IN_KERNEL in the default openSUSE
> kernels (as no built-in driver needs firmware and the initrd takes care
> of the modules), but this disabled all the CONFIG_USB_SERIAL_KEYSPAN_*
> options, because there is
> 
> config USB_SERIAL_KEYSPAN_MPR
>         bool "USB Keyspan MPR Firmware"
>         depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
> etc
> 
> in drivers/usb/serial/Kconfig, added in 2971c57 by you. Is there a
> reason for this dependency or shouldn't this rather depend on FW_LOADER?

I found another problem, the kconfig options to select the firmware
files are boolean, so scripts/Makefile.fwinst assumes that the firmware
is meant for a built-in driver and doesn't install it during
modules_install. This patch should fix that.

Michal

>From 2092944f13dbc5f5eee313e4b697e105f18a4b9a Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Tue, 4 May 2010 12:11:29 +0200
Subject: [PATCH] Fix USB_SERIAL_KEYSPAN firmware dependencies

Make sure the selected firmware is installed during modules_install. Also
drop the dependency on FIRMWARE_IN_KERNEL which doesn't make sense.

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index c480ea4..15066ec 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -296,19 +296,19 @@ config USB_SERIAL_KEYSPAN
 
 config USB_SERIAL_KEYSPAN_MPR
 	bool "USB Keyspan MPR Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the Keyspan MPR converter.
 
 config USB_SERIAL_KEYSPAN_USA28
 	bool "USB Keyspan USA-28 Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-28 converter.
 
 config USB_SERIAL_KEYSPAN_USA28X
 	bool "USB Keyspan USA-28X Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-28X converter.
 	  Be sure you have a USA-28X, there are also 28XA and 28XB
@@ -316,7 +316,7 @@ config USB_SERIAL_KEYSPAN_USA28X
 
 config USB_SERIAL_KEYSPAN_USA28XA
 	bool "USB Keyspan USA-28XA Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-28XA converter.
 	  Be sure you have a USA-28XA, there are also 28X and 28XB
@@ -324,7 +324,7 @@ config USB_SERIAL_KEYSPAN_USA28XA
 
 config USB_SERIAL_KEYSPAN_USA28XB
 	bool "USB Keyspan USA-28XB Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-28XB converter.
 	  Be sure you have a USA-28XB, there are also 28X and 28XA
@@ -332,46 +332,73 @@ config USB_SERIAL_KEYSPAN_USA28XB
 
 config USB_SERIAL_KEYSPAN_USA19
 	bool "USB Keyspan USA-19 Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-19 converter.
 
 config USB_SERIAL_KEYSPAN_USA18X
 	bool "USB Keyspan USA-18X Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-18X converter.
 
 config USB_SERIAL_KEYSPAN_USA19W
 	bool "USB Keyspan USA-19W Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-19W converter.
 
 config USB_SERIAL_KEYSPAN_USA19QW
 	bool "USB Keyspan USA-19QW Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-19QW converter.
 
 config USB_SERIAL_KEYSPAN_USA19QI
 	bool "USB Keyspan USA-19QI Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-19QI converter.
 
 config USB_SERIAL_KEYSPAN_USA49W
 	bool "USB Keyspan USA-49W Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-49W converter.
 
 config USB_SERIAL_KEYSPAN_USA49WLC
 	bool "USB Keyspan USA-49WLC Firmware"
-	depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
+	depends on USB_SERIAL_KEYSPAN
 	help
 	  Say Y here to include firmware for the USA-49WLC converter.
 
+# These helpers make sure that the firmware files appear in fw-shipped-m
+# and not fw-shipped-y if the driver is built as a module
+config USB_SERIAL_KEYSPAN_MPR_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_MPR
+config USB_SERIAL_KEYSPAN_USA28_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA28
+config USB_SERIAL_KEYSPAN_USA28X_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA28X
+config USB_SERIAL_KEYSPAN_USA28XA_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA28XA
+config USB_SERIAL_KEYSPAN_USA28XB_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA28XB
+config USB_SERIAL_KEYSPAN_USA19_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA19
+config USB_SERIAL_KEYSPAN_USA18X_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA18X
+config USB_SERIAL_KEYSPAN_USA19W_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA19W
+config USB_SERIAL_KEYSPAN_USA19QW_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA19QW
+config USB_SERIAL_KEYSPAN_USA19QI_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA19QI
+config USB_SERIAL_KEYSPAN_USA49W_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA49W
+config USB_SERIAL_KEYSPAN_USA49WLC_FW
+	def_tristate USB_SERIAL_KEYSPAN && USB_SERIAL_KEYSPAN_USA49WLC
+
 config USB_SERIAL_KLSI
 	tristate "USB KL5KUSB105 (Palmconnect) Driver"
 	---help---
diff --git a/firmware/Makefile b/firmware/Makefile
index 25200d1..b5f9e47 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -76,25 +76,18 @@ fw-shipped-$(CONFIG_USB_EMI62) += emi62/loader.fw emi62/bitstream.fw \
 fw-shipped-$(CONFIG_USB_KAWETH) += kaweth/new_code.bin kaweth/trigger_code.bin \
 				   kaweth/new_code_fix.bin \
 				   kaweth/trigger_code_fix.bin
-ifdef CONFIG_FIRMWARE_IN_KERNEL
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_MPR) += keyspan/mpr.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA18X) += keyspan/usa18x.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19) += keyspan/usa19.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19QI) += keyspan/usa19qi.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19QW) += keyspan/usa19qw.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19W) += keyspan/usa19w.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28) += keyspan/usa28.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28XA) += keyspan/usa28xa.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28XB) += keyspan/usa28xb.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28X) += keyspan/usa28x.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49W) += keyspan/usa49w.fw
-fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49WLC) += keyspan/usa49wlc.fw
-else
-fw-shipped- += keyspan/mpr.fw keyspan/usa18x.fw keyspan/usa19.fw	\
-	keyspan/usa19qi.fw keyspan/usa19qw.fw keyspan/usa19w.fw		\
-	keyspan/usa28.fw keyspan/usa28xa.fw keyspan/usa28xb.fw		\
-	keyspan/usa28x.fw keyspan/usa49w.fw keyspan/usa49wlc.fw
-endif
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_MPR_FW) += keyspan/mpr.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA18X_FW) += keyspan/usa18x.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19_FW) += keyspan/usa19.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19QI_FW) += keyspan/usa19qi.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19QW_FW) += keyspan/usa19qw.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19W_FW) += keyspan/usa19w.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28_FW) += keyspan/usa28.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28XA_FW) += keyspan/usa28xa.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28XB_FW) += keyspan/usa28xb.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28X_FW) += keyspan/usa28x.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49W_FW) += keyspan/usa49w.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49WLC_FW) += keyspan/usa49wlc.fw
 fw-shipped-$(CONFIG_USB_SERIAL_TI) += ti_3410.fw ti_5052.fw \
 				      mts_cdma.fw mts_gsm.fw mts_edge.fw
 fw-shipped-$(CONFIG_USB_SERIAL_EDGEPORT) += edgeport/boot.fw edgeport/boot2.fw \
