Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0IBWg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:36:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0IBWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:36:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53072209"
Subject: Re: [PATCH 14/24] msm: add hotplug stub functions
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
In-Reply-To: <20100902171253.GX26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
	 <1282712273-344-15-git-send-email-johlstei@codeaurora.org>
	 <20100902111157.GX26319@n2100.arm.linux.org.uk>
	 <1283446177.3674.0.camel@c-dwalke-linux.qualcomm.com>
	 <20100902171253.GX26319@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 15:36:40 -0700
Message-ID: <1283467000.3674.381.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 18:12 +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 02, 2010 at 09:49:37AM -0700, Daniel Walker wrote:
> > On Thu, 2010-09-02 at 12:11 +0100, Russell King - ARM Linux wrote:
> > > On Tue, Aug 24, 2010 at 09:57:43PM -0700, Jeff Ohlstein wrote:
> > > > From: Daniel Walker <dwalker@codeaurora.org>
> > > > 
> > > > We don't actually do anything for hotplug yet. This just lets
> > > > everything compile, even when hotplug is enabled.
> > > 
> > > And the point of that is?  If you're not supporting hotplug CPU yet, then
> > > don't allow it to be enabled.
> > 
> > How do we do that? I didn't see a easy way to prevent it.
> 
> 
> config HOTPLUG_CPU
>         bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
>         depends on SMP && HOTPLUG && EXPERIMENTAL
> +	depends on !ARCH_MSM
> --

If no others use it .. We can do this to fix them all. What do you
think?

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d4d9f55..6d8cf39 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1163,9 +1163,12 @@ config NR_CPUS
 	depends on SMP
 	default "4"
 
+config HAS_HOTPLUG_CPU
+	bool
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && EXPERIMENTAL && HAS_HOTPLUG_CPU
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
diff --git a/arch/arm/mach-realview/Kconfig b/arch/arm/mach-realview/Kconfig
index b4575ae..8b5c339 100644
--- a/arch/arm/mach-realview/Kconfig
+++ b/arch/arm/mach-realview/Kconfig
@@ -11,6 +11,7 @@ config REALVIEW_EB_A9MP
 	bool "Support Multicore Cortex-A9"
 	depends on MACH_REALVIEW_EB
 	select CPU_V7
+	select HAS_HOTPLUG_CPU
 	help
 	  Enable support for the Cortex-A9MPCore tile on the Realview platform.
 
@@ -19,6 +20,7 @@ config REALVIEW_EB_ARM11MP
 	depends on MACH_REALVIEW_EB
 	select CPU_V6
 	select ARCH_HAS_BARRIERS if SMP
+	select HAS_HOTPLUG_CPU
 	help
 	  Enable support for the ARM11MPCore tile on the Realview platform.
 
@@ -37,6 +39,7 @@ config MACH_REALVIEW_PB11MP
 	select ARM_GIC
 	select HAVE_PATA_PLATFORM
 	select ARCH_HAS_BARRIERS if SMP
+	select HAS_HOTPLUG_CPU
 	help
 	  Include support for the ARM(R) RealView MPCore Platform Baseboard.
 	  PB11MPCore is a platform with an on-board ARM11MPCore and has
@@ -74,6 +77,7 @@ config MACH_REALVIEW_PBX
 	select HAVE_PATA_PLATFORM
 	select ARCH_SPARSEMEM_ENABLE if CPU_V7 && !REALVIEW_HIGH_PHYS_OFFSET
 	select ZONE_DMA if SPARSEMEM
+	select HAS_HOTPLUG_CPU
 	help
 	  Include support for the ARM(R) RealView PBX platform.
 



-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

