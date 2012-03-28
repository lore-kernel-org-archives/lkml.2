Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2C1RvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:51:14 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48946 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752220Ab2C1RvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:51:11 -0400
Date: Wed, 28 Mar 2012 19:51:06 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Jan Beulich <jbeulich@suse.com>, Joe Perches <joe@perches.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oskar Schirmer <oskar@scara.com>, Ryan Mallon <rmallon@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [GIT PULL REQUEST] watchdog - v3.4 merge window
Message-ID: <20120328175106.GE9602@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This series contains:
* Removal of the Documentation/watchdog/00-INDEX file
* Fix boot status reporting for imx2_wdt
* clean-up sp805_wdt, pnx4008_wdt and mpcore_wdt
* convert printk in watchdog drivers to pr_ functions
* change nowayout module parameter to bool for every watchdog device
* conversion of jz4740_wdt, pnx4008_wdt, max63xx_wdt, softdog, ep93xx_wdt,
  coh901327 and txx9wdt to new watchdog API
* Add support for the WDIOC_GETTIMELEFT ioctl call to the new watchdog API
* Change the new watchdog API so that the driver updates the timeout value
* two fixes for the xen_wdt driver

This pull will update the following files:

 Documentation/watchdog/00-INDEX                            |   19 
 b/Documentation/watchdog/convert_drivers_to_kernel_api.txt |    4 
 b/Documentation/watchdog/watchdog-kernel-api.txt           |   11 
 b/arch/arm/mach-ep93xx/core.c                              |   15 
 b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h          |    1 
 b/drivers/char/ipmi/ipmi_watchdog.c                        |    4 
 b/drivers/hwmon/fschmd.c                                   |    4 
 b/drivers/hwmon/w83793.c                                   |    4 
 b/drivers/staging/mei/wd.c                                 |    1 
 b/drivers/watchdog/Kconfig                                 |    8 
 b/drivers/watchdog/acquirewdt.c                            |   28 -
 b/drivers/watchdog/advantechwdt.c                          |   34 -
 b/drivers/watchdog/alim1535_wdt.c                          |   25 -
 b/drivers/watchdog/alim7101_wdt.c                          |   55 --
 b/drivers/watchdog/ar7_wdt.c                               |   38 -
 b/drivers/watchdog/at32ap700x_wdt.c                        |    4 
 b/drivers/watchdog/at91rm9200_wdt.c                        |   14 
 b/drivers/watchdog/at91sam9_wdt.c                          |   12 
 b/drivers/watchdog/ath79_wdt.c                             |    9 
 b/drivers/watchdog/bcm47xx_wdt.c                           |   18 
 b/drivers/watchdog/bcm63xx_wdt.c                           |   11 
 b/drivers/watchdog/bfin_wdt.c                              |   31 -
 b/drivers/watchdog/booke_wdt.c                             |   14 
 b/drivers/watchdog/coh901327_wdt.c                         |  206 +++-------
 b/drivers/watchdog/cpu5wdt.c                               |   19 
 b/drivers/watchdog/cpwd.c                                  |   20 
 b/drivers/watchdog/dw_wdt.c                                |    7 
 b/drivers/watchdog/ep93xx_wdt.c                            |  251 ++++--------
 b/drivers/watchdog/eurotechwdt.c                           |   32 -
 b/drivers/watchdog/f71808e_wdt.c                           |   40 -
 b/drivers/watchdog/gef_wdt.c                               |   15 
 b/drivers/watchdog/geodewdt.c                              |    9 
 b/drivers/watchdog/hpwdt.c                                 |   31 -
 b/drivers/watchdog/i6300esb.c                              |   39 -
 b/drivers/watchdog/iTCO_vendor_support.c                   |    7 
 b/drivers/watchdog/iTCO_wdt.c                              |   59 +-
 b/drivers/watchdog/ib700wdt.c                              |   26 -
 b/drivers/watchdog/ibmasr.c                                |   18 
 b/drivers/watchdog/imx2_wdt.c                              |   14 
 b/drivers/watchdog/indydog.c                               |   24 -
 b/drivers/watchdog/intel_scu_watchdog.c                    |   71 +--
 b/drivers/watchdog/intel_scu_watchdog.h                    |    1 
 b/drivers/watchdog/iop_wdt.c                               |   15 
 b/drivers/watchdog/it8712f_wdt.c                           |   39 -
 b/drivers/watchdog/it87_wdt.c                              |   46 --
 b/drivers/watchdog/ixp2000_wdt.c                           |   11 
 b/drivers/watchdog/ixp4xx_wdt.c                            |   15 
 b/drivers/watchdog/jz4740_wdt.c                            |  265 ++++---------
 b/drivers/watchdog/ks8695_wdt.c                            |   10 
 b/drivers/watchdog/lantiq_wdt.c                            |    8 
 b/drivers/watchdog/m54xx_wdt.c                             |   14 
 b/drivers/watchdog/machzwd.c                               |   37 -
 b/drivers/watchdog/max63xx_wdt.c                           |  194 +--------
 b/drivers/watchdog/mixcomwd.c                              |   29 -
 b/drivers/watchdog/mpc8xxx_wdt.c                           |   17 
 b/drivers/watchdog/mpcore_wdt.c                            |  111 ++---
 b/drivers/watchdog/mv64x60_wdt.c                           |   15 
 b/drivers/watchdog/nuc900_wdt.c                            |    4 
 b/drivers/watchdog/nv_tco.c                                |   46 +-
 b/drivers/watchdog/octeon-wdt-main.c                       |   16 
 b/drivers/watchdog/of_xilinx_wdt.c                         |   41 --
 b/drivers/watchdog/omap_wdt.c                              |    4 
 b/drivers/watchdog/orion_wdt.c                             |   15 
 b/drivers/watchdog/pc87413_wdt.c                           |   57 +-
 b/drivers/watchdog/pcwd.c                                  |  127 ++----
 b/drivers/watchdog/pcwd_pci.c                              |  113 ++---
 b/drivers/watchdog/pcwd_usb.c                              |   78 +--
 b/drivers/watchdog/pika_wdt.c                              |   23 -
 b/drivers/watchdog/pnx4008_wdt.c                           |  263 +++---------
 b/drivers/watchdog/pnx833x_wdt.c                           |   30 -
 b/drivers/watchdog/rc32434_wdt.c                           |   33 -
 b/drivers/watchdog/riowd.c                                 |   10 
 b/drivers/watchdog/s3c2410_wdt.c                           |   31 -
 b/drivers/watchdog/sa1100_wdt.c                            |   10 
 b/drivers/watchdog/sb_wdog.c                               |   28 -
 b/drivers/watchdog/sbc60xxwdt.c                            |   41 --
 b/drivers/watchdog/sbc7240_wdt.c                           |   44 --
 b/drivers/watchdog/sbc8360.c                               |   24 -
 b/drivers/watchdog/sbc_epx_c3.c                            |   23 -
 b/drivers/watchdog/sbc_fitpc2_wdt.c                        |   13 
 b/drivers/watchdog/sc1200wdt.c                             |   34 -
 b/drivers/watchdog/sc520_wdt.c                             |   39 -
 b/drivers/watchdog/sch311x_wdt.c                           |   17 
 b/drivers/watchdog/scx200_wdt.c                            |   25 -
 b/drivers/watchdog/shwdt.c                                 |   19 
 b/drivers/watchdog/smsc37b787_wdt.c                        |   42 --
 b/drivers/watchdog/softdog.c                               |  211 ++--------
 b/drivers/watchdog/sp5100_tco.c                            |   35 -
 b/drivers/watchdog/sp805_wdt.c                             |  111 +++--
 b/drivers/watchdog/stmp3xxx_wdt.c                          |    8 
 b/drivers/watchdog/ts72xx_wdt.c                            |    4 
 b/drivers/watchdog/twl4030_wdt.c                           |    4 
 b/drivers/watchdog/txx9wdt.c                               |  184 ++-------
 b/drivers/watchdog/via_wdt.c                               |   13 
 b/drivers/watchdog/w83627hf_wdt.c                          |   38 -
 b/drivers/watchdog/w83697hf_wdt.c                          |   43 --
 b/drivers/watchdog/w83697ug_wdt.c                          |   38 -
 b/drivers/watchdog/w83877f_wdt.c                           |   40 -
 b/drivers/watchdog/w83977f_wdt.c                           |   38 -
 b/drivers/watchdog/wafer5823wdt.c                          |   34 -
 b/drivers/watchdog/watchdog_core.c                         |    4 
 b/drivers/watchdog/watchdog_dev.c                          |   16 
 b/drivers/watchdog/wdrtas.c                                |   71 +--
 b/drivers/watchdog/wdt.c                                   |   55 +-
 b/drivers/watchdog/wdt285.c                                |   12 
 b/drivers/watchdog/wdt977.c                                |   40 -
 b/drivers/watchdog/wdt_pci.c                               |   70 +--
 b/drivers/watchdog/wm831x_wdt.c                            |    6 
 b/drivers/watchdog/wm8350_wdt.c                            |  223 ++--------
 b/drivers/watchdog/xen_wdt.c                               |   42 +-
 b/include/linux/watchdog.h                                 |    4 
 111 files changed, 1829 insertions(+), 2844 deletions(-)

with these Changes:

commit b92c803ec61de59e6e4ab9b2748d8e633cec3f08
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Mar 23 11:48:22 2012 +0100

    watchdog: txx9wdt: fix timeout
    
    timeout should be an unsigned int.
    Set the timeout value properly in the watchdog_device struct so that
    we don't get an faulty values for the WDIOC_GETTIMEOUT ioctl call.
    Add check to see that timeout is a valid parameter after it is loaded
    as a module.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

commit d6245842384c9289d4f778555fd8be729e0b0306
Author: Axel Lin <axel.lin@gmail.com>
Date:   Fri Mar 16 11:53:53 2012 +0800

    watchdog: Convert txx9wdt driver to watchdog framework
    
    This patch converts txx9wdt driver to watchdog framework.
    Also use devm_* APIs to save a few error handling code.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit dddbc6a0513b25c80e73e14ee704186deedc0d00
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Mar 22 20:42:16 2012 +0100

    watchdog: coh901327_wdt.c: fix timeout
    
    Set the timeout value properly so that we don't get faulty values
    for the WDIOC_GETTIMEOUT iotcl. 'margin' should be an unsigned int.
    Also add a check to see if margin is a valid parameter after it is
    loaded as a module.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

commit 15b25701b282bd761a82c6508529b2145744075f
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Fri Mar 16 09:14:12 2012 +0100

    watchdog: coh901327: convert to use watchdog core
    
    This converts the COH901327 watchdog to use the watchdog core.
    I followed Wolframs document, looked at some other drivers and
    tested it on the U300.
    
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Cc: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fd7b673c92731fc6c0b1e999adfd87b6762ee797
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Fri Mar 16 09:14:00 2012 +0100

    watchdog: Add support for WDIOC_GETTIMELEFT IOCTL in watchdog core
    
    This patch adds support for WDIOC_GETTIMELEFT IOCTL in watchdog core. So, there
    is another function pointer added to struct watchdog_ops, which can be passed by
    drivers to support this IOCTL.
    
    Related documentation is updated too.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2ca1606359695cc7ce371c7829c4082d9095fc06
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Mar 22 09:37:10 2012 +0100

    watchdog: ep93xx_wdt: timeout is an unsigned int value.
    
    the timeout is a positive thus unsigned int value.
    Also re-add the comment about the actual heartbeat.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 59dcf1eb1a4b15610c68a4dbb7430d61a65f4af3
Author: Mika Westerberg <mika.westerberg@iki.fi>
Date:   Sun Mar 18 13:09:52 2012 +0200

    watchdog: ep93xx_wdt: Fix timeout after conversion to watchdog core
    
    After the conversion of this driver to the watchdog core, I noticed that we
    miss setting the initial timeout of the wdt device.
    This results in a failure of the WDIOC_GETTIMEOUT ioctl call.
    
    Reviewed-by: Mika Westerberg <mika.westerberg@iki.fi>
    Tested-by: Mika Westerberg <mika.westerberg@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e12a679ddee4eb5ab2f99f7cf129355461e142c0
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Wed Mar 14 10:31:50 2012 -0700

    watchdog: Convert ep93xx driver to watchdog core
    
    Convert the ep93xx_wdt driver to the watchdog framework API.
    
    Also, use the dev_<fmt> functions instead of pr_<fmt> for logging.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Cc: Ryan Mallon <rmallon@gmail.com>
    Cc: Mika Westerberg <mika.westerberg@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fb35a5ad5b4b2c3806b52b0159f4d5a0ad205c0f
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:52:15 2012 +0530

    watchdog: sp805: Use devm routines
    
    sp805 driver currently uses normal kzalloc, ioremap, etc routines. This patch
    replaces these routines with devm_kzalloc and devm_request_mem_region etc, so
    that we don't need to handle freeing of resources for error cases and module
    removal routine.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d2e8919bcfb63b662945d0e5cb9338f0f2229d10
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:52:14 2012 +0530

    watchdog: sp805: replace readl/writel with lighter _relaxed variants
    
    readl/writel versions for ARM contain memory barrier instruction for
    synchronizing DMA buffers.  These are not required at least on this
    module.  So use lighter _relaxed variants.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bfae14b679063d85f10579bbfd532db58b122e29
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:52:13 2012 +0530

    watchdog: sp805: Fix documentation style comment
    
    @ was missing before variables names, in their description. Also adev is
    mentioned as dev in comment. Fix both these issues.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 60a1aa50b2ca142a91455203ca2aa09502eddd20
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:52:00 2012 +0530

    watchdog: mpcore_wdt: Allow platform_get_irq() to fail
    
    irq is not necessary for mpcore wdt. Don't return error if it is not passed. But
    if it is passed, then request_irq must pass.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 75f5a536c0b605b9b8406325f51f62f67141973e
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:51:59 2012 +0530

    watchdog: mpcore_wdt: Use devm routines
    
    mpcore_wdt driver currently uses normal kzalloc, request_irq, ioremap, etc
    routines. This patch replaces these routines with devm_kzalloc and
    devm_request_mem_region etc, so that we don't need to handle freeing of
    resources for error cases and module removal routine.
    
    Also, request_irq is moved before registering misc device, so that we are ready
    for irq as soon as device is registered.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit aa065770f55f44ed24f0a9b76ec6e2135264d43b
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:51:58 2012 +0530

    watchdog: mpcore_wdt: Rename dev to pdev for pointing to struct platform_device
    
    Pointer to struct platform_device is named as dev, which makes it confusing when
    we write statements like dev->dev to access struct device within it.
    
    This patch renames such names to pdev.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 38c484fa136f66224694af298f80e96bf4072700
Author: Jan Beulich <JBeulich@suse.com>
Date:   Mon Mar 19 09:32:28 2012 +0000

    watchdog: xen: don't clear is_active when xen_wdt_stop() failed
    
    xen_wdt_release() shouldn't clear is_active even when the watchdog
    didn't get stopped (which by itself shouldn't happen, but let's return
    a proper error in this case rather than adding a BUG() upon hypercall
    failure).
    
    Signed-off-by: Jan Beulich <jbeulich@suse.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 83448bf7867917d5fd104e65275d8e153f3293a8
Author: Jan Beulich <JBeulich@suse.com>
Date:   Mon Mar 19 09:30:33 2012 +0000

    watchdog: xen: don't unconditionally enable the watchdog during resume
    
    This was found to be a problem particularly after guest migration.
    
    Signed-off-by: Jan Beulich <jbeulich@suse.com>
    Reported-by: Wouter de Geus <benv-xensource.com@junerules.com>
    Reported-by: Ian Campbell <Ian.Campbell@citrix.com>
    Tested-by: Wouter de Geus <benv-xensource.com@junerules.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ccd4144dd41c32a284a5b040f87aaefed0361a21
Author: Jaehoon Chung <jh80.chung@samsung.com>
Date:   Fri Mar 16 15:27:21 2012 +0900

    watchdog: fix compiler error for missing parenthesis
    
    Joe's patch(watchdog: Use pr_<fmt> and pr_<level>) missed parenthesis in s3c2410_wdt.c.
    
    Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 697b41e4d4b20b8d8564f5501927b0ed07153990
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Mar 13 09:06:12 2012 +0100

    watchdog: ep93xx_wdt.c: fix platform probe
    
    Fix the device/driver init so that the misc_register
    happens as last (since this opens userspace access to
    the device).
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3e0113a896803f792ffdf19b016578420824573f
Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Tue Mar 13 09:48:16 2012 +1100

    watchdog: ep93xx: Convert the watchdog driver into a platform device.
    
    Convert the ep93xx watchdog driver into a platform device and
    remove it's dependency on <mach/hardware.h>.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Signed-off-by: Ryan Mallon <rmallon@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Reviewed-by: Mika Westerberg <mika.westerberg@iki.fi>
    Acked-by: Arnd Bergmann <arnd@arndb.de>

commit 0197c1c49ef1ff386b2ebb6d3b0fc85a8e174b5c
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Feb 29 20:20:58 2012 +0100

    watchdog: fix set_timeout operations
    
    Since we changed the behaviour of the set_timeout operation in the
    watchdog API, we need to change the allready converted drivers so
    that they update the timeout field at the end of the set_timeout
    operation.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b10f7c12e051762b84457f6d38d4b71acbf76a02
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Mon Sep 12 11:56:59 2011 +0200

    watchdog: watchdog_dev: Let the driver update the timeout field on set_timeout success
    
    When a set_timeout operation succeeds this does not necessarily mean that
    the exact timeout requested has been achieved, because the watchdog does not
    necessarily have a 1 second resolution. So rather then have the core set
    the timeout member of the watchdog_device struct to the exact requested
    value, instead the driver should set it to the actually achieved timeout value.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a5132cafc0a739107e51494b9054c0066802b8cd
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Feb 28 22:48:11 2012 +0000

    watchdog: softdog: convert to watchdog core
    
    Convert softdog.c to the new watchdog API.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a0f3683365513c052d21991fe75eccd95aba9d34
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Feb 8 14:24:10 2012 +0800

    watchdog: Convert max63xx_wdt driver to watchdog framework
    
    This patch converts max63xx_wdt driver to watchdog framework.
    Also use devm_* APIs to save a few error handling code.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6b1e83869d13a6b5ce9ceb4b8f79a7538d467dee
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Thu Feb 2 18:48:11 2012 +0100

    watchdog: pnx4008: convert driver to use the watchdog framework
    
    Make this driver a user of the watchdog framework and remove parts now handled
    by the core. Tested on a custom lpc32xx-board.
    
    [wim@iguana.be: Added set_timeout operation]
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2e51d90f4db6c94bc75c6ff22e959237f3cc27ba
Author: Axel Lin <axel.lin@gmail.com>
Date:   Mon Jan 23 15:26:59 2012 +0800

    watchdog: Convert wm8350_wdt driver to watchdog core
    
    This patch converts wm8350_wdt driver to use watchdog core APIs.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 85f6df1492ff8b620cf601a1509520d2b89858dd
Author: Axel Lin <axel.lin@gmail.com>
Date:   Thu Jan 26 18:10:45 2012 +0800

    watchdog: Convert jz4740_wdt driver to watchdog core
    
    This patch converts jz4740_wdt driver to use watchdog core APIs.
    Also use devm_* APIs to save a few error handling code.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Paul Cercueil <paul@crapouillou.net>
    Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 86a1e1896c2710402e29a875d8d830244274244d
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Mar 5 16:51:11 2012 +0100

    watchdog: nowayout is bool
    
    nowayout is actually a boolean value.
    So make it bool for all watchdog device drivers.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 27c766aaacb265d625dc634bf7903f7f9fd0c697
Author: Joe Perches <joe@perches.com>
Date:   Wed Feb 15 15:06:19 2012 -0800

    watchdog: Use pr_<fmt> and pr_<level>
    
    Use the current logging styles.
    
    Make sure all output has a prefix.
    Add missing newlines.
    Remove now unnecessary PFX, NAME, and miscellaneous other #defines.
    Coalesce formats.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7cbc353540c31ffaf65ad44d89b955be0f1d04dc
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Thu Feb 2 18:48:09 2012 +0100

    watchdog: pnx4008: don't use __raw_-accessors
    
    __raw_readl/__raw_writel are not meant for drivers [1].
    
    [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/117626
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 19f505f09c60d637c695a8e8c4768570e2309631
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Thu Feb 2 18:48:08 2012 +0100

    watchdog: pnx4008: cleanup resource handling using managed devices
    
    The resource handling in this driver was flaky: IO_ADDRESS instead of
    ioremap (and no unmapping), an unneeded static resource, no central exit
    path for error cases. Fix this by converting the driver to use managed
    resources. Also use dev_*-messages instead of pr_* while we are here.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 16ac4abe0d0ea0a8d42d6a2a7de2a4a00bbf5b40
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Fri Feb 24 15:12:37 2012 +0530

    watchdog: sp805_wdt: add pm callbacks to support standby/S2R/hibernation
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 474ef121008a2992bcc496930166ced89bda23d2
Author: Oskar Schirmer <oskar@scara.com>
Date:   Thu Feb 16 12:17:45 2012 +0000

    watchdog: make imx2_wdt report boot status correctly
    
    Ioctl WDIOC_GETBOOTSTATUS is supposed to return some information
    on why the system did (re)boot recently, value WDIOF_CARDRESET
    being used to indicate watchdog induced reboot.
    
    Up to now, imx2_wdt did not provide a value here, always returning
    zero to indicate normal boot.
    
    Do evaluate the IMX Watchdog Reset Status Register and
    produce WDIOF_CARDRESET with WDIOC_GETBOOTSTATUS in case
    of a watchdog induced reset.
    
    Signed-off-by: Oskar Schirmer <oskar@scara.com>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5ba927e8ca3f73acb98f417d126652e26ab40a57
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Mon Jan 23 20:17:38 2012 +0100

    watchdog: documentation: remove index-file
    
    The 00-index file in the watchdog directory is, like many others,
    outdated (conversion-howto is missing) and doesn't contain worthwhile
    additional information. As it seems to be a maintenance burden without
    much gain, simply remove it.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The overall diff is too long to include.
The patches can be viewed also on: http://www.linux-watchdog.org/cgi-bin/gitweb.cgi

Kind regards,
Wim.

