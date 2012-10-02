Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2JBRbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:31:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:19690 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2JBRbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:31:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,524,1344211200"; 
   d="scan'208";a="14900514"
Date: Tue, 2 Oct 2012 18:29:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xensource.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH] xen: resolve merge conflict with
 617276307cd4cdb9a95c77efaa3063695af63aa7
Message-ID: <alpine.DEB.2.02.1210021724300.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen tree tries to add a line to
arch/arm/mach-vexpress/Makefile.boot that has been removed by the
following commit in Linus' master:

commit 617276307cd4cdb9a95c77efaa3063695af63aa7
Author: Rob Herring <rob.herring@calxeda.com>
Date:   Thu Sep 6 13:43:04 2012 -0500

    ARM: vexpress: convert to multi-platform

In fact the dts Makefile is now arch/arm/boot/dts/Makefile, as per
commit 9cd11c0c47b8690b47e7573311ce5c483cb344ed.


This is the merge resolution patch.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --cc arch/arm/boot/dts/Makefile
index 43c084c,0000000..4745c1f
mode 100644,000000..100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -1,101 -1,0 +1,102 @@@
 +ifeq ($(CONFIG_OF),y)
 +
 +dtb-$(CONFIG_ARCH_AT91) += aks-cdu.dtb \
 +	at91sam9263ek.dtb \
 +	at91sam9g20ek_2mmc.dtb \
 +	at91sam9g20ek.dtb \
 +	at91sam9g25ek.dtb \
 +	at91sam9m10g45ek.dtb \
 +	at91sam9n12ek.dtb \
 +	ethernut5.dtb \
 +	evk-pro3.dtb \
 +	kizbox.dtb \
 +	tny_a9260.dtb \
 +	tny_a9263.dtb \
 +	tny_a9g20.dtb \
 +	usb_a9260.dtb \
 +	usb_a9263.dtb \
 +	usb_a9g20.dtb
 +dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 +dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 +	exynos4210-smdkv310.dtb \
 +	exynos4210-trats.dtb \
 +	exynos5250-smdk5250.dtb
 +dtb-$(CONFIG_ARCH_HIGHBANK) += highbank.dtb
 +dtb-$(CONFIG_ARCH_IMX5) += imx51-babbage.dtb \
 +	imx53-ard.dtb \
 +	imx53-evk.dtb \
 +	imx53-qsb.dtb \
 +	imx53-smd.dtb
 +dtb-$(CONFIG_SOC_IMX6Q) += imx6q-arm2.dtb \
 +	imx6q-sabrelite.dtb \
 +	imx6q-sabresd.dtb
 +dtb-$(CONFIG_ARCH_LPC32XX) += ea3250.dtb phy3250.dtb
 +dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-dns320.dtb \
 +	kirkwood-dns325.dtb \
 +	kirkwood-dreamplug.dtb \
 +	kirkwood-goflexnet.dtb \
 +	kirkwood-ib62x0.dtb \
 +	kirkwood-iconnect.dtb \
 +	kirkwood-lschlv2.dtb \
 +	kirkwood-lsxhl.dtb \
 +	kirkwood-ts219-6281.dtb \
 +	kirkwood-ts219-6282.dtb
 +dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
 +	msm8960-cdp.dtb
 +dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 +	armada-xp-db.dtb
 +dtb-$(CONFIG_ARCH_MXC) += imx51-babbage.dtb \
 +	imx53-ard.dtb \
 +	imx53-evk.dtb \
 +	imx53-qsb.dtb \
 +	imx53-smd.dtb \
 +	imx6q-arm2.dtb \
 +	imx6q-sabrelite.dtb \
 +	imx6q-sabresd.dtb
 +dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
 +	imx23-olinuxino.dtb \
 +	imx23-stmp378x_devb.dtb \
 +	imx28-apx4devkit.dtb \
 +	imx28-cfa10036.dtb \
 +	imx28-cfa10049.dtb \
 +	imx28-evk.dtb \
 +	imx28-m28evk.dtb \
 +	imx28-tx28.dtb
 +dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 +	omap3-beagle-xm.dtb \
 +	omap3-evm.dtb \
 +	omap3-tobi.dtb \
 +	omap4-panda.dtb \
 +	omap4-pandaES.dtb \
 +	omap4-var_som.dtb \
 +	omap4-sdp.dtb \
 +	omap5-evm.dtb
 +dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 +dtb-$(CONFIG_ARCH_U8500) += snowball.dtb
 +dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 +	r8a7740-armadillo800eva.dtb \
 +	sh73a0-kzm9g.dtb
 +dtb-$(CONFIG_ARCH_SPEAR13XX) += spear1310-evb.dtb \
 +	spear1340-evb.dtb
 +dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 +	spear310-evb.dtb \
 +	spear320-evb.dtb
 +dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
 +dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 +	tegra20-medcom-wide.dtb \
 +	tegra20-paz00.dtb \
 +	tegra20-plutux.dtb \
 +	tegra20-seaboard.dtb \
 +	tegra20-tec.dtb \
 +	tegra20-trimslice.dtb \
 +	tegra20-ventana.dtb \
 +	tegra20-whistler.dtb \
 +	tegra30-cardhu-a02.dtb \
 +	tegra30-cardhu-a04.dtb
 +dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2p-ca5s.dtb \
 +	vexpress-v2p-ca9.dtb \
 +	vexpress-v2p-ca15-tc1.dtb \
- 	vexpress-v2p-ca15_a7.dtb
++	vexpress-v2p-ca15_a7.dtb \
++	xenvm-4.2.dtb
 +
 +endif
