Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2HVNCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:02:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab2HVNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:02:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] [RFC] ARM: mass move of mach-*/plat-* header files
Date: Wed, 22 Aug 2012 12:56:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
References: <201208221253.07278.arnd@arndb.de>
In-Reply-To: <201208221253.07278.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221256.35657.arnd@arndb.de>
X-Provags-ID: V02:K0:F3CVIl45YIUDg7UxdNvyKE+aqP0qzo8bbJ6a/JxJK4y
 mIBogbdGpcNIJogrIqa68wBfVtQgDNGUnydzHpO4CGKHWPpP3V
 kobaMxpnpTKMB8yVPL4FQDyMkjfmLYHRsSoc+XFiUqJmVYPCp6
 Av7VeDbS6q7DlHe1SwQ8mxFh9Fga0VWHrS6ad0e79nMlmEyZPe
 SW8pNQg5u+ekeYNkoJigI3CAHLcoqijYmcVttnVTZzzDefMdYX
 O8Z7vQZqJjAc2K0ylAoR8D4H3fU3cG4FHFO81JTLLBRFiHuxk2
 51rkNWNOLwGq0jb+YV5jNRl06hgIBRslsg4ORs01aAWXlm3RiB
 WaWyGAD8SfSdSMiPAP0k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves all <mach/*.h> headers to <mach-*/*.h>, and all
<plat/*.h> headers to <plat-*/*.h>, as another step closer
to building kernels for multiple platforms combined.

A script to generate headers with the traditional names including
the headers from the new place is already there, so this move
should be completely transparent.

This patch was created fully automated by a script and
should be redone if the headers change. Note that the
plat-mxc headers move to mach-imx in the process because
they don't follow the <plat/foo.h> naming convention:

for i in arch/arm/mach-* ; do git mv $i/include/mach $i/include/${i##*/} ; done
for i in arch/arm/plat-* ; do git mv $i/include/plat $i/include/${i##*/} ; done
git mv arch/arm/plat-mxc/include/mach/*.h arch/arm/mach-imx/include/mach-imx/

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
   2.1% arch/arm/mach-at91/include/mach-at91/
   2.1% arch/arm/mach-at91/include/mach/
   3.1% arch/arm/mach-bcmring/include/mach-bcmring/csp/
   0.6% arch/arm/mach-bcmring/include/mach-bcmring/
   3.1% arch/arm/mach-bcmring/include/mach/csp/
   0.6% arch/arm/mach-bcmring/include/mach/
   0.3% arch/arm/mach-clps711x/include/mach-clps711x/
   0.3% arch/arm/mach-clps711x/include/mach/
   0.3% arch/arm/mach-cns3xxx/include/mach-cns3xxx/
   0.3% arch/arm/mach-cns3xxx/include/mach/
   1.2% arch/arm/mach-davinci/include/mach-davinci/
   1.2% arch/arm/mach-davinci/include/mach/
   0.1% arch/arm/mach-dove/include/mach-dove/
   0.1% arch/arm/mach-dove/include/mach/
   0.0% arch/arm/mach-ebsa110/include/mach-ebsa110/
   0.0% arch/arm/mach-ebsa110/include/mach/
   0.2% arch/arm/mach-ep93xx/include/mach-ep93xx/
   0.2% arch/arm/mach-ep93xx/include/mach/
   1.1% arch/arm/mach-exynos/include/mach-exynos/
   1.1% arch/arm/mach-exynos/include/mach/
   0.1% arch/arm/mach-footbridge/include/mach-footbridge/
   0.1% arch/arm/mach-footbridge/include/mach/
   0.2% arch/arm/mach-gemini/include/mach-gemini/
   0.2% arch/arm/mach-gemini/include/mach/
   0.2% arch/arm/mach-h720x/include/mach-h720x/
   0.2% arch/arm/mach-h720x/include/mach/
   0.0% arch/arm/mach-highbank/include/mach-highbank/
   0.0% arch/arm/mach-highbank/include/mach/
   7.5% arch/arm/mach-imx/include/mach-imx/
   0.0% arch/arm/mach-imx/include/mach/
   0.3% arch/arm/mach-integrator/include/mach-integrator/
   0.3% arch/arm/mach-integrator/include/mach/
   0.6% arch/arm/mach-iop13xx/include/mach-iop13xx/
   0.6% arch/arm/mach-iop13xx/include/mach/
   0.0% arch/arm/mach-iop32x/include/mach-iop32x/
   0.0% arch/arm/mach-iop32x/include/mach/
   0.0% arch/arm/mach-iop33x/include/mach-iop33x/
   0.0% arch/arm/mach-iop33x/include/mach/
   0.7% arch/arm/mach-ixp4xx/include/mach-ixp4xx/
   0.7% arch/arm/mach-ixp4xx/include/mach/
   0.1% arch/arm/mach-kirkwood/include/mach-kirkwood/
   0.1% arch/arm/mach-kirkwood/include/mach/
   0.4% arch/arm/mach-ks8695/include/mach-ks8695/
   0.4% arch/arm/mach-ks8695/include/mach/
   0.0% arch/arm/mach-l7200/include/mach-l7200/
   0.0% arch/arm/mach-l7200/include/mach/
   0.4% arch/arm/mach-lpc32xx/include/mach-lpc32xx/
   0.4% arch/arm/mach-lpc32xx/include/mach/
   1.0% arch/arm/mach-mmp/include/mach-mmp/
   1.0% arch/arm/mach-mmp/include/mach/
   1.9% arch/arm/mach-msm/include/mach-msm/
   1.9% arch/arm/mach-msm/include/mach/
   0.1% arch/arm/mach-mv78xx0/include/mach-mv78xx0/
   0.1% arch/arm/mach-mv78xx0/include/mach/
   0.0% arch/arm/mach-mvebu/include/mach-mvebu/
   0.0% arch/arm/mach-mvebu/include/mach/
   1.2% arch/arm/mach-mxs/include/mach-mxs/
   1.2% arch/arm/mach-mxs/include/mach/
   0.3% arch/arm/mach-netx/include/mach-netx/
   0.3% arch/arm/mach-netx/include/mach/
   0.1% arch/arm/mach-nomadik/include/mach-nomadik/
   0.1% arch/arm/mach-nomadik/include/mach/
   0.2% arch/arm/mach-omap1/include/mach-omap1/
   0.2% arch/arm/mach-omap1/include/mach/
   1.3% arch/arm/mach-omap2/include/mach-omap2/
   1.3% arch/arm/mach-omap2/include/mach/
   0.1% arch/arm/mach-orion5x/include/mach-orion5x/
   0.1% arch/arm/mach-orion5x/include/mach/
   0.0% arch/arm/mach-picoxcell/include/mach-picoxcell/
   0.0% arch/arm/mach-picoxcell/include/mach/
   0.4% arch/arm/mach-pnx4008/include/mach-pnx4008/
   0.4% arch/arm/mach-pnx4008/include/mach/
   0.0% arch/arm/mach-prima2/include/mach-prima2/
   0.0% arch/arm/mach-prima2/include/mach/
   4.2% arch/arm/mach-pxa/include/mach-pxa/
   4.2% arch/arm/mach-pxa/include/mach/
   0.7% arch/arm/mach-realview/include/mach-realview/
   0.7% arch/arm/mach-realview/include/mach/
   0.1% arch/arm/mach-rpc/include/mach-rpc/
   0.1% arch/arm/mach-rpc/include/mach/
   1.4% arch/arm/mach-s3c24xx/include/mach-s3c24xx/
   1.4% arch/arm/mach-s3c24xx/include/mach/
   0.5% arch/arm/mach-s3c64xx/include/mach-s3c64xx/
   0.5% arch/arm/mach-s3c64xx/include/mach/
   0.3% arch/arm/mach-s5p64x0/include/mach-s5p64x0/
   0.3% arch/arm/mach-s5p64x0/include/mach/
   0.2% arch/arm/mach-s5pc100/include/mach-s5pc100/
   0.2% arch/arm/mach-s5pc100/include/mach/
   0.3% arch/arm/mach-s5pv210/include/mach-s5pv210/
   0.3% arch/arm/mach-s5pv210/include/mach/
   2.0% arch/arm/mach-sa1100/include/mach-sa1100/
   2.0% arch/arm/mach-sa1100/include/mach/
   0.0% arch/arm/mach-shark/include/mach-shark/
   0.0% arch/arm/mach-shark/include/mach/
   1.5% arch/arm/mach-shmobile/include/mach-shmobile/
   1.5% arch/arm/mach-shmobile/include/mach/
   0.0% arch/arm/mach-socfpga/include/mach-socfpga/
   0.0% arch/arm/mach-socfpga/include/mach/
   0.1% arch/arm/mach-spear13xx/include/mach-spear13xx/
   0.1% arch/arm/mach-spear13xx/include/mach/
   0.0% arch/arm/mach-spear3xx/include/mach-spear3xx/
   0.0% arch/arm/mach-spear3xx/include/mach/
   0.0% arch/arm/mach-spear6xx/include/mach-spear6xx/
   0.0% arch/arm/mach-spear6xx/include/mach/
   0.5% arch/arm/mach-tegra/include/mach-tegra/
   0.5% arch/arm/mach-tegra/include/mach/
   0.5% arch/arm/mach-u300/include/mach-u300/
   0.5% arch/arm/mach-u300/include/mach/
   0.3% arch/arm/mach-ux500/include/mach-ux500/
   0.3% arch/arm/mach-ux500/include/mach/
   0.3% arch/arm/mach-versatile/include/mach-versatile/
   0.3% arch/arm/mach-versatile/include/mach/
   0.1% arch/arm/mach-vexpress/include/mach-vexpress/
   0.1% arch/arm/mach-vexpress/include/mach/
   0.2% arch/arm/mach-vt8500/include/mach-vt8500/
   0.2% arch/arm/mach-vt8500/include/mach/
   0.3% arch/arm/mach-w90x900/include/mach-w90x900/
   0.3% arch/arm/mach-w90x900/include/mach/
   0.0% arch/arm/mach-zynq/include/mach-zynq/
   0.0% arch/arm/mach-zynq/include/mach/
   7.5% arch/arm/plat-mxc/include/mach/
   0.2% arch/arm/plat-nomadik/include/plat-nomadik/
   0.2% arch/arm/plat-nomadik/include/plat/
   3.5% arch/arm/plat-omap/include/plat-omap/
   3.5% arch/arm/plat-omap/include/plat/
   0.1% arch/arm/plat-orion/include/plat-orion/
   0.1% arch/arm/plat-orion/include/plat/
   0.2% arch/arm/plat-pxa/include/plat-pxa/
   0.2% arch/arm/plat-pxa/include/plat/
   2.8% arch/arm/plat-samsung/include/plat-samsung/
   2.8% arch/arm/plat-samsung/include/plat/
   0.1% arch/arm/plat-spear/include/plat-spear/
   0.1% arch/arm/plat-spear/include/plat/
   0.0% arch/arm/plat-versatile/include/plat-versatile/
   0.0% arch/arm/plat-versatile/include/plat/

diff --git a/arch/arm/mach-at91/include/mach/at91_adc.h b/arch/arm/mach-at91/include/mach-at91/at91_adc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_adc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_adc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_aic.h b/arch/arm/mach-at91/include/mach-at91/at91_aic.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_aic.h
rename to arch/arm/mach-at91/include/mach-at91/at91_aic.h
diff --git a/arch/arm/mach-at91/include/mach/at91_dbgu.h b/arch/arm/mach-at91/include/mach-at91/at91_dbgu.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_dbgu.h
rename to arch/arm/mach-at91/include/mach-at91/at91_dbgu.h
diff --git a/arch/arm/mach-at91/include/mach/at91_matrix.h b/arch/arm/mach-at91/include/mach-at91/at91_matrix.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_matrix.h
rename to arch/arm/mach-at91/include/mach-at91/at91_matrix.h
diff --git a/arch/arm/mach-at91/include/mach/at91_pio.h b/arch/arm/mach-at91/include/mach-at91/at91_pio.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_pio.h
rename to arch/arm/mach-at91/include/mach-at91/at91_pio.h
diff --git a/arch/arm/mach-at91/include/mach/at91_pit.h b/arch/arm/mach-at91/include/mach-at91/at91_pit.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_pit.h
rename to arch/arm/mach-at91/include/mach-at91/at91_pit.h
diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/arch/arm/mach-at91/include/mach-at91/at91_pmc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_pmc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_pmc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_ramc.h b/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_ramc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_ramc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_rstc.h b/arch/arm/mach-at91/include/mach-at91/at91_rstc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_rstc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_rstc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_rtc.h b/arch/arm/mach-at91/include/mach-at91/at91_rtc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_rtc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_rtc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_rtt.h b/arch/arm/mach-at91/include/mach-at91/at91_rtt.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_rtt.h
rename to arch/arm/mach-at91/include/mach-at91/at91_rtt.h
diff --git a/arch/arm/mach-at91/include/mach/at91_shdwc.h b/arch/arm/mach-at91/include/mach-at91/at91_shdwc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_shdwc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_shdwc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_st.h b/arch/arm/mach-at91/include/mach-at91/at91_st.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_st.h
rename to arch/arm/mach-at91/include/mach-at91/at91_st.h
diff --git a/arch/arm/mach-at91/include/mach/at91_tc.h b/arch/arm/mach-at91/include/mach-at91/at91_tc.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_tc.h
rename to arch/arm/mach-at91/include/mach-at91/at91_tc.h
diff --git a/arch/arm/mach-at91/include/mach/at91_twi.h b/arch/arm/mach-at91/include/mach-at91/at91_twi.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at91_twi.h
rename to arch/arm/mach-at91/include/mach-at91/at91_twi.h

Cut here for review purposes. None of the other file renames have any
other changes, so there is no point spamming the mailing lists with
this. The full patch is available at
http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=62dd65e1ac307d2ba15f31cc2f754b8e348055c7

