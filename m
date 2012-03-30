Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226Ab2C3VcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:32:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59657 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936191Ab2C3Vb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:56 -0400
X-Sasl-enc: 0laUNIrTj20sYIAkcu0bdM6eUbFuc4a1luItl9YWXHHE 1333143115
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:55 2012
Message-Id: <20120330194854.893829351@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>
Subject: [ 142/175] ARM: tegra: select required CPU and L2 errata options
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit f35b431dde39fb40944d1024f08d88fbf04a3193 upstream.

The ARM IP revisions in Tegra are:
Tegra20: CPU r1p1, PL310 r2p0
Tegra30: CPU A01=r2p7/>=A02=r2p9, NEON r2p3-50, PL310 r3p1-50

Based on work by Olof Johansson, although the actual list of errata is
somewhat different here, since I added a bunch more and removed one PL310
erratum that doesn't seem applicable.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/Kconfig |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -10,6 +10,13 @@ config ARCH_TEGRA_2x_SOC
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
+	select ARM_ERRATA_720789
+	select ARM_ERRATA_742230
+	select ARM_ERRATA_751472
+	select ARM_ERRATA_754327
+	select ARM_ERRATA_764369
+	select PL310_ERRATA_727915 if CACHE_L2X0
+	select PL310_ERRATA_769419 if CACHE_L2X0
 	help
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
@@ -23,6 +30,11 @@ config ARCH_TEGRA_3x_SOC
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
 	select USE_OF
+	select ARM_ERRATA_743622
+	select ARM_ERRATA_751472
+	select ARM_ERRATA_754322
+	select ARM_ERRATA_764369
+	select PL310_ERRATA_769419 if CACHE_L2X0
 	help
 	  Support for NVIDIA Tegra T30 processor family, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller


