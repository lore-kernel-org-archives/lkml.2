Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2LMKos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:44:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51500 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab2LMKoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:44:46 -0500
Message-ID: <50C9B186.1020603@ti.com>
Date: Thu, 13 Dec 2012 12:44:22 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>, <sameo@linux.intel.com>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <paul@pwsan.com>,
        <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/23] OMAP USB Host cleanup
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel & Felipe,

How can we proceed with this patchset?

You can use the below pull request.

The following changes since commit 47f46768d3a3866bff7164649dab499bf5d8ed81:

  Merge branch 'next/soc' into for-next (2012-12-07 16:35:14 -0800)

are available in the git repository at:

  git@github.com:rogerq/linux.git arm-for-next-usbhost6


It is known to fix the following warnings on arm-soc/for-next

[    1.608428] WARNING: at drivers/clk/clk.c:512 __clk_enable+0x94/0xa0()
[    0.608428] Modules linked in:
[    0.608459] [<c001b254>] (unwind_backtrace+0x0/0xf0) from
[<c003fdd4>] (warn_slowpath_common+0x4c/0x64)
[    0.608459] [<c003fdd4>] (warn_slowpath_common+0x4c/0x64) from
[<c003fe08>] (warn_slowpath_null+0x1c/0x24)
[    0.608489] [<c003fe08>] (warn_slowpath_null+0x1c/0x24) from
[<c03f05d8>] (__clk_enable+0x94/0xa0)
[    0.608489] [<c03f05d8>] (__clk_enable+0x94/0xa0) from [<c03f0604>]
(clk_enable+0x20/0x3c)
[    0.608520] [<c03f0604>] (clk_enable+0x20/0x3c) from [<c031f480>]
(usbhs_runtime_resume+0x68/0xa4)
[    0.608520] [<c031f480>] (usbhs_runtime_resume+0x68/0xa4) from
[<c030c9a0>] (pm_generic_runtime_resume+0x2c/0x38)
[    0.608551] [<c030c9a0>] (pm_generic_runtime_resume+0x2c/0x38) from
[<c0310134>] (__rpm_callback+0x2c/0x60)
[    0.608581] [<c0310134>] (__rpm_callback+0x2c/0x60) from [<c0311060>]
(rpm_resume+0x39c/0x60c)
[    0.608581] [<c0311060>] (rpm_resume+0x39c/0x60c) from [<c0311538>]
(__pm_runtime_resume+0x48/0x60)
[    0.608612] [<c0311538>] (__pm_runtime_resume+0x48/0x60) from
[<c04b8260>] (usbhs_omap_probe+0x3a8/0x858)
[    0.608612] [<c04b8260>] (usbhs_omap_probe+0x3a8/0x858) from
[<c0309c70>] (platform_drv_probe+0x18/0x1c)
[    0.608642] [<c0309c70>] (platform_drv_probe+0x18/0x1c) from
[<c03089f4>] (driver_probe_device+0x74/0x218)
[    0.608642] [<c03089f4>] (driver_probe_device+0x74/0x218) from
[<c0308c2c>] (__driver_attach+0x94/0x98)
[    0.608673] [<c0308c2c>] (__driver_attach+0x94/0x98) from
[<c0307188>] (bus_for_each_dev+0x4c/0x80)
[    0.608673] [<c0307188>] (bus_for_each_dev+0x4c/0x80) from
[<c0308224>] (bus_add_driver+0x174/0x240)
[    0.608703] [<c0308224>] (bus_add_driver+0x174/0x240) from
[<c03090f8>] (driver_register+0x78/0x14c)
[    0.608703] [<c03090f8>] (driver_register+0x78/0x14c) from
[<c0309e5c>] (platform_driver_probe+0x18/0x9c)
[    0.608734] [<c0309e5c>] (platform_driver_probe+0x18/0x9c) from
[<c0008774>] (do_one_initcall+0xfc/0x168)
[    0.608734] [<c0008774>] (do_one_initcall+0xfc/0x168) from
[<c04b2014>] (kernel_init+0x120/0x2cc)
[    0.608764] [<c04b2014>] (kernel_init+0x120/0x2cc) from [<c00137f0>]
(ret_from_fork+0x14/0x24)
[    0.608764] ---[ end trace f627315b3f056ecc ]---
[    0.608795] ------------[ cut here ]------------
[    0.608795] WARNING: at drivers/clk/clk.c:471 clk_disable+0x20/0x34()
[    0.608825] Modules linked in:
[    0.608825] [<c001b254>] (unwind_backtrace+0x0/0xf0) from
[<c003fdd4>] (warn_slowpath_common+0x4c/0x64)
[    0.608856] [<c003fdd4>] (warn_slowpath_common+0x4c/0x64) from
[<c003fe08>] (warn_slowpath_null+0x1c/0x24)
[    0.608856] [<c003fe08>] (warn_slowpath_null+0x1c/0x24) from
[<c03f0530>] (clk_disable+0x20/0x34)
[    0.608886] [<c03f0530>] (clk_disable+0x20/0x34) from [<c031f500>]
(usbhs_runtime_suspend+0x44/0xa4)
[    0.608917] [<c031f500>] (usbhs_runtime_suspend+0x44/0xa4) from
[<c030c968>] (pm_generic_runtime_suspend+0x2c/0x38)
[    0.608917] [<c030c968>] (pm_generic_runtime_suspend+0x2c/0x38) from
[<c002b120>] (_od_runtime_suspend+0xc/0x24)
[    0.608947] [<c002b120>] (_od_runtime_suspend+0xc/0x24) from
[<c0310134>] (__rpm_callback+0x2c/0x60)
[    0.608947] [<c0310134>] (__rpm_callback+0x2c/0x60) from [<c03104a4>]
(rpm_suspend+0xf4/0x59c)
[    0.608978] [<c03104a4>] (rpm_suspend+0xf4/0x59c) from [<c03118f8>]
(__pm_runtime_suspend+0x5c/0x80)
[    0.609008] [<c03118f8>] (__pm_runtime_suspend+0x5c/0x80) from
[<c030cde0>] (pm_generic_runtime_idle+0x44/0x50)
[    0.609008] [<c030cde0>] (pm_generic_runtime_idle+0x44/0x50) from
[<c0310134>] (__rpm_callback+0x2c/0x60)
[    0.609039] [<c0310134>] (__rpm_callback+0x2c/0x60) from [<c0310aa8>]
(rpm_idle+0xf0/0x21c)
[    0.609039] [<c0310aa8>] (rpm_idle+0xf0/0x21c) from [<c0310ca0>]
(__pm_runtime_idle+0x5c/0x80)
[    0.609069] [<c0310ca0>] (__pm_runtime_idle+0x5c/0x80) from
[<c04b83c0>] (usbhs_omap_probe+0x508/0x858)
[    0.609069] [<c04b83c0>] (usbhs_omap_probe+0x508/0x858) from
[<c0309c70>] (platform_drv_probe+0x18/0x1c)
[    0.609100] [<c0309c70>] (platform_drv_probe+0x18/0x1c) from
[<c03089f4>] (driver_probe_device+0x74/0x218)
[    0.609100] [<c03089f4>] (driver_probe_device+0x74/0x218) from
[<c0308c2c>] (__driver_attach+0x94/0x98)
[    0.609130] [<c0308c2c>] (__driver_attach+0x94/0x98) from
[<c0307188>] (bus_for_each_dev+0x4c/0x80)
[    0.609130] [<c0307188>] (bus_for_each_dev+0x4c/0x80) from
[<c0308224>] (bus_add_driver+0x174/0x240)
[    0.609161] [<c0308224>] (bus_add_driver+0x174/0x240) from
[<c03090f8>] (driver_register+0x78/0x14c)
[    0.609161] [<c03090f8>] (driver_register+0x78/0x14c) from
[<c0309e5c>] (platform_driver_probe+0x18/0x9c)
[    0.609191] [<c0309e5c>] (platform_driver_probe+0x18/0x9c) from
[<c0008774>] (do_one_initcall+0xfc/0x168)
[    0.609191] [<c0008774>] (do_one_initcall+0xfc/0x168) from
[<c04b2014>] (kernel_init+0x120/0x2cc)
[    0.609222] [<c04b2014>] (kernel_init+0x120/0x2cc) from [<c00137f0>]
(ret_from_fork+0x14/0x24)
[    0.609222] ---[ end trace f627315b3f056ecd ]---


cheers,
-roger

On 12/10/2012 12:20 PM, Roger Quadros wrote:
> Hi,
> 
> This patchset addresses the following
> 
> - Avoid addressing clocks one by one by name and use a for loop + bunch
>   of cleanups.
> - Get number of channels/ports dynamically either from revision register
>   or from platform data. Avoids getting clocks that are not present.
> - Add OMAP5 and HSIC mode (Not tested)
> 
> v4:
> - Added appropriate maintainers in to/cc
> - minor print message fix in patch 23 to maintain consistency
> 
> v3:
> - Rebased on arm-soc/for-next commit f979306c4d38d213c6977aaf3b1115e8ded71e3a
> - Rearranged patch that get rids of cpu_is_omap..() macros
> - Coding style fixes
> 
> v2:
> - Clocks are allocated dynamically based on number of ports available
> on the platform
> - Reduced console spam if non critical clocks are not found on the platform.
> - Get rid of cpu_is_.. macros from USB host driver.
> 
> cheers,
> -roger
> 
> ---
> Roger Quadros (23):
>   mfd: omap-usb-host: get rid of cpu_is_omap..() macros
>   mfd: omap-usb-tll: Avoid creating copy of platform data
>   mfd: omap-usb-tll: Fix channel count detection
>   mfd: omap-usb-tll: Use devm_kzalloc/ioremap and clean up error path
>   mfd: omap-usb-tll: Clean up clock handling
>   mfd: omap-usb-tll: introduce and use mode_needs_tll()
>   mfd: omap-usb-tll: Check for missing platform data in probe
>   mfd: omap-usb-tll: Fix error message
>   mfd: omap-usb-tll: serialize access to TLL device
>   mfd: omap-usb-tll: Add OMAP5 revision and HSIC support
>   mfd: omap_usb_host: Avoid creating copy of platform_data
>   mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
>   mfd: omap-usb-host: know about number of ports from revision register
>   mfd: omap-usb-host: override number of ports from platform data
>   mfd: omap-usb-host: cleanup clock management code
>   ARM: OMAP2+: clock data: Merge utmi_px_gfclk into
>     usb_host_hs_utmi_px_clk
>   mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
>   mfd: omap-usb-host: Get rid of unnecessary spinlock
>   mfd: omap-usb-host: clean up omap_usbhs_init()
>   USB: ehci-omap: Don't free gpios that we didn't request
>   ARM: OMAP3: clock data: get rid of unused USB host clock aliases and
>     dummies
>   ARM: OMAP4: clock data: get rid of unused USB host clock aliases
>   mfd: omap-usb-host: Don't spam console on clk_set_parent failure
> 
>  arch/arm/mach-omap2/cclock3xxx_data.c  |   13 -
>  arch/arm/mach-omap2/cclock44xx_data.c  |   55 +++--
>  arch/arm/mach-omap2/usb-host.c         |    5 +
>  arch/arm/mach-omap2/usb.h              |    1 +
>  drivers/mfd/omap-usb-host.c            |  474 ++++++++++++++++++--------------
>  drivers/mfd/omap-usb-tll.c             |  244 +++++++++--------
>  drivers/usb/host/ehci-omap.c           |    8 -
>  include/linux/platform_data/usb-omap.h |    4 +
>  8 files changed, 451 insertions(+), 353 deletions(-)
> 

