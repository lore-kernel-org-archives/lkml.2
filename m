Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1G1Qmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:42:55 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:49565 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906Ab1G1Qmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:42:52 -0400
X-Belgacom-Dynamic: yes
Date: Thu, 28 Jul 2011 18:42:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alejandro Cabrera <aldaya@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <florian@openwrt.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jonathan McDowell <noodles@earth.li>,
        Nat Gurumoorthy <natg@google.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Fordham <peter.fordham@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [GIT PULL REQUEST] watchdog - v3.1 additions
Message-ID: <20110728164244.GD4227@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-watchdog.git

This will update the following files:

 Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt |   14 
 Documentation/devicetree/bindings/watchdog/samsung-wdt.txt |   11 
 Documentation/watchdog/00-INDEX                            |    2 
 Documentation/watchdog/watchdog-kernel-api.txt             |  162 ++++
 arch/arm/mach-at91/include/mach/at91_wdt.h                 |   37 -
 drivers/watchdog/Kconfig                                   |   36 +
 drivers/watchdog/Makefile                                  |    8 
 drivers/watchdog/at91sam9_wdt.c                            |   21 
 drivers/watchdog/at91sam9_wdt.h                            |   37 +
 drivers/watchdog/dw_wdt.c                                  |  376 +++++++++++
 drivers/watchdog/hpwdt.c                                   |  104 ++-
 drivers/watchdog/iTCO_wdt.c                                |  412 ++++--------
 drivers/watchdog/imx2_wdt.c                                |    6 
 drivers/watchdog/it8712f_wdt.c                             |   63 +
 drivers/watchdog/it87_wdt.c                                |  168 ++---
 drivers/watchdog/mpcore_wdt.c                              |   23 
 drivers/watchdog/mtx-1_wdt.c                               |    4 
 drivers/watchdog/of_xilinx_wdt.c                           |  433 +++++++++++++
 drivers/watchdog/pc87413_wdt.c                             |   96 +-
 drivers/watchdog/s3c2410_wdt.c                             |   10 
 drivers/watchdog/sch311x_wdt.c                             |    5 
 drivers/watchdog/sp805_wdt.c                               |    5 
 drivers/watchdog/watchdog_core.c                           |  111 +++
 drivers/watchdog/watchdog_dev.c                            |  395 +++++++++++
 drivers/watchdog/watchdog_dev.h                            |   33 
 include/linux/watchdog.h                                   |   78 ++
 26 files changed, 2142 insertions(+), 508 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 19:00:16 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add minimum and max timeout
    
    Add min_timeout (minimum timeout) and max_timeout
    values so that the framework can check if the new
    timeout value is between the minimum and maximum
    timeout values. If both values are 0, then the
    framework will leave the check for the watchdog
    device driver itself.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:59:49 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add ioctl call
    
    Add support for extra ioctl calls by adding a
    ioctl watchdog operation. This operation will be
    called before we do our own handling of ioctl
    commands. This way we can override the internal
    ioctl command handling and we can also add
    extra ioctl commands. The ioctl watchdog operation
    should return the appropriate error codes or
    -ENOIOCTLCMD if the ioctl command should be handled
    through the internal ioctl handling of the framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:59:17 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add nowayout feature
    
    Add support for the nowayout feature to the
    WatchDog Timer Driver Core framework.
    This feature prevents the watchdog timer from being
    stopped.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:58:54 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add Magic Close feature
    
    Add support for the Magic Close feature to the
    WatchDog Timer Driver Core framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:58:21 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
    
    This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
    functionality to the WatchDog Timer Driver Core framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:57:55 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add WDIOC_SETOPTIONS ioctl
    
    This part add's the WDIOC_SETOPTIONS ioctl functionality
    to the WatchDog Timer Driver Core framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:57:23 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add WDIOC_KEEPALIVE ioctl
    
    This part add's the WDIOC_KEEPALIVE ioctl functionality to the
    WatchDog Timer Driver Core framework. Please note that the
    WDIOF_KEEPALIVEPING bit has to be set in the watchdog_info
    options field.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:56:38 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add basic ioctl functionality
    
    This part add's the basic ioctl functionality to the
    WatchDog Timer Driver Core framework. The supported
    ioctl call's are:
    	WDIOC_GETSUPPORT
    	WDIOC_GETSTATUS
    	WDIOC_GETBOOTSTATUS
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 22 18:55:18 2011 +0000

    watchdog: WatchDog Timer Driver Core - Add basic framework
    
    The WatchDog Timer Driver Core is a framework
    that contains the common code for all watchdog-driver's.
    It also introduces a watchdog device structure and the
    operations that go with it.
    
    This is the introduction of this framework. This part
    supports the minimal watchdog userspace API (or with
    other words: the functionality to use /dev/watchdog's
    open, release and write functionality as defined in
    the simplest watchdog API). Extra functionality will
    follow in the next set of patches.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Author: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Date:   Tue Jul 26 14:05:53 2011 +0100

    watchdog: hpwdt: add next gen HP servers
    
    This patch is required to enable hpwdt to work on next generation HP servers
    with iLO.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jul 25 18:53:00 2011 +0000

    watchdog: it8712f_wdt.c: improve includes
    
    remove unneeded pci.h include.
    and include ioport.h to avoid build errors for the region functions.
    
    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Date:   Fri Jul 15 01:52:05 2011 +0200

    watchdog: at91sam9/wdt: move register header to drivers
    
    move register header to drivers
    
    Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alejandro Cabrera <aldaya@gmail.com>
Date:   Thu Jun 2 22:13:11 2011 +0100

    watchdog: Add Xilinx watchdog timer driver
    
    Watchdog timer device driver for Xilinx xps_timebase_wdt compatible ip cores.
    It takes watchdog timer configuration from device tree and it needs that its
    parent has defined the property "clock-frecuency".
    It is compatible with watchdog timer kernel API, so user apps like watchdogd
    may talk with it.
    
    Signed-off-by: Alejandro Cabrera <aldaya@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Thu Jul 14 12:53:00 2011 +0200

    watchdog: remove empty pm-functions
    
    While checking what watchdog drivers usually do in suspend/resume to
    spot common behaviour for the watchdog framework, I found these drivers
    which do nothing but add some cruft. Remove it, it is superfluous. New
    approaches should probably be done with pm_ops anyway.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Nick Bowler <nbowler@elliptictech.com>
Date:   Fri Jul 15 11:04:02 2011 -0400

    watchdog: sp805: Flush posted writes in enable/disable.
    
    There are no reads in these functions, so if MMIO writes are posted,
    the writes in enable/disable may not have completed by the time these
    functions return.  If the functions run from different CPUs, it's
    in theory possible for the writes to be interleaved, which would be
    disastrous for this driver.
    
    At the very least, we need an mmiowb() before releasing the lock, but
    since it seems desirable for the watchdog timer to be actually stopped
    or reset when these functions return, read the lock register to force
    the writes out.
    
    Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Nick Bowler <nbowler@elliptictech.com>
Date:   Fri Jul 15 11:04:01 2011 -0400

    watchdog: sp805: Don't write 0 to the load value register.
    
    At least on the Versatile Express' V2M, calling wdt_disable followed by
    wdt_enable, for instance by running the following sequence:
    
      echo V > /dev/watchdog; echo V > /dev/watchdog
    
    results in an immediate reset.  The wdt_disable function writes 0 to the
    load register; while the watchdog interrupts are disabled at this point,
    this special value is defined to trigger an interrupt immediately.  It
    appears that in this instance, the reset happens when the interrupts
    are subsequently enabled by wdt_enable.
    
    Putting in a short delay after writing a new load value in wdt_enable
    solves the issue, but it seems cleaner to simply never write 0 to the
    load register at all: according to the hardware docs, writing 0 to the
    control register suffices to stop the counter, and the write of 0 to
    the load register is questionable anyway since this register resets to
    0xffffffff.
    
    Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Shawn Guo <shawn.guo@linaro.org>
Date:   Mon Jul 18 11:15:21 2011 +0800

    watchdog: imx2_wdt: add device tree probe support
    
    Adds device tree probe support for imx2_wdt driver.
    
    Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Cc: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Thomas Abraham <thomas.abraham@linaro.org>
Date:   Wed Jun 22 15:24:32 2011 +0530

    watchdog: s3c2410: Add support for device tree based probe
    
    This patch adds the of_match_table to enable s3c2410-wdt driver
    to be probed when watchdog device node is found in the device tree.
    
    Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Peter Fordham <peter.fordham@gmail.com>
Date:   Wed Jun 15 13:18:32 2011 -0700

    watchdog: mpcore_wdt: Add suspend/resume support.
    
    Add support for suspend and resume to the MPCore watchdog driver.
    
    Signed-off-by: Peter Fordham <peter.fordham@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Wed Jun 15 19:15:09 2011 +0200

    watchdog: mtx1-wdt: use dev_{err,info} instead of printk()
    
    use dev_{err,info} instead of printk(KERN_{ERR,INFO} ...)
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Thu Mar 3 14:30:59 2011 +0100

    watchdog: i.MX: use IMX_HAVE_PLATFORM_IMX2_WDT to depend on
    
    The i.MX architecture provides IMX_HAVE_PLATFORM_* macros to signal
    that a selected SoC supports a certain hardware. Use them instead of
    depending on ARCH_* directly.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org

Author: Jamie Iles <jamie@jamieiles.com>
Date:   Mon Jan 24 12:19:12 2011 +0000

    watchdog: add support for the Synopsys DesignWare WDT
    
    The Synopsys DesignWare watchdog is found in several ARM based systems
    and provides a choice of 16 timeout periods depending on the clock
    input.  The watchdog cannot be disabled once started.
    
    Signed-off-by: Jamie Iles <jamie@jamieiles.com>
    Acked-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jonathan McDowell <noodles@earth.li>
Date:   Thu Apr 14 12:02:39 2011 -0700

    watchdog: pc87413_wdt: Cleanup pc87413 watchdog driver to use
    
    Inspired by Nat Gurumoorthy's recent patches for cleaning up the it87
    drivers to use request_muxed_region for accessing the SuperIO area on
    these chips, and the fact I have a GPIO driver for the pc8741x basically
    ready for submission, here is a patch to cleanup the pc87413 watchdog
    driver to use request_muxed_region for accessing the SuperIO area.
    
    It also pulls out the details about the SWC IO area on initial driver
    load, and properly does a request_region for that area - there's no
    requirement to touch the SuperIO area after doing the initial watchdog
    enable and IO base retrieval.
    
    While I have hardware with a pc87413 on it it is not wired in a way that
    allows the watchdog to reboot the machine, so I have not been able to
    fully test these changes - I have checked that the driver correctly
    initialises itself still and requests the SWC io region ok.
    
    Signed-Off-By: Jonathan McDowell <noodles@earth.li>
    Signed-Off-By: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri May 20 08:28:48 2011 +0000

    watchdog: iTCO_wdt: clean-up PCI device ID's
    
    Clean up of the iTCO_wdt PCI device ID's.
    Own macro is replaced by the PCI_VDEVICE macro.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Nat Gurumoorthy <natg@google.com>
Date:   Mon May 9 11:45:07 2011 -0700

    watchdog: Use "request_muxed_region" in it87 watchdog drivers
    
    Changes the it87 watchdog drivers to use "request_muxed_region".
    Serialize access to the hardware by using "request_muxed_region" macro defined
    by Alan Cox. Call to this macro will hold off the requestor if the resource is
    currently busy.
    
    The use of the above macro makes it possible to get rid of
    spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
    This also greatly simplifies the implementation of it87_wdt.c driver.
    
     "superio_enter" will return an error if call to "request_muxed_region" fails.
    Rest of the code change is to ripple an error return from superio_enter to
    the top level.
    
    Signed-off-by: Nat Gurumoorthy <natg@google.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
new file mode 100644
index 0000000..2144af1
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
@@ -0,0 +1,14 @@
+* Freescale i.MX Watchdog Timer (WDT) Controller
+
+Required properties:
+- compatible : Should be "fsl,<soc>-wdt"
+- reg : Should contain WDT registers location and length
+- interrupts : Should contain WDT interrupt
+
+Examples:
+
+wdt@73f98000 {
+	compatible = "fsl,imx51-wdt", "fsl,imx21-wdt";
+	reg = <0x73f98000 0x4000>;
+	interrupts = <58>;
+};
diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
new file mode 100644
index 0000000..79ead82
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
@@ -0,0 +1,11 @@
+* Samsung's Watchdog Timer Controller
+
+The Samsung's Watchdog controller is used for resuming system operation
+after a preset amount of time during which the WDT reset event has not
+occured.
+
+Required properties:
+- compatible : should be "samsung,s3c2410-wdt"
+- reg : base physical address of the controller and length of memory mapped
+	region.
+- interrupts : interrupt number to the cpu.
diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-INDEX
index ee99451..fc51128 100644
--- a/Documentation/watchdog/00-INDEX
+++ b/Documentation/watchdog/00-INDEX
@@ -8,6 +8,8 @@ src/
 	- directory holding watchdog related example programs.
 watchdog-api.txt
 	- description of the Linux Watchdog driver API.
+watchdog-kernel-api.txt
+	- description of the Linux WatchDog Timer Driver Core kernel API.
 watchdog-parameters.txt
 	- information on driver parameters (for drivers other than
 	  the ones that have driver-specific files here)
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
new file mode 100644
index 0000000..4f7c894
--- /dev/null
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -0,0 +1,162 @@
+The Linux WatchDog Timer Driver Core kernel API.
+===============================================
+Last reviewed: 22-Jul-2011
+
+Wim Van Sebroeck <wim@iguana.be>
+
+Introduction
+------------
+This document does not describe what a WatchDog Timer (WDT) Driver or Device is.
+It also does not describe the API which can be used by user space to communicate
+with a WatchDog Timer. If you want to know this then please read the following
+file: Documentation/watchdog/watchdog-api.txt .
+
+So what does this document describe? It describes the API that can be used by
+WatchDog Timer Drivers that want to use the WatchDog Timer Driver Core
+Framework. This framework provides all interfacing towards user space so that
+the same code does not have to be reproduced each time. This also means that
+a watchdog timer driver then only needs to provide the different routines
+(operations) that control the watchdog timer (WDT).
+
+The API
+-------
+Each watchdog timer driver that wants to use the WatchDog Timer Driver Core
+must #include <linux/watchdog.h> (you would have to do this anyway when
+writing a watchdog device driver). This include file contains following
+register/unregister routines:
+
+extern int watchdog_register_device(struct watchdog_device *);
+extern void watchdog_unregister_device(struct watchdog_device *);
+
+The watchdog_register_device routine registers a watchdog timer device.
+The parameter of this routine is a pointer to a watchdog_device structure.
+This routine returns zero on success and a negative errno code for failure.
+
+The watchdog_unregister_device routine deregisters a registered watchdog timer
+device. The parameter of this routine is the pointer to the registered
+watchdog_device structure.
+
+The watchdog device structure looks like this:
+
+struct watchdog_device {
+	const struct watchdog_info *info;
+	const struct watchdog_ops *ops;
+	unsigned int bootstatus;
+	unsigned int timeout;
+	unsigned int min_timeout;
+	unsigned int max_timeout;
+	void *driver_data;
+	unsigned long status;
+};
+
+It contains following fields:
+* info: a pointer to a watchdog_info structure. This structure gives some
+  additional information about the watchdog timer itself. (Like it's unique name)
+* ops: a pointer to the list of watchdog operations that the watchdog supports.
+* timeout: the watchdog timer's timeout value (in seconds).
+* min_timeout: the watchdog timer's minimum timeout value (in seconds).
+* max_timeout: the watchdog timer's maximum timeout value (in seconds).
+* bootstatus: status of the device after booting (reported with watchdog
+  WDIOF_* status bits).
+* driver_data: a pointer to the drivers private data of a watchdog device.
+  This data should only be accessed via the watchdog_set_drvadata and
+  watchdog_get_drvdata routines.
+* status: this field contains a number of status bits that give extra
+  information about the status of the device (Like: is the watchdog timer
+  running/active, is the nowayout bit set, is the device opened via
+  the /dev/watchdog interface or not, ...).
+
+The list of watchdog operations is defined as:
+
+struct watchdog_ops {
+	struct module *owner;
+	/* mandatory operations */
+	int (*start)(struct watchdog_device *);
+	int (*stop)(struct watchdog_device *);
+	/* optional operations */
+	int (*ping)(struct watchdog_device *);
+	unsigned int (*status)(struct watchdog_device *);
+	int (*set_timeout)(struct watchdog_device *, unsigned int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
+};
+
+It is important that you first define the module owner of the watchdog timer
+driver's operations. This module owner will be used to lock the module when
+the watchdog is active. (This to avoid a system crash when you unload the
+module and /dev/watchdog is still open).
+Some operations are mandatory and some are optional. The mandatory operations
+are:
+* start: this is a pointer to the routine that starts the watchdog timer
+  device.
+  The routine needs a pointer to the watchdog timer device structure as a
+  parameter. It returns zero on success or a negative errno code for failure.
+* stop: with this routine the watchdog timer device is being stopped.
+  The routine needs a pointer to the watchdog timer device structure as a
+  parameter. It returns zero on success or a negative errno code for failure.
+  Some watchdog timer hardware can only be started and not be stopped. The
+  driver supporting this hardware needs to make sure that a start and stop
+  routine is being provided. This can be done by using a timer in the driver
+  that regularly sends a keepalive ping to the watchdog timer hardware.
+
+Not all watchdog timer hardware supports the same functionality. That's why
+all other routines/operations are optional. They only need to be provided if
+they are supported. These optional routines/operations are:
+* ping: this is the routine that sends a keepalive ping to the watchdog timer
+  hardware.
+  The routine needs a pointer to the watchdog timer device structure as a
+  parameter. It returns zero on success or a negative errno code for failure.
+  Most hardware that does not support this as a separate function uses the
+  start function to restart the watchdog timer hardware. And that's also what
+  the watchdog timer driver core does: to send a keepalive ping to the watchdog
+  timer hardware it will either use the ping operation (when available) or the
+  start operation (when the ping operation is not available).
+  (Note: the WDIOC_KEEPALIVE ioctl call will only be active when the
+  WDIOF_KEEPALIVEPING bit has been set in the option field on the watchdog's
+  info structure).
+* status: this routine checks the status of the watchdog timer device. The
+  status of the device is reported with watchdog WDIOF_* status flags/bits.
+* set_timeout: this routine checks and changes the timeout of the watchdog
+  timer device. It returns 0 on success, -EINVAL for "parameter out of range"
+  and -EIO for "could not write value to the watchdog". On success the timeout
+  value of the watchdog_device will be changed to the value that was just used
+  to re-program the watchdog timer device.
+  (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
+  watchdog's info structure).
+* ioctl: if this routine is present then it will be called first before we do
+  our own internal ioctl call handling. This routine should return -ENOIOCTLCMD
+  if a command is not supported. The parameters that are passed to the ioctl
+  call are: watchdog_device, cmd and arg.
+
+The status bits should (preferably) be set with the set_bit and clear_bit alike
+bit-operations. The status bits that are defined are:
+* WDOG_ACTIVE: this status bit indicates whether or not a watchdog timer device
+  is active or not. When the watchdog is active after booting, then you should
+  set this status bit (Note: when you register the watchdog timer device with
+  this bit set, then opening /dev/watchdog will skip the start operation)
+* WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
+  was opened via /dev/watchdog.
+  (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_ALLOW_RELEASE: this bit stores whether or not the magic close character
+  has been sent (so that we can support the magic close feature).
+  (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
+  If this bit is set then the watchdog timer will not be able to stop.
+
+Note: The WatchDog Timer Driver Core supports the magic close feature and
+the nowayout feature. To use the magic close feature you must set the
+WDIOF_MAGICCLOSE bit in the options field of the watchdog's info structure.
+The nowayout feature will overrule the magic close feature.
+
+To get or set driver specific data the following two helper functions should be
+used:
+
+static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
+static inline void *watchdog_get_drvdata(struct watchdog_device *wdd)
+
+The watchdog_set_drvdata function allows you to add driver specific data. The
+arguments of this function are the watchdog device where you want to add the
+driver specific data to and a pointer to the data itself.
+
+The watchdog_get_drvdata function allows you to retrieve driver specific data.
+The argument of this function is the watchdog device where you want to retrieve
+data from. The function retruns the pointer to the driver specific data.
diff --git a/arch/arm/mach-at91/include/mach/at91_wdt.h b/arch/arm/mach-at91/include/mach/at91_wdt.h
deleted file mode 100644
index fecc2e9..0000000
--- a/arch/arm/mach-at91/include/mach/at91_wdt.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91_wdt.h
- *
- * Copyright (C) 2007 Andrew Victor
- * Copyright (C) 2007 Atmel Corporation.
- *
- * Watchdog Timer (WDT) - System peripherals regsters.
- * Based on AT91SAM9261 datasheet revision D.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_WDT_H
-#define AT91_WDT_H
-
-#define AT91_WDT_CR		(AT91_WDT + 0x00)	/* Watchdog Control Register */
-#define		AT91_WDT_WDRSTT		(1    << 0)		/* Restart */
-#define		AT91_WDT_KEY		(0xa5 << 24)		/* KEY Password */
-
-#define AT91_WDT_MR		(AT91_WDT + 0x04)	/* Watchdog Mode Register */
-#define		AT91_WDT_WDV		(0xfff << 0)		/* Counter Value */
-#define		AT91_WDT_WDFIEN		(1     << 12)		/* Fault Interrupt Enable */
-#define		AT91_WDT_WDRSTEN	(1     << 13)		/* Reset Processor */
-#define		AT91_WDT_WDRPROC	(1     << 14)		/* Timer Restart */
-#define		AT91_WDT_WDDIS		(1     << 15)		/* Watchdog Disable */
-#define		AT91_WDT_WDD		(0xfff << 16)		/* Delta Value */
-#define		AT91_WDT_WDDBGHLT	(1     << 28)		/* Debug Halt */
-#define		AT91_WDT_WDIDLEHLT	(1     << 29)		/* Idle Halt */
-
-#define AT91_WDT_SR		(AT91_WDT + 0x08)	/* Watchdog Status Register */
-#define		AT91_WDT_WDUNF		(1 << 0)		/* Watchdog Underflow */
-#define		AT91_WDT_WDERR		(1 << 1)		/* Watchdog Error */
-
-#endif
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 21d816e..f441726 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -28,6 +28,17 @@ menuconfig WATCHDOG
 
 if WATCHDOG
 
+config WATCHDOG_CORE
+	bool "WatchDog Timer Driver Core"
+	---help---
+	  Say Y here if you want to use the new watchdog timer driver core.
+	  This driver provides a framework for all watchdog timer drivers
+	  and gives them the /dev/watchdog interface (and later also the
+	  sysfs interface).
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called watchdog.
+
 config WATCHDOG_NOWAYOUT
 	bool "Disable watchdog shutdown on close"
 	help
@@ -186,6 +197,15 @@ config SA1100_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called sa1100_wdt.
 
+config DW_WATCHDOG
+	tristate "Synopsys DesignWare watchdog"
+	depends on ARM && HAVE_CLK
+	help
+	  Say Y here if to include support for the Synopsys DesignWare
+	  watchdog timer found in many ARM chips.
+	  To compile this driver as a module, choose M here: the
+	  module will be called dw_wdt.
+
 config MPCORE_WATCHDOG
 	tristate "MPcore watchdog"
 	depends on HAVE_ARM_TWD
@@ -321,7 +341,7 @@ config MAX63XX_WATCHDOG
 
 config IMX2_WDT
 	tristate "IMX2+ Watchdog"
-	depends on ARCH_MX2 || ARCH_MX25 || ARCH_MX3 || ARCH_MX5
+	depends on IMX_HAVE_PLATFORM_IMX2_WDT
 	help
 	  This is the driver for the hardware watchdog
 	  on the Freescale IMX2 and later processors.
@@ -879,6 +899,20 @@ config M54xx_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called m54xx_wdt.
 
+# MicroBlaze Architecture
+
+config XILINX_WATCHDOG
+	tristate "Xilinx Watchdog timer"
+	depends on MICROBLAZE
+	---help---
+	  Watchdog driver for the xps_timebase_wdt ip core.
+
+	  IMPORTANT: The xps_timebase_wdt parent must have the property
+	  "clock-frequency" at device tree.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called of_xilinx_wdt.
+
 # MIPS Architecture
 
 config ATH79_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ed26f70..55bd574 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -2,6 +2,10 @@
 # Makefile for the WatchDog device drivers.
 #
 
+# The WatchDog Timer Driver Core.
+watchdog-objs	+= watchdog_core.o watchdog_dev.o
+obj-$(CONFIG_WATCHDOG_CORE)	+= watchdog.o
+
 # Only one watchdog can succeed. We probe the ISA/PCI/USB based
 # watchdog-cards first, then the architecture specific watchdog
 # drivers and then the architecture independent "softdog" driver.
@@ -37,6 +41,7 @@ obj-$(CONFIG_IXP4XX_WATCHDOG) += ixp4xx_wdt.o
 obj-$(CONFIG_KS8695_WATCHDOG) += ks8695_wdt.o
 obj-$(CONFIG_S3C2410_WATCHDOG) += s3c2410_wdt.o
 obj-$(CONFIG_SA1100_WATCHDOG) += sa1100_wdt.o
+obj-$(CONFIG_DW_WATCHDOG) += dw_wdt.o
 obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
@@ -109,6 +114,9 @@ obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
 # M68K Architecture
 obj-$(CONFIG_M54xx_WATCHDOG) += m54xx_wdt.o
 
+# MicroBlaze Architecture
+obj-$(CONFIG_XILINX_WATCHDOG) += of_xilinx_wdt.o
+
 # MIPS Architecture
 obj-$(CONFIG_ATH79_WDT) += ath79_wdt.o
 obj-$(CONFIG_BCM47XX_WDT) += bcm47xx_wdt.o
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index eac2602..87445b2 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -31,7 +31,7 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 
-#include <mach/at91_wdt.h>
+#include "at91sam9_wdt.h"
 
 #define DRV_NAME "AT91SAM9 Watchdog"
 
@@ -284,27 +284,8 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
 	return res;
 }
 
-#ifdef CONFIG_PM
-
-static int at91wdt_suspend(struct platform_device *pdev, pm_message_t message)
-{
-	return 0;
-}
-
-static int at91wdt_resume(struct platform_device *pdev)
-{
-	return 0;
-}
-
-#else
-#define at91wdt_suspend	NULL
-#define at91wdt_resume	NULL
-#endif
-
 static struct platform_driver at91wdt_driver = {
 	.remove		= __exit_p(at91wdt_remove),
-	.suspend	= at91wdt_suspend,
-	.resume		= at91wdt_resume,
 	.driver		= {
 		.name	= "at91_wdt",
 		.owner	= THIS_MODULE,
diff --git a/drivers/watchdog/at91sam9_wdt.h b/drivers/watchdog/at91sam9_wdt.h
new file mode 100644
index 0000000..757f9ca
--- /dev/null
+++ b/drivers/watchdog/at91sam9_wdt.h
@@ -0,0 +1,37 @@
+/*
+ * drivers/watchdog/at91sam9_wdt.h
+ *
+ * Copyright (C) 2007 Andrew Victor
+ * Copyright (C) 2007 Atmel Corporation.
+ *
+ * Watchdog Timer (WDT) - System peripherals regsters.
+ * Based on AT91SAM9261 datasheet revision D.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef AT91_WDT_H
+#define AT91_WDT_H
+
+#define AT91_WDT_CR		(AT91_WDT + 0x00)	/* Watchdog Control Register */
+#define		AT91_WDT_WDRSTT		(1    << 0)		/* Restart */
+#define		AT91_WDT_KEY		(0xa5 << 24)		/* KEY Password */
+
+#define AT91_WDT_MR		(AT91_WDT + 0x04)	/* Watchdog Mode Register */
+#define		AT91_WDT_WDV		(0xfff << 0)		/* Counter Value */
+#define		AT91_WDT_WDFIEN		(1     << 12)		/* Fault Interrupt Enable */
+#define		AT91_WDT_WDRSTEN	(1     << 13)		/* Reset Processor */
+#define		AT91_WDT_WDRPROC	(1     << 14)		/* Timer Restart */
+#define		AT91_WDT_WDDIS		(1     << 15)		/* Watchdog Disable */
+#define		AT91_WDT_WDD		(0xfff << 16)		/* Delta Value */
+#define		AT91_WDT_WDDBGHLT	(1     << 28)		/* Debug Halt */
+#define		AT91_WDT_WDIDLEHLT	(1     << 29)		/* Idle Halt */
+
+#define AT91_WDT_SR		(AT91_WDT + 0x08)	/* Watchdog Status Register */
+#define		AT91_WDT_WDUNF		(1 << 0)		/* Watchdog Underflow */
+#define		AT91_WDT_WDERR		(1 << 1)		/* Watchdog Error */
+
+#endif
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
new file mode 100644
index 0000000..f10f8c0
--- /dev/null
+++ b/drivers/watchdog/dw_wdt.c
@@ -0,0 +1,376 @@
+/*
+ * Copyright 2010-2011 Picochip Ltd., Jamie Iles
+ * http://www.picochip.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This file implements a driver for the Synopsys DesignWare watchdog device
+ * in the many ARM subsystems. The watchdog has 16 different timeout periods
+ * and these are a function of the input clock frequency.
+ *
+ * The DesignWare watchdog cannot be stopped once it has been started so we
+ * use a software timer to implement a ping that will keep the watchdog alive.
+ * If we receive an expected close for the watchdog then we keep the timer
+ * running, otherwise the timer is stopped and the watchdog will expire.
+ */
+#define pr_fmt(fmt) "dw_wdt: " fmt
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+#define WDOG_CONTROL_REG_OFFSET		    0x00
+#define WDOG_CONTROL_REG_WDT_EN_MASK	    0x01
+#define WDOG_TIMEOUT_RANGE_REG_OFFSET	    0x04
+#define WDOG_CURRENT_COUNT_REG_OFFSET	    0x08
+#define WDOG_COUNTER_RESTART_REG_OFFSET     0x0c
+#define WDOG_COUNTER_RESTART_KICK_VALUE	    0x76
+
+/* The maximum TOP (timeout period) value that can be set in the watchdog. */
+#define DW_WDT_MAX_TOP		15
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+		 "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define WDT_TIMEOUT		(HZ / 2)
+
+static struct {
+	spinlock_t		lock;
+	void __iomem		*regs;
+	struct clk		*clk;
+	unsigned long		in_use;
+	unsigned long		next_heartbeat;
+	struct timer_list	timer;
+	int			expect_close;
+} dw_wdt;
+
+static inline int dw_wdt_is_enabled(void)
+{
+	return readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET) &
+		WDOG_CONTROL_REG_WDT_EN_MASK;
+}
+
+static inline int dw_wdt_top_in_seconds(unsigned top)
+{
+	/*
+	 * There are 16 possible timeout values in 0..15 where the number of
+	 * cycles is 2 ^ (16 + i) and the watchdog counts down.
+	 */
+	return (1 << (16 + top)) / clk_get_rate(dw_wdt.clk);
+}
+
+static int dw_wdt_get_top(void)
+{
+	int top = readl(dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET) & 0xF;
+
+	return dw_wdt_top_in_seconds(top);
+}
+
+static inline void dw_wdt_set_next_heartbeat(void)
+{
+	dw_wdt.next_heartbeat = jiffies + dw_wdt_get_top() * HZ;
+}
+
+static int dw_wdt_set_top(unsigned top_s)
+{
+	int i, top_val = DW_WDT_MAX_TOP;
+
+	/*
+	 * Iterate over the timeout values until we find the closest match. We
+	 * always look for >=.
+	 */
+	for (i = 0; i <= DW_WDT_MAX_TOP; ++i)
+		if (dw_wdt_top_in_seconds(i) >= top_s) {
+			top_val = i;
+			break;
+		}
+
+	/* Set the new value in the watchdog. */
+	writel(top_val, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
+
+	dw_wdt_set_next_heartbeat();
+
+	return dw_wdt_top_in_seconds(top_val);
+}
+
+static void dw_wdt_keepalive(void)
+{
+	writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
+	       WDOG_COUNTER_RESTART_REG_OFFSET);
+}
+
+static void dw_wdt_ping(unsigned long data)
+{
+	if (time_before(jiffies, dw_wdt.next_heartbeat) ||
+	    (!nowayout && !dw_wdt.in_use)) {
+		dw_wdt_keepalive();
+		mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
+	} else
+		pr_crit("keepalive missed, machine will reset\n");
+}
+
+static int dw_wdt_open(struct inode *inode, struct file *filp)
+{
+	if (test_and_set_bit(0, &dw_wdt.in_use))
+		return -EBUSY;
+
+	/* Make sure we don't get unloaded. */
+	__module_get(THIS_MODULE);
+
+	spin_lock(&dw_wdt.lock);
+	if (!dw_wdt_is_enabled()) {
+		/*
+		 * The watchdog is not currently enabled. Set the timeout to
+		 * the maximum and then start it.
+		 */
+		dw_wdt_set_top(DW_WDT_MAX_TOP);
+		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
+		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
+	}
+
+	dw_wdt_set_next_heartbeat();
+
+	spin_unlock(&dw_wdt.lock);
+
+	return nonseekable_open(inode, filp);
+}
+
+ssize_t dw_wdt_write(struct file *filp, const char __user *buf, size_t len,
+		     loff_t *offset)
+{
+	if (!len)
+		return 0;
+
+	if (!nowayout) {
+		size_t i;
+
+		dw_wdt.expect_close = 0;
+
+		for (i = 0; i < len; ++i) {
+			char c;
+
+			if (get_user(c, buf + i))
+				return -EFAULT;
+
+			if (c == 'V') {
+				dw_wdt.expect_close = 1;
+				break;
+			}
+		}
+	}
+
+	dw_wdt_set_next_heartbeat();
+	mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
+
+	return len;
+}
+
+static u32 dw_wdt_time_left(void)
+{
+	return readl(dw_wdt.regs + WDOG_CURRENT_COUNT_REG_OFFSET) /
+		clk_get_rate(dw_wdt.clk);
+}
+
+static const struct watchdog_info dw_wdt_ident = {
+	.options	= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+			  WDIOF_MAGICCLOSE,
+	.identity	= "Synopsys DesignWare Watchdog",
+};
+
+static long dw_wdt_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	unsigned long val;
+	int timeout;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info *)arg, &dw_wdt_ident,
+				    sizeof(dw_wdt_ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+
+	case WDIOC_KEEPALIVE:
+		dw_wdt_set_next_heartbeat();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(val, (int __user *)arg))
+			return -EFAULT;
+		timeout = dw_wdt_set_top(val);
+		return put_user(timeout , (int __user *)arg);
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(dw_wdt_get_top(), (int __user *)arg);
+
+	case WDIOC_GETTIMELEFT:
+		/* Get the time left until expiry. */
+		if (get_user(val, (int __user *)arg))
+			return -EFAULT;
+		return put_user(dw_wdt_time_left(), (int __user *)arg);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int dw_wdt_release(struct inode *inode, struct file *filp)
+{
+	clear_bit(0, &dw_wdt.in_use);
+
+	if (!dw_wdt.expect_close) {
+		del_timer(&dw_wdt.timer);
+
+		if (!nowayout)
+			pr_crit("unexpected close, system will reboot soon\n");
+		else
+			pr_crit("watchdog cannot be disabled, system will reboot soon\n");
+	}
+
+	dw_wdt.expect_close = 0;
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int dw_wdt_suspend(struct device *dev)
+{
+	clk_disable(dw_wdt.clk);
+
+	return 0;
+}
+
+static int dw_wdt_resume(struct device *dev)
+{
+	int err = clk_enable(dw_wdt.clk);
+
+	if (err)
+		return err;
+
+	dw_wdt_keepalive();
+
+	return 0;
+}
+
+static const struct dev_pm_ops dw_wdt_pm_ops = {
+	.suspend	= dw_wdt_suspend,
+	.resume		= dw_wdt_resume,
+};
+#endif /* CONFIG_PM */
+
+static const struct file_operations wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= dw_wdt_open,
+	.write		= dw_wdt_write,
+	.unlocked_ioctl	= dw_wdt_ioctl,
+	.release	= dw_wdt_release
+};
+
+static struct miscdevice dw_wdt_miscdev = {
+	.fops		= &wdt_fops,
+	.name		= "watchdog",
+	.minor		= WATCHDOG_MINOR,
+};
+
+static int __devinit dw_wdt_drv_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!mem)
+		return -EINVAL;
+
+	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
+				     "dw_wdt"))
+		return -ENOMEM;
+
+	dw_wdt.regs = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!dw_wdt.regs)
+		return -ENOMEM;
+
+	dw_wdt.clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dw_wdt.clk))
+		return PTR_ERR(dw_wdt.clk);
+
+	ret = clk_enable(dw_wdt.clk);
+	if (ret)
+		goto out_put_clk;
+
+	spin_lock_init(&dw_wdt.lock);
+
+	ret = misc_register(&dw_wdt_miscdev);
+	if (ret)
+		goto out_disable_clk;
+
+	dw_wdt_set_next_heartbeat();
+	setup_timer(&dw_wdt.timer, dw_wdt_ping, 0);
+	mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
+
+	return 0;
+
+out_disable_clk:
+	clk_disable(dw_wdt.clk);
+out_put_clk:
+	clk_put(dw_wdt.clk);
+
+	return ret;
+}
+
+static int __devexit dw_wdt_drv_remove(struct platform_device *pdev)
+{
+	misc_deregister(&dw_wdt_miscdev);
+
+	clk_disable(dw_wdt.clk);
+	clk_put(dw_wdt.clk);
+
+	return 0;
+}
+
+static struct platform_driver dw_wdt_driver = {
+	.probe		= dw_wdt_drv_probe,
+	.remove		= __devexit_p(dw_wdt_drv_remove),
+	.driver		= {
+		.name	= "dw_wdt",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &dw_wdt_pm_ops,
+#endif /* CONFIG_PM */
+	},
+};
+
+static int __init dw_wdt_watchdog_init(void)
+{
+	return platform_driver_register(&dw_wdt_driver);
+}
+module_init(dw_wdt_watchdog_init);
+
+static void __exit dw_wdt_watchdog_exit(void)
+{
+	platform_driver_unregister(&dw_wdt_driver);
+}
+module_exit(dw_wdt_watchdog_exit);
+
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Synopsys DesignWare Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 8cb2685..410fba4 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -36,7 +36,7 @@
 #include <asm/cacheflush.h>
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 
-#define HPWDT_VERSION			"1.2.0"
+#define HPWDT_VERSION			"1.3.0"
 #define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
 #define TICKS_TO_SECS(ticks)		((ticks) * 128 / 1000)
 #define HPWDT_MAX_TIMER			TICKS_TO_SECS(65535)
@@ -87,6 +87,19 @@ struct smbios_cru64_info {
 };
 #define SMBIOS_CRU64_INFORMATION	212
 
+/* type 219 */
+struct smbios_proliant_info {
+	u8 type;
+	u8 byte_length;
+	u16 handle;
+	u32 power_features;
+	u32 omega_features;
+	u32 reserved;
+	u32 misc_features;
+};
+#define SMBIOS_ICRU_INFORMATION		219
+
+
 struct cmn_registers {
 	union {
 		struct {
@@ -132,6 +145,7 @@ struct cmn_registers {
 static unsigned int hpwdt_nmi_decoding;
 static unsigned int allow_kdump;
 static unsigned int priority;		/* hpwdt at end of die_notify list */
+static unsigned int is_icru;
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
 static struct cmn_registers cmn_regs;
@@ -476,19 +490,22 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		goto out;
 
 	spin_lock_irqsave(&rom_lock, rom_pl);
-	if (!die_nmi_called)
+	if (!die_nmi_called && !is_icru)
 		asminline_call(&cmn_regs, cru_rom_addr);
 	die_nmi_called = 1;
 	spin_unlock_irqrestore(&rom_lock, rom_pl);
-	if (cmn_regs.u1.ral == 0) {
-		printk(KERN_WARNING "hpwdt: An NMI occurred, "
-			"but unable to determine source.\n");
-	} else {
-		if (allow_kdump)
-			hpwdt_stop();
-		panic("An NMI occurred, please see the Integrated "
-			"Management Log for details.\n");
+	if (!is_icru) {
+		if (cmn_regs.u1.ral == 0) {
+			printk(KERN_WARNING "hpwdt: An NMI occurred, "
+				"but unable to determine source.\n");
+		}
 	}
+
+	if (allow_kdump)
+		hpwdt_stop();
+	panic("An NMI occurred, please see the Integrated "
+		"Management Log for details.\n");
+
 out:
 	return NOTIFY_OK;
 }
@@ -659,30 +676,63 @@ static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 }
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+/*
+ *	dmi_find_icru
+ *
+ *	Routine Description:
+ *	This function checks whether or not we are on an iCRU-based server.
+ *	This check is independent of architecture and needs to be made for
+ *	any ProLiant system.
+ */
+static void __devinit dmi_find_icru(const struct dmi_header *dm, void *dummy)
+{
+	struct smbios_proliant_info *smbios_proliant_ptr;
+
+	if (dm->type == SMBIOS_ICRU_INFORMATION) {
+		smbios_proliant_ptr = (struct smbios_proliant_info *) dm;
+		if (smbios_proliant_ptr->misc_features & 0x01)
+			is_icru = 1;
+	}
+}
+
 static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 {
 	int retval;
 
 	/*
-	 * We need to map the ROM to get the CRU service.
-	 * For 32 bit Operating Systems we need to go through the 32 Bit
-	 * BIOS Service Directory
-	 * For 64 bit Operating Systems we get that service through SMBIOS.
+	 * On typical CRU-based systems we need to map that service in
+	 * the BIOS. For 32 bit Operating Systems we need to go through
+	 * the 32 Bit BIOS Service Directory. For 64 bit Operating
+	 * Systems we get that service through SMBIOS.
+	 *
+	 * On systems that support the new iCRU service all we need to
+	 * do is call dmi_walk to get the supported flag value and skip
+	 * the old cru detect code.
 	 */
-	retval = detect_cru_service();
-	if (retval < 0) {
-		dev_warn(&dev->dev,
-			"Unable to detect the %d Bit CRU Service.\n",
-			HPWDT_ARCH);
-		return retval;
-	}
+	dmi_walk(dmi_find_icru, NULL);
+	if (!is_icru) {
+
+		/*
+		* We need to map the ROM to get the CRU service.
+		* For 32 bit Operating Systems we need to go through the 32 Bit
+		* BIOS Service Directory
+		* For 64 bit Operating Systems we get that service through SMBIOS.
+		*/
+		retval = detect_cru_service();
+		if (retval < 0) {
+			dev_warn(&dev->dev,
+				"Unable to detect the %d Bit CRU Service.\n",
+				HPWDT_ARCH);
+			return retval;
+		}
 
-	/*
-	 * We know this is the only CRU call we need to make so lets keep as
-	 * few instructions as possible once the NMI comes in.
-	 */
-	cmn_regs.u1.rah = 0x0D;
-	cmn_regs.u1.ral = 0x02;
+		/*
+		* We know this is the only CRU call we need to make so lets keep as
+		* few instructions as possible once the NMI comes in.
+		*/
+		cmn_regs.u1.rah = 0x0D;
+		cmn_regs.u1.ral = 0x02;
+	}
 
 	/*
 	 * If the priority is set to 1, then we will be put first on the
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 5fd020d..751a591 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -120,72 +120,12 @@ enum iTCO_chipsets {
 	TCO_3420,	/* 3420 */
 	TCO_3450,	/* 3450 */
 	TCO_EP80579,	/* EP80579 */
-	TCO_CPT1,	/* Cougar Point */
-	TCO_CPT2,	/* Cougar Point Desktop */
-	TCO_CPT3,	/* Cougar Point Mobile */
-	TCO_CPT4,	/* Cougar Point */
-	TCO_CPT5,	/* Cougar Point */
-	TCO_CPT6,	/* Cougar Point */
-	TCO_CPT7,	/* Cougar Point */
-	TCO_CPT8,	/* Cougar Point */
-	TCO_CPT9,	/* Cougar Point */
-	TCO_CPT10,	/* Cougar Point */
-	TCO_CPT11,	/* Cougar Point */
-	TCO_CPT12,	/* Cougar Point */
-	TCO_CPT13,	/* Cougar Point */
-	TCO_CPT14,	/* Cougar Point */
-	TCO_CPT15,	/* Cougar Point */
-	TCO_CPT16,	/* Cougar Point */
-	TCO_CPT17,	/* Cougar Point */
-	TCO_CPT18,	/* Cougar Point */
-	TCO_CPT19,	/* Cougar Point */
-	TCO_CPT20,	/* Cougar Point */
-	TCO_CPT21,	/* Cougar Point */
-	TCO_CPT22,	/* Cougar Point */
-	TCO_CPT23,	/* Cougar Point */
-	TCO_CPT24,	/* Cougar Point */
-	TCO_CPT25,	/* Cougar Point */
-	TCO_CPT26,	/* Cougar Point */
-	TCO_CPT27,	/* Cougar Point */
-	TCO_CPT28,	/* Cougar Point */
-	TCO_CPT29,	/* Cougar Point */
-	TCO_CPT30,	/* Cougar Point */
-	TCO_CPT31,	/* Cougar Point */
-	TCO_PBG1,	/* Patsburg */
-	TCO_PBG2,	/* Patsburg */
+	TCO_CPT,	/* Cougar Point */
+	TCO_CPTD,	/* Cougar Point Desktop */
+	TCO_CPTM,	/* Cougar Point Mobile */
+	TCO_PBG,	/* Patsburg */
 	TCO_DH89XXCC,	/* DH89xxCC */
-	TCO_PPT0,	/* Panther Point */
-	TCO_PPT1,	/* Panther Point */
-	TCO_PPT2,	/* Panther Point */
-	TCO_PPT3,	/* Panther Point */
-	TCO_PPT4,	/* Panther Point */
-	TCO_PPT5,	/* Panther Point */
-	TCO_PPT6,	/* Panther Point */
-	TCO_PPT7,	/* Panther Point */
-	TCO_PPT8,	/* Panther Point */
-	TCO_PPT9,	/* Panther Point */
-	TCO_PPT10,	/* Panther Point */
-	TCO_PPT11,	/* Panther Point */
-	TCO_PPT12,	/* Panther Point */
-	TCO_PPT13,	/* Panther Point */
-	TCO_PPT14,	/* Panther Point */
-	TCO_PPT15,	/* Panther Point */
-	TCO_PPT16,	/* Panther Point */
-	TCO_PPT17,	/* Panther Point */
-	TCO_PPT18,	/* Panther Point */
-	TCO_PPT19,	/* Panther Point */
-	TCO_PPT20,	/* Panther Point */
-	TCO_PPT21,	/* Panther Point */
-	TCO_PPT22,	/* Panther Point */
-	TCO_PPT23,	/* Panther Point */
-	TCO_PPT24,	/* Panther Point */
-	TCO_PPT25,	/* Panther Point */
-	TCO_PPT26,	/* Panther Point */
-	TCO_PPT27,	/* Panther Point */
-	TCO_PPT28,	/* Panther Point */
-	TCO_PPT29,	/* Panther Point */
-	TCO_PPT30,	/* Panther Point */
-	TCO_PPT31,	/* Panther Point */
+	TCO_PPT,	/* Panther Point */
 };
 
 static struct {
@@ -244,83 +184,14 @@ static struct {
 	{"3450", 2},
 	{"EP80579", 2},
 	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Patsburg", 2},
+	{"Cougar Point Desktop", 2},
+	{"Cougar Point Mobile", 2},
 	{"Patsburg", 2},
 	{"DH89xxCC", 2},
 	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
 	{NULL, 0}
 };
 
-#define ITCO_PCI_DEVICE(dev, data) \
-	.vendor = PCI_VENDOR_ID_INTEL,	\
-	.device = dev,			\
-	.subvendor = PCI_ANY_ID,	\
-	.subdevice = PCI_ANY_ID,	\
-	.class = 0,			\
-	.class_mask = 0,		\
-	.driver_data = data
-
 /*
  * This data only exists for exporting the supported PCI ids
  * via MODULE_DEVICE_TABLE.  We do not actually register a
@@ -328,138 +199,138 @@ static struct {
  * functions that probably will be registered by other drivers.
  */
 static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB_1,		TCO_6300ESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2673,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2674,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2675,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2676,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2677,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2678,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2679,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267a,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267b,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267c,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267d,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267e,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30,		TCO_ICH7DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
-	{ ITCO_PCI_DEVICE(0x27bc,				TCO_NM10)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
-	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
-	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,		TCO_ICH9DO)},
-	{ ITCO_PCI_DEVICE(0x2919,				TCO_ICH9M)},
-	{ ITCO_PCI_DEVICE(0x2917,				TCO_ICH9ME)},
-	{ ITCO_PCI_DEVICE(0x3a18,				TCO_ICH10)},
-	{ ITCO_PCI_DEVICE(0x3a16,				TCO_ICH10R)},
-	{ ITCO_PCI_DEVICE(0x3a1a,				TCO_ICH10D)},
-	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
-	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
-	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
-	{ ITCO_PCI_DEVICE(0x3b02,				TCO_P55)},
-	{ ITCO_PCI_DEVICE(0x3b03,				TCO_PM55)},
-	{ ITCO_PCI_DEVICE(0x3b06,				TCO_H55)},
-	{ ITCO_PCI_DEVICE(0x3b07,				TCO_QM57)},
-	{ ITCO_PCI_DEVICE(0x3b08,				TCO_H57)},
-	{ ITCO_PCI_DEVICE(0x3b09,				TCO_HM55)},
-	{ ITCO_PCI_DEVICE(0x3b0a,				TCO_Q57)},
-	{ ITCO_PCI_DEVICE(0x3b0b,				TCO_HM57)},
-	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
-	{ ITCO_PCI_DEVICE(0x3b0f,				TCO_QS57)},
-	{ ITCO_PCI_DEVICE(0x3b12,				TCO_3400)},
-	{ ITCO_PCI_DEVICE(0x3b14,				TCO_3420)},
-	{ ITCO_PCI_DEVICE(0x3b16,				TCO_3450)},
-	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
-	{ ITCO_PCI_DEVICE(0x1c41,				TCO_CPT1)},
-	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPT2)},
-	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPT3)},
-	{ ITCO_PCI_DEVICE(0x1c44,				TCO_CPT4)},
-	{ ITCO_PCI_DEVICE(0x1c45,				TCO_CPT5)},
-	{ ITCO_PCI_DEVICE(0x1c46,				TCO_CPT6)},
-	{ ITCO_PCI_DEVICE(0x1c47,				TCO_CPT7)},
-	{ ITCO_PCI_DEVICE(0x1c48,				TCO_CPT8)},
-	{ ITCO_PCI_DEVICE(0x1c49,				TCO_CPT9)},
-	{ ITCO_PCI_DEVICE(0x1c4a,				TCO_CPT10)},
-	{ ITCO_PCI_DEVICE(0x1c4b,				TCO_CPT11)},
-	{ ITCO_PCI_DEVICE(0x1c4c,				TCO_CPT12)},
-	{ ITCO_PCI_DEVICE(0x1c4d,				TCO_CPT13)},
-	{ ITCO_PCI_DEVICE(0x1c4e,				TCO_CPT14)},
-	{ ITCO_PCI_DEVICE(0x1c4f,				TCO_CPT15)},
-	{ ITCO_PCI_DEVICE(0x1c50,				TCO_CPT16)},
-	{ ITCO_PCI_DEVICE(0x1c51,				TCO_CPT17)},
-	{ ITCO_PCI_DEVICE(0x1c52,				TCO_CPT18)},
-	{ ITCO_PCI_DEVICE(0x1c53,				TCO_CPT19)},
-	{ ITCO_PCI_DEVICE(0x1c54,				TCO_CPT20)},
-	{ ITCO_PCI_DEVICE(0x1c55,				TCO_CPT21)},
-	{ ITCO_PCI_DEVICE(0x1c56,				TCO_CPT22)},
-	{ ITCO_PCI_DEVICE(0x1c57,				TCO_CPT23)},
-	{ ITCO_PCI_DEVICE(0x1c58,				TCO_CPT24)},
-	{ ITCO_PCI_DEVICE(0x1c59,				TCO_CPT25)},
-	{ ITCO_PCI_DEVICE(0x1c5a,				TCO_CPT26)},
-	{ ITCO_PCI_DEVICE(0x1c5b,				TCO_CPT27)},
-	{ ITCO_PCI_DEVICE(0x1c5c,				TCO_CPT28)},
-	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
-	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
-	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
-	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
-	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
-	{ ITCO_PCI_DEVICE(0x2310,				TCO_DH89XXCC)},
-	{ ITCO_PCI_DEVICE(0x1e40,				TCO_PPT0)},
-	{ ITCO_PCI_DEVICE(0x1e41,				TCO_PPT1)},
-	{ ITCO_PCI_DEVICE(0x1e42,				TCO_PPT2)},
-	{ ITCO_PCI_DEVICE(0x1e43,				TCO_PPT3)},
-	{ ITCO_PCI_DEVICE(0x1e44,				TCO_PPT4)},
-	{ ITCO_PCI_DEVICE(0x1e45,				TCO_PPT5)},
-	{ ITCO_PCI_DEVICE(0x1e46,				TCO_PPT6)},
-	{ ITCO_PCI_DEVICE(0x1e47,				TCO_PPT7)},
-	{ ITCO_PCI_DEVICE(0x1e48,				TCO_PPT8)},
-	{ ITCO_PCI_DEVICE(0x1e49,				TCO_PPT9)},
-	{ ITCO_PCI_DEVICE(0x1e4a,				TCO_PPT10)},
-	{ ITCO_PCI_DEVICE(0x1e4b,				TCO_PPT11)},
-	{ ITCO_PCI_DEVICE(0x1e4c,				TCO_PPT12)},
-	{ ITCO_PCI_DEVICE(0x1e4d,				TCO_PPT13)},
-	{ ITCO_PCI_DEVICE(0x1e4e,				TCO_PPT14)},
-	{ ITCO_PCI_DEVICE(0x1e4f,				TCO_PPT15)},
-	{ ITCO_PCI_DEVICE(0x1e50,				TCO_PPT16)},
-	{ ITCO_PCI_DEVICE(0x1e51,				TCO_PPT17)},
-	{ ITCO_PCI_DEVICE(0x1e52,				TCO_PPT18)},
-	{ ITCO_PCI_DEVICE(0x1e53,				TCO_PPT19)},
-	{ ITCO_PCI_DEVICE(0x1e54,				TCO_PPT20)},
-	{ ITCO_PCI_DEVICE(0x1e55,				TCO_PPT21)},
-	{ ITCO_PCI_DEVICE(0x1e56,				TCO_PPT22)},
-	{ ITCO_PCI_DEVICE(0x1e57,				TCO_PPT23)},
-	{ ITCO_PCI_DEVICE(0x1e58,				TCO_PPT24)},
-	{ ITCO_PCI_DEVICE(0x1e59,				TCO_PPT25)},
-	{ ITCO_PCI_DEVICE(0x1e5a,				TCO_PPT26)},
-	{ ITCO_PCI_DEVICE(0x1e5b,				TCO_PPT27)},
-	{ ITCO_PCI_DEVICE(0x1e5c,				TCO_PPT28)},
-	{ ITCO_PCI_DEVICE(0x1e5d,				TCO_PPT29)},
-	{ ITCO_PCI_DEVICE(0x1e5e,				TCO_PPT30)},
-	{ ITCO_PCI_DEVICE(0x1e5f,				TCO_PPT31)},
+	{ PCI_VDEVICE(INTEL, 0x2410), TCO_ICH},
+	{ PCI_VDEVICE(INTEL, 0x2420), TCO_ICH0},
+	{ PCI_VDEVICE(INTEL, 0x2440), TCO_ICH2},
+	{ PCI_VDEVICE(INTEL, 0x244c), TCO_ICH2M},
+	{ PCI_VDEVICE(INTEL, 0x2480), TCO_ICH3},
+	{ PCI_VDEVICE(INTEL, 0x248c), TCO_ICH3M},
+	{ PCI_VDEVICE(INTEL, 0x24c0), TCO_ICH4},
+	{ PCI_VDEVICE(INTEL, 0x24cc), TCO_ICH4M},
+	{ PCI_VDEVICE(INTEL, 0x2450), TCO_CICH},
+	{ PCI_VDEVICE(INTEL, 0x24d0), TCO_ICH5},
+	{ PCI_VDEVICE(INTEL, 0x25a1), TCO_6300ESB},
+	{ PCI_VDEVICE(INTEL, 0x2640), TCO_ICH6},
+	{ PCI_VDEVICE(INTEL, 0x2641), TCO_ICH6M},
+	{ PCI_VDEVICE(INTEL, 0x2642), TCO_ICH6W},
+	{ PCI_VDEVICE(INTEL, 0x2670), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2671), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2672), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2673), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2674), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2675), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2676), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2677), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2678), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2679), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267a), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267b), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267c), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267d), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267e), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267f), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x27b8), TCO_ICH7},
+	{ PCI_VDEVICE(INTEL, 0x27b0), TCO_ICH7DH},
+	{ PCI_VDEVICE(INTEL, 0x27b9), TCO_ICH7M},
+	{ PCI_VDEVICE(INTEL, 0x27bd), TCO_ICH7MDH},
+	{ PCI_VDEVICE(INTEL, 0x27bc), TCO_NM10},
+	{ PCI_VDEVICE(INTEL, 0x2810), TCO_ICH8},
+	{ PCI_VDEVICE(INTEL, 0x2812), TCO_ICH8DH},
+	{ PCI_VDEVICE(INTEL, 0x2814), TCO_ICH8DO},
+	{ PCI_VDEVICE(INTEL, 0x2815), TCO_ICH8M},
+	{ PCI_VDEVICE(INTEL, 0x2811), TCO_ICH8ME},
+	{ PCI_VDEVICE(INTEL, 0x2918), TCO_ICH9},
+	{ PCI_VDEVICE(INTEL, 0x2916), TCO_ICH9R},
+	{ PCI_VDEVICE(INTEL, 0x2912), TCO_ICH9DH},
+	{ PCI_VDEVICE(INTEL, 0x2914), TCO_ICH9DO},
+	{ PCI_VDEVICE(INTEL, 0x2919), TCO_ICH9M},
+	{ PCI_VDEVICE(INTEL, 0x2917), TCO_ICH9ME},
+	{ PCI_VDEVICE(INTEL, 0x3a18), TCO_ICH10},
+	{ PCI_VDEVICE(INTEL, 0x3a16), TCO_ICH10R},
+	{ PCI_VDEVICE(INTEL, 0x3a1a), TCO_ICH10D},
+	{ PCI_VDEVICE(INTEL, 0x3a14), TCO_ICH10DO},
+	{ PCI_VDEVICE(INTEL, 0x3b00), TCO_PCH},
+	{ PCI_VDEVICE(INTEL, 0x3b01), TCO_PCHM},
+	{ PCI_VDEVICE(INTEL, 0x3b02), TCO_P55},
+	{ PCI_VDEVICE(INTEL, 0x3b03), TCO_PM55},
+	{ PCI_VDEVICE(INTEL, 0x3b06), TCO_H55},
+	{ PCI_VDEVICE(INTEL, 0x3b07), TCO_QM57},
+	{ PCI_VDEVICE(INTEL, 0x3b08), TCO_H57},
+	{ PCI_VDEVICE(INTEL, 0x3b09), TCO_HM55},
+	{ PCI_VDEVICE(INTEL, 0x3b0a), TCO_Q57},
+	{ PCI_VDEVICE(INTEL, 0x3b0b), TCO_HM57},
+	{ PCI_VDEVICE(INTEL, 0x3b0d), TCO_PCHMSFF},
+	{ PCI_VDEVICE(INTEL, 0x3b0f), TCO_QS57},
+	{ PCI_VDEVICE(INTEL, 0x3b12), TCO_3400},
+	{ PCI_VDEVICE(INTEL, 0x3b14), TCO_3420},
+	{ PCI_VDEVICE(INTEL, 0x3b16), TCO_3450},
+	{ PCI_VDEVICE(INTEL, 0x5031), TCO_EP80579},
+	{ PCI_VDEVICE(INTEL, 0x1c41), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c42), TCO_CPTD},
+	{ PCI_VDEVICE(INTEL, 0x1c43), TCO_CPTM},
+	{ PCI_VDEVICE(INTEL, 0x1c44), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c45), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c46), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c47), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c48), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c49), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4a), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4b), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4c), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4d), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4e), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4f), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c50), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c51), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c52), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c53), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c54), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c55), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c56), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c57), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c58), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c59), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5a), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5b), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5c), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5d), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5e), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5f), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1d40), TCO_PBG},
+	{ PCI_VDEVICE(INTEL, 0x1d41), TCO_PBG},
+	{ PCI_VDEVICE(INTEL, 0x2310), TCO_DH89XXCC},
+	{ PCI_VDEVICE(INTEL, 0x1e40), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e41), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e42), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e43), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e44), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e45), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e46), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e47), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e48), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e49), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4a), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4b), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4c), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4d), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4e), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4f), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e50), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e51), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e52), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e53), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e54), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e55), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e56), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e57), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e58), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e59), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5a), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5b), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5c), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5d), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5e), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5f), TCO_PPT},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
@@ -1052,15 +923,10 @@ static void iTCO_wdt_shutdown(struct platform_device *dev)
 	iTCO_wdt_stop();
 }
 
-#define iTCO_wdt_suspend NULL
-#define iTCO_wdt_resume  NULL
-
 static struct platform_driver iTCO_wdt_driver = {
 	.probe          = iTCO_wdt_probe,
 	.remove         = __devexit_p(iTCO_wdt_remove),
 	.shutdown       = iTCO_wdt_shutdown,
-	.suspend        = iTCO_wdt_suspend,
-	.resume         = iTCO_wdt_resume,
 	.driver         = {
 		.owner  = THIS_MODULE,
 		.name   = DRV_NAME,
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 86f7cac..b8ef2c6 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -329,12 +329,18 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
 	}
 }
 
+static const struct of_device_id imx2_wdt_dt_ids[] = {
+	{ .compatible = "fsl,imx21-wdt", },
+	{ /* sentinel */ }
+};
+
 static struct platform_driver imx2_wdt_driver = {
 	.remove		= __exit_p(imx2_wdt_remove),
 	.shutdown	= imx2_wdt_shutdown,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = imx2_wdt_dt_ids,
 	},
 };
 
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 6143f52..8d2d850 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -28,10 +28,10 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
-#include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/ioport.h>
 
 #define NAME "it8712f_wdt"
 
@@ -51,7 +51,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static unsigned long wdt_open;
 static unsigned expect_close;
-static spinlock_t io_lock;
 static unsigned char revision;
 
 /* Dog Food address - We use the game port address */
@@ -121,20 +120,26 @@ static inline void superio_select(int ldn)
 	outb(ldn, VAL);
 }
 
-static inline void superio_enter(void)
+static inline int superio_enter(void)
 {
-	spin_lock(&io_lock);
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, NAME))
+		return -EBUSY;
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
-	spin_unlock(&io_lock);
+	release_region(REG, 2);
 }
 
 static inline void it8712f_wdt_ping(void)
@@ -173,10 +178,13 @@ static int it8712f_wdt_get_status(void)
 		return 0;
 }
 
-static void it8712f_wdt_enable(void)
+static int it8712f_wdt_enable(void)
 {
+	int ret = superio_enter();
+	if (ret)
+		return ret;
+
 	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
-	superio_enter();
 	superio_select(LDN_GPIO);
 
 	superio_outb(wdt_control_reg, WDT_CONTROL);
@@ -186,13 +194,17 @@ static void it8712f_wdt_enable(void)
 	superio_exit();
 
 	it8712f_wdt_ping();
+
+	return 0;
 }
 
-static void it8712f_wdt_disable(void)
+static int it8712f_wdt_disable(void)
 {
-	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
-	superio_enter();
+	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 	superio_select(LDN_GPIO);
 
 	superio_outb(0, WDT_CONFIG);
@@ -202,6 +214,7 @@ static void it8712f_wdt_disable(void)
 	superio_outb(0, WDT_TIMEOUT);
 
 	superio_exit();
+	return 0;
 }
 
 static int it8712f_wdt_notify(struct notifier_block *this,
@@ -252,6 +265,7 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 						WDIOF_MAGICCLOSE,
 	};
 	int value;
+	int ret;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -259,7 +273,9 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
-		superio_enter();
+		ret = superio_enter();
+		if (ret)
+			return ret;
 		superio_select(LDN_GPIO);
 
 		value = it8712f_wdt_get_status();
@@ -280,7 +296,9 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (value > (max_units * 60))
 			return -EINVAL;
 		margin = value;
-		superio_enter();
+		ret = superio_enter();
+		if (ret)
+			return ret;
 		superio_select(LDN_GPIO);
 
 		it8712f_wdt_update_margin();
@@ -299,10 +317,14 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 
 static int it8712f_wdt_open(struct inode *inode, struct file *file)
 {
+	int ret;
 	/* only allow one at a time */
 	if (test_and_set_bit(0, &wdt_open))
 		return -EBUSY;
-	it8712f_wdt_enable();
+
+	ret = it8712f_wdt_enable();
+	if (ret)
+		return ret;
 	return nonseekable_open(inode, file);
 }
 
@@ -313,7 +335,8 @@ static int it8712f_wdt_release(struct inode *inode, struct file *file)
 			": watchdog device closed unexpectedly, will not"
 			" disable the watchdog timer\n");
 	} else if (!nowayout) {
-		it8712f_wdt_disable();
+		if (it8712f_wdt_disable())
+			printk(KERN_WARNING NAME "Watchdog disable failed\n");
 	}
 	expect_close = 0;
 	clear_bit(0, &wdt_open);
@@ -340,8 +363,10 @@ static int __init it8712f_wdt_find(unsigned short *address)
 {
 	int err = -ENODEV;
 	int chip_type;
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
-	superio_enter();
 	chip_type = superio_inw(DEVID);
 	if (chip_type != IT8712F_DEVID)
 		goto exit;
@@ -382,8 +407,6 @@ static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
-	spin_lock_init(&io_lock);
-
 	if (it8712f_wdt_find(&address))
 		return -ENODEV;
 
@@ -392,7 +415,11 @@ static int __init it8712f_wdt_init(void)
 		return -EBUSY;
 	}
 
-	it8712f_wdt_disable();
+	err = it8712f_wdt_disable();
+	if (err) {
+		printk(KERN_ERR NAME ": unable to disable watchdog timer.\n");
+		goto out;
+	}
 
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index b1bc72f..a2d9a12 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -137,7 +137,6 @@
 
 static	unsigned int base, gpact, ciract, max_units, chip_type;
 static	unsigned long wdt_status;
-static	DEFINE_SPINLOCK(spinlock);
 
 static	int nogameport = DEFAULT_NOGAMEPORT;
 static	int exclusive  = DEFAULT_EXCLUSIVE;
@@ -163,18 +162,26 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started, default="
 
 /* Superio Chip */
 
-static inline void superio_enter(void)
+static inline int superio_enter(void)
 {
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, WATCHDOG_NAME))
+		return -EBUSY;
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 static inline void superio_select(int ldn)
@@ -255,12 +262,11 @@ static void wdt_keepalive(void)
 	set_bit(WDTS_KEEPALIVE, &wdt_status);
 }
 
-static void wdt_start(void)
+static int wdt_start(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
 	superio_select(GPIO);
 	if (test_bit(WDTS_USE_GP, &wdt_status))
@@ -270,15 +276,15 @@ static void wdt_start(void)
 	wdt_update_timeout();
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
+
+	return 0;
 }
 
-static void wdt_stop(void)
+static int wdt_stop(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
@@ -288,7 +294,7 @@ static void wdt_stop(void)
 		superio_outb(0x00, WDTVALMSB);
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
+	return 0;
 }
 
 /**
@@ -303,8 +309,6 @@ static void wdt_stop(void)
 
 static int wdt_set_timeout(int t)
 {
-	unsigned long flags;
-
 	if (t < 1 || t > max_units * 60)
 		return -EINVAL;
 
@@ -313,14 +317,15 @@ static int wdt_set_timeout(int t)
 	else
 		timeout = t;
 
-	spin_lock_irqsave(&spinlock, flags);
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
-		superio_enter();
+		int ret = superio_enter();
+		if (ret)
+			return ret;
+
 		superio_select(GPIO);
 		wdt_update_timeout();
 		superio_exit();
 	}
-	spin_unlock_irqrestore(&spinlock, flags);
 	return 0;
 }
 
@@ -339,12 +344,12 @@ static int wdt_set_timeout(int t)
 
 static int wdt_get_status(int *status)
 {
-	unsigned long flags;
-
 	*status = 0;
 	if (testmode) {
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
+		int ret = superio_enter();
+		if (ret)
+			return ret;
+
 		superio_select(GPIO);
 		if (superio_inb(WDTCTRL) & WDT_ZERO) {
 			superio_outb(0x00, WDTCTRL);
@@ -353,7 +358,6 @@ static int wdt_get_status(int *status)
 		}
 
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 	if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
 		*status |= WDIOF_KEEPALIVEPING;
@@ -379,9 +383,17 @@ static int wdt_open(struct inode *inode, struct file *file)
 	if (exclusive && test_and_set_bit(WDTS_DEV_OPEN, &wdt_status))
 		return -EBUSY;
 	if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
+		int ret;
 		if (nowayout && !test_and_set_bit(WDTS_LOCKED, &wdt_status))
 			__module_get(THIS_MODULE);
-		wdt_start();
+
+		ret = wdt_start();
+		if (ret) {
+			clear_bit(WDTS_LOCKED, &wdt_status);
+			clear_bit(WDTS_TIMER_RUN, &wdt_status);
+			clear_bit(WDTS_DEV_OPEN, &wdt_status);
+			return ret;
+		}
 	}
 	return nonseekable_open(inode, file);
 }
@@ -403,7 +415,16 @@ static int wdt_release(struct inode *inode, struct file *file)
 {
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
 		if (test_and_clear_bit(WDTS_EXPECTED, &wdt_status)) {
-			wdt_stop();
+			int ret = wdt_stop();
+			if (ret) {
+				/*
+				 * Stop failed. Just keep the watchdog alive
+				 * and hope nothing bad happens.
+				 */
+				set_bit(WDTS_EXPECTED, &wdt_status);
+				wdt_keepalive();
+				return ret;
+			}
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 		} else {
 			wdt_keepalive();
@@ -484,7 +505,9 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				    &ident, sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
-		wdt_get_status(&status);
+		rc = wdt_get_status(&status);
+		if (rc)
+			return rc;
 		return put_user(status, uarg.i);
 
 	case WDIOC_GETBOOTSTATUS:
@@ -500,14 +523,22 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		switch (new_options) {
 		case WDIOS_DISABLECARD:
-			if (test_bit(WDTS_TIMER_RUN, &wdt_status))
-				wdt_stop();
+			if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
+				rc = wdt_stop();
+				if (rc)
+					return rc;
+			}
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 			return 0;
 
 		case WDIOS_ENABLECARD:
-			if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
-				wdt_start();
+			if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
+				rc = wdt_start();
+				if (rc) {
+					clear_bit(WDTS_TIMER_RUN, &wdt_status);
+					return rc;
+				}
+			}
 			return 0;
 
 		default:
@@ -560,16 +591,17 @@ static int __init it87_wdt_init(void)
 	int rc = 0;
 	int try_gameport = !nogameport;
 	u8  chip_rev;
-	unsigned long flags;
+	int gp_rreq_fail = 0;
 
 	wdt_status = 0;
 
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	rc = superio_enter();
+	if (rc)
+		return rc;
+
 	chip_type = superio_inw(CHIPID);
 	chip_rev  = superio_inb(CHIPREV) & 0x0f;
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
 
 	switch (chip_type) {
 	case IT8702_ID:
@@ -603,8 +635,9 @@ static int __init it87_wdt_init(void)
 		return -ENODEV;
 	}
 
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	rc = superio_enter();
+	if (rc)
+		return rc;
 
 	superio_select(GPIO);
 	superio_outb(WDT_TOV1, WDTCFG);
@@ -620,21 +653,16 @@ static int __init it87_wdt_init(void)
 		}
 		gpact = superio_inb(ACTREG);
 		superio_outb(0x01, ACTREG);
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 		if (request_region(base, 1, WATCHDOG_NAME))
 			set_bit(WDTS_USE_GP, &wdt_status);
 		else
-			rc = -EIO;
-	} else {
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
+			gp_rreq_fail = 1;
 	}
 
 	/* If we haven't Gameport support, try to get CIR support */
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
-			if (rc == -EIO)
+			if (gp_rreq_fail)
 				printk(KERN_ERR PFX
 					"I/O Address 0x%04x and 0x%04x"
 					" already in use\n", base, CIR_BASE);
@@ -646,21 +674,16 @@ static int __init it87_wdt_init(void)
 			goto err_out;
 		}
 		base = CIR_BASE;
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
 
 		superio_select(CIR);
 		superio_outw(base, BASEREG);
 		superio_outb(0x00, CIR_ILS);
 		ciract = superio_inb(ACTREG);
 		superio_outb(0x01, ACTREG);
-		if (rc == -EIO) {
+		if (gp_rreq_fail) {
 			superio_select(GAMEPORT);
 			superio_outb(gpact, ACTREG);
 		}
-
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
 	if (timeout < 1 || timeout > max_units * 60) {
@@ -704,6 +727,7 @@ static int __init it87_wdt_init(void)
 		"nogameport=%d)\n", chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
 
+	superio_exit();
 	return 0;
 
 err_out_reboot:
@@ -711,49 +735,37 @@ err_out_reboot:
 err_out_region:
 	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
 		superio_select(CIR);
 		superio_outb(ciract, ACTREG);
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 err_out:
 	if (try_gameport) {
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
 		superio_select(GAMEPORT);
 		superio_outb(gpact, ACTREG);
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
+	superio_exit();
 	return rc;
 }
 
 static void __exit it87_wdt_exit(void)
 {
-	unsigned long flags;
-	int nolock;
-
-	nolock = !spin_trylock_irqsave(&spinlock, flags);
-	superio_enter();
-	superio_select(GPIO);
-	superio_outb(0x00, WDTCTRL);
-	superio_outb(0x00, WDTCFG);
-	superio_outb(0x00, WDTVALLSB);
-	if (max_units > 255)
-		superio_outb(0x00, WDTVALMSB);
-	if (test_bit(WDTS_USE_GP, &wdt_status)) {
-		superio_select(GAMEPORT);
-		superio_outb(gpact, ACTREG);
-	} else {
-		superio_select(CIR);
-		superio_outb(ciract, ACTREG);
+	if (superio_enter() == 0) {
+		superio_select(GPIO);
+		superio_outb(0x00, WDTCTRL);
+		superio_outb(0x00, WDTCFG);
+		superio_outb(0x00, WDTVALLSB);
+		if (max_units > 255)
+			superio_outb(0x00, WDTVALMSB);
+		if (test_bit(WDTS_USE_GP, &wdt_status)) {
+			superio_select(GAMEPORT);
+			superio_outb(gpact, ACTREG);
+		} else {
+			superio_select(CIR);
+			superio_outb(ciract, ACTREG);
+		}
+		superio_exit();
 	}
-	superio_exit();
-	if (!nolock)
-		spin_unlock_irqrestore(&spinlock, flags);
 
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 2b4af22..4dc3102 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -407,12 +407,35 @@ static int __devexit mpcore_wdt_remove(struct platform_device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int mpcore_wdt_suspend(struct platform_device *dev, pm_message_t msg)
+{
+	struct mpcore_wdt *wdt = platform_get_drvdata(dev);
+	mpcore_wdt_stop(wdt);		/* Turn the WDT off */
+	return 0;
+}
+
+static int mpcore_wdt_resume(struct platform_device *dev)
+{
+	struct mpcore_wdt *wdt = platform_get_drvdata(dev);
+	/* re-activate timer */
+	if (test_bit(0, &wdt->timer_alive))
+		mpcore_wdt_start(wdt);
+	return 0;
+}
+#else
+#define mpcore_wdt_suspend	NULL
+#define mpcore_wdt_resume	NULL
+#endif
+
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:mpcore_wdt");
 
 static struct platform_driver mpcore_wdt_driver = {
 	.probe		= mpcore_wdt_probe,
 	.remove		= __devexit_p(mpcore_wdt_remove),
+	.suspend	= mpcore_wdt_suspend,
+	.resume		= mpcore_wdt_resume,
 	.shutdown	= mpcore_wdt_shutdown,
 	.driver		= {
 		.owner	= THIS_MODULE,
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 0430e09..ac37bb8 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -225,11 +225,11 @@ static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&mtx1_wdt_misc);
 	if (ret < 0) {
-		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
+		dev_err(&pdev->dev, "failed to register\n");
 		return ret;
 	}
 	mtx1_wdt_start();
-	printk(KERN_INFO "MTX-1 Watchdog driver\n");
+	dev_info(&pdev->dev, "MTX-1 Watchdog driver\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
new file mode 100644
index 0000000..4ec741a
--- /dev/null
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -0,0 +1,433 @@
+/*
+*   of_xilinx_wdt.c  1.01  A Watchdog Device Driver for Xilinx xps_timebase_wdt
+*
+*   (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
+*
+*       -----------------------
+*
+*   This program is free software; you can redistribute it and/or
+*   modify it under the terms of the GNU General Public License
+*   as published by the Free Software Foundation; either version
+*   2 of the License, or (at your option) any later version.
+*
+*       -----------------------
+*	30-May-2011 Alejandro Cabrera <aldaya@gmail.com>
+*		- If "xlnx,wdt-enable-once" wasn't found on device tree the
+*		  module will use CONFIG_WATCHDOG_NOWAYOUT
+*		- If the device tree parameters ("clock-frequency" and
+*		  "xlnx,wdt-interval") wasn't found the driver won't
+*		  know the wdt reset interval
+*/
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+
+/* Register offsets for the Wdt device */
+#define XWT_TWCSR0_OFFSET   0x0 /* Control/Status Register0 */
+#define XWT_TWCSR1_OFFSET   0x4 /* Control/Status Register1 */
+#define XWT_TBR_OFFSET      0x8 /* Timebase Register Offset */
+
+/* Control/Status Register Masks  */
+#define XWT_CSR0_WRS_MASK   0x00000008 /* Reset status */
+#define XWT_CSR0_WDS_MASK   0x00000004 /* Timer state  */
+#define XWT_CSR0_EWDT1_MASK 0x00000002 /* Enable bit 1 */
+
+/* Control/Status Register 0/1 bits  */
+#define XWT_CSRX_EWDT2_MASK 0x00000001 /* Enable bit 2 */
+
+/* SelfTest constants */
+#define XWT_MAX_SELFTEST_LOOP_COUNT 0x00010000
+#define XWT_TIMER_FAILED            0xFFFFFFFF
+
+#define WATCHDOG_NAME     "Xilinx Watchdog"
+#define PFX WATCHDOG_NAME ": "
+
+struct xwdt_device {
+	struct resource  res;
+	void __iomem *base;
+	u32 nowayout;
+	u32 wdt_interval;
+	u32 boot_status;
+};
+
+static struct xwdt_device xdev;
+
+static  u32 timeout;
+static  u32 control_status_reg;
+static  u8  expect_close;
+static  u8  no_timeout;
+static unsigned long driver_open;
+
+static  DEFINE_SPINLOCK(spinlock);
+
+static void xwdt_start(void)
+{
+	spin_lock(&spinlock);
+
+	/* Clean previous status and enable the watchdog timer */
+	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);
+
+	iowrite32((control_status_reg | XWT_CSR0_EWDT1_MASK),
+				xdev.base + XWT_TWCSR0_OFFSET);
+
+	iowrite32(XWT_CSRX_EWDT2_MASK, xdev.base + XWT_TWCSR1_OFFSET);
+
+	spin_unlock(&spinlock);
+}
+
+static void xwdt_stop(void)
+{
+	spin_lock(&spinlock);
+
+	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+
+	iowrite32((control_status_reg & ~XWT_CSR0_EWDT1_MASK),
+				xdev.base + XWT_TWCSR0_OFFSET);
+
+	iowrite32(0, xdev.base + XWT_TWCSR1_OFFSET);
+
+	spin_unlock(&spinlock);
+	printk(KERN_INFO PFX "Stopped!\n");
+}
+
+static void xwdt_keepalive(void)
+{
+	spin_lock(&spinlock);
+
+	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);
+	iowrite32(control_status_reg, xdev.base + XWT_TWCSR0_OFFSET);
+
+	spin_unlock(&spinlock);
+}
+
+static void xwdt_get_status(int *status)
+{
+	int new_status;
+
+	spin_lock(&spinlock);
+
+	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	new_status = ((control_status_reg &
+			(XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK)) != 0);
+	spin_unlock(&spinlock);
+
+	*status = 0;
+	if (new_status & 1)
+		*status |= WDIOF_CARDRESET;
+}
+
+static u32 xwdt_selftest(void)
+{
+	int i;
+	u32 timer_value1;
+	u32 timer_value2;
+
+	spin_lock(&spinlock);
+
+	timer_value1 = ioread32(xdev.base + XWT_TBR_OFFSET);
+	timer_value2 = ioread32(xdev.base + XWT_TBR_OFFSET);
+
+	for (i = 0;
+		((i <= XWT_MAX_SELFTEST_LOOP_COUNT) &&
+			(timer_value2 == timer_value1)); i++) {
+		timer_value2 = ioread32(xdev.base + XWT_TBR_OFFSET);
+	}
+
+	spin_unlock(&spinlock);
+
+	if (timer_value2 != timer_value1)
+		return ~XWT_TIMER_FAILED;
+	else
+		return XWT_TIMER_FAILED;
+}
+
+static int xwdt_open(struct inode *inode, struct file *file)
+{
+	/* Only one process can handle the wdt at a time */
+	if (test_and_set_bit(0, &driver_open))
+		return -EBUSY;
+
+	/* Make sure that the module are always loaded...*/
+	if (xdev.nowayout)
+		__module_get(THIS_MODULE);
+
+	xwdt_start();
+	printk(KERN_INFO PFX "Started...\n");
+
+	return nonseekable_open(inode, file);
+}
+
+static int xwdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close == 42) {
+		xwdt_stop();
+	} else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
+		xwdt_keepalive();
+	}
+
+	clear_bit(0, &driver_open);
+	expect_close = 0;
+	return 0;
+}
+
+/*
+ *      xwdt_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write (unused as data does not matter here
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we don't define content meaning.
+ */
+static ssize_t xwdt_write(struct file *file, const char __user *buf,
+						size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!xdev.nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
+		xwdt_keepalive();
+	}
+	return len;
+}
+
+static const struct watchdog_info ident = {
+	.options =  WDIOF_MAGICCLOSE |
+		    WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =	WATCHDOG_NAME,
+};
+
+/*
+ *      xwdt_ioctl:
+ *      @file: file handle to the device
+ *      @cmd: watchdog command
+ *      @arg: argument pointer
+ *
+ *      The watchdog API defines a common set of functions for all watchdogs
+ *      according to their available features.
+ */
+static long xwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int status;
+
+	union {
+		struct watchdog_info __user *ident;
+		int __user *i;
+	} uarg;
+
+	uarg.i = (int __user *)arg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &ident,
+					sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(xdev.boot_status, uarg.i);
+
+	case WDIOC_GETSTATUS:
+		xwdt_get_status(&status);
+		return put_user(status, uarg.i);
+
+	case WDIOC_KEEPALIVE:
+		xwdt_keepalive();
+		return 0;
+
+	case WDIOC_GETTIMEOUT:
+		if (no_timeout)
+			return -ENOTTY;
+		else
+			return put_user(timeout, uarg.i);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations xwdt_fops = {
+	.owner      = THIS_MODULE,
+	.llseek     = no_llseek,
+	.write      = xwdt_write,
+	.open       = xwdt_open,
+	.release    = xwdt_release,
+	.unlocked_ioctl = xwdt_ioctl,
+};
+
+static struct miscdevice xwdt_miscdev = {
+	.minor      = WATCHDOG_MINOR,
+	.name       = "watchdog",
+	.fops       = &xwdt_fops,
+};
+
+static int __devinit xwdt_probe(struct platform_device *pdev)
+{
+	int rc;
+	u32 *tmptr;
+	u32 *pfreq;
+
+	no_timeout = 0;
+
+	pfreq = (u32 *)of_get_property(pdev->dev.of_node->parent,
+					"clock-frequency", NULL);
+
+	if (pfreq == NULL) {
+		printk(KERN_WARNING PFX
+			"The watchdog clock frequency cannot be obtained!\n");
+		no_timeout = 1;
+	}
+
+	rc = of_address_to_resource(pdev->dev.of_node, 0, &xdev.res);
+	if (rc) {
+		printk(KERN_WARNING PFX "invalid address!\n");
+		return rc;
+	}
+
+	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
+					"xlnx,wdt-interval", NULL);
+	if (tmptr == NULL) {
+		printk(KERN_WARNING PFX "Parameter \"xlnx,wdt-interval\""
+					" not found in device tree!\n");
+		no_timeout = 1;
+	} else {
+		xdev.wdt_interval = *tmptr;
+	}
+
+	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
+					"xlnx,wdt-enable-once", NULL);
+	if (tmptr == NULL) {
+		printk(KERN_WARNING PFX "Parameter \"xlnx,wdt-enable-once\""
+					" not found in device tree!\n");
+		xdev.nowayout = WATCHDOG_NOWAYOUT;
+	}
+
+/*
+ *  Twice of the 2^wdt_interval / freq  because the first wdt overflow is
+ *  ignored (interrupt), reset is only generated at second wdt overflow
+ */
+	if (!no_timeout)
+		timeout = 2 * ((1<<xdev.wdt_interval) / *pfreq);
+
+	if (!request_mem_region(xdev.res.start,
+			xdev.res.end - xdev.res.start + 1, WATCHDOG_NAME)) {
+		rc = -ENXIO;
+		printk(KERN_ERR PFX "memory request failure!\n");
+		goto err_out;
+	}
+
+	xdev.base = ioremap(xdev.res.start, xdev.res.end - xdev.res.start + 1);
+	if (xdev.base == NULL) {
+		rc = -ENOMEM;
+		printk(KERN_ERR PFX "ioremap failure!\n");
+		goto release_mem;
+	}
+
+	rc = xwdt_selftest();
+	if (rc == XWT_TIMER_FAILED) {
+		printk(KERN_ERR PFX "SelfTest routine error!\n");
+		goto unmap_io;
+	}
+
+	xwdt_get_status(&xdev.boot_status);
+
+	rc = misc_register(&xwdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						xwdt_miscdev.minor, rc);
+		goto unmap_io;
+	}
+
+	if (no_timeout)
+		printk(KERN_INFO PFX
+			"driver loaded (timeout=? sec, nowayout=%d)\n",
+						    xdev.nowayout);
+	else
+		printk(KERN_INFO PFX
+			"driver loaded (timeout=%d sec, nowayout=%d)\n",
+					timeout, xdev.nowayout);
+
+	expect_close = 0;
+	clear_bit(0, &driver_open);
+
+	return 0;
+
+unmap_io:
+	iounmap(xdev.base);
+release_mem:
+	release_mem_region(xdev.res.start, resource_size(&xdev.res));
+err_out:
+	return rc;
+}
+
+static int __devexit xwdt_remove(struct platform_device *dev)
+{
+	misc_deregister(&xwdt_miscdev);
+	iounmap(xdev.base);
+	release_mem_region(xdev.res.start, resource_size(&xdev.res));
+
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id __devinitdata xwdt_of_match[] = {
+	{ .compatible = "xlnx,xps-timebase-wdt-1.01.a", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xwdt_of_match);
+
+static struct platform_driver xwdt_driver = {
+	.probe       = xwdt_probe,
+	.remove      = __devexit_p(xwdt_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = WATCHDOG_NAME,
+		.of_match_table = xwdt_of_match,
+	},
+};
+
+static int __init xwdt_init(void)
+{
+	return platform_driver_register(&xwdt_driver);
+}
+
+static void __exit xwdt_exit(void)
+{
+	platform_driver_unregister(&xwdt_driver);
+}
+
+module_init(xwdt_init);
+module_exit(xwdt_exit);
+
+MODULE_AUTHOR("Alejandro Cabrera <aldaya@gmail.com>");
+MODULE_DESCRIPTION("Xilinx Watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index b7c1390..e78d899 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -56,6 +56,7 @@
 #define IO_DEFAULT	0x2E		/* Address used on Portwell Boards */
 
 static int io = IO_DEFAULT;
+static int swc_base_addr = -1;
 
 static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
 static unsigned long timer_enabled;	/* is the timer enabled? */
@@ -116,9 +117,8 @@ static inline void pc87413_enable_swc(void)
 
 /* Read SWC I/O base address */
 
-static inline unsigned int pc87413_get_swc_base(void)
+static void pc87413_get_swc_base_addr(void)
 {
-	unsigned int  swc_base_addr = 0;
 	unsigned char addr_l, addr_h = 0;
 
 	/* Step 3: Read SWC I/O Base Address */
@@ -136,12 +136,11 @@ static inline unsigned int pc87413_get_swc_base(void)
 		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
 						addr_l, addr_h, swc_base_addr);
 #endif
-	return swc_base_addr;
 }
 
 /* Select Bank 3 of SWC */
 
-static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
+static inline void pc87413_swc_bank3(void)
 {
 	/* Step 4: Select Bank3 of SWC */
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
@@ -152,8 +151,7 @@ static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
 
 /* Set watchdog timeout to x minutes */
 
-static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
-					 char pc87413_time)
+static inline void pc87413_programm_wdto(char pc87413_time)
 {
 	/* Step 5: Programm WDTO, Twd. */
 	outb_p(pc87413_time, swc_base_addr + WDTO);
@@ -164,7 +162,7 @@ static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
 
 /* Enable WDEN */
 
-static inline void pc87413_enable_wden(unsigned int swc_base_addr)
+static inline void pc87413_enable_wden(void)
 {
 	/* Step 6: Enable WDEN */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
@@ -174,7 +172,7 @@ static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 }
 
 /* Enable SW_WD_TREN */
-static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
+static inline void pc87413_enable_sw_wd_tren(void)
 {
 	/* Enable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
@@ -185,7 +183,7 @@ static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 
 /* Disable SW_WD_TREN */
 
-static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
+static inline void pc87413_disable_sw_wd_tren(void)
 {
 	/* Disable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
@@ -196,7 +194,7 @@ static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 
 /* Enable SW_WD_TRG */
 
-static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
+static inline void pc87413_enable_sw_wd_trg(void)
 {
 	/* Enable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
@@ -207,7 +205,7 @@ static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 
 /* Disable SW_WD_TRG */
 
-static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
+static inline void pc87413_disable_sw_wd_trg(void)
 {
 	/* Disable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
@@ -222,18 +220,13 @@ static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
 
 static void pc87413_enable(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, timeout);
-	pc87413_enable_wden(swc_base_addr);
-	pc87413_enable_sw_wd_tren(swc_base_addr);
-	pc87413_enable_sw_wd_trg(swc_base_addr);
+	pc87413_swc_bank3();
+	pc87413_programm_wdto(timeout);
+	pc87413_enable_wden();
+	pc87413_enable_sw_wd_tren();
+	pc87413_enable_sw_wd_trg();
 
 	spin_unlock(&io_lock);
 }
@@ -242,17 +235,12 @@ static void pc87413_enable(void)
 
 static void pc87413_disable(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_disable_sw_wd_tren(swc_base_addr);
-	pc87413_disable_sw_wd_trg(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, 0);
+	pc87413_swc_bank3();
+	pc87413_disable_sw_wd_tren();
+	pc87413_disable_sw_wd_trg();
+	pc87413_programm_wdto(0);
 
 	spin_unlock(&io_lock);
 }
@@ -261,20 +249,15 @@ static void pc87413_disable(void)
 
 static void pc87413_refresh(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_disable_sw_wd_tren(swc_base_addr);
-	pc87413_disable_sw_wd_trg(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, timeout);
-	pc87413_enable_wden(swc_base_addr);
-	pc87413_enable_sw_wd_tren(swc_base_addr);
-	pc87413_enable_sw_wd_trg(swc_base_addr);
+	pc87413_swc_bank3();
+	pc87413_disable_sw_wd_tren();
+	pc87413_disable_sw_wd_trg();
+	pc87413_programm_wdto(timeout);
+	pc87413_enable_wden();
+	pc87413_enable_sw_wd_tren();
+	pc87413_enable_sw_wd_trg();
 
 	spin_unlock(&io_lock);
 }
@@ -528,7 +511,8 @@ static int __init pc87413_init(void)
 	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
 							WDT_INDEX_IO_PORT);
 
-	/* request_region(io, 2, "pc87413"); */
+	if (!request_muxed_region(io, 2, MODNAME))
+		return -EBUSY;
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
@@ -541,12 +525,32 @@ static int __init pc87413_init(void)
 		printk(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&pc87413_notifier);
-		return ret;
+		goto reboot_unreg;
 	}
 	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
+
+	pc87413_select_wdt_out();
+	pc87413_enable_swc();
+	pc87413_get_swc_base_addr();
+
+	if (!request_region(swc_base_addr, 0x20, MODNAME)) {
+		printk(KERN_ERR PFX
+			"cannot request SWC region at 0x%x\n", swc_base_addr);
+		ret = -EBUSY;
+		goto misc_unreg;
+	}
+
 	pc87413_enable();
+
+	release_region(io, 2);
 	return 0;
+
+misc_unreg:
+	misc_deregister(&pc87413_miscdev);
+reboot_unreg:
+	unregister_reboot_notifier(&pc87413_notifier);
+	release_region(io, 2);
+	return ret;
 }
 
 /**
@@ -569,7 +573,7 @@ static void __exit pc87413_exit(void)
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
-	/* release_region(io, 2); */
+	release_region(swc_base_addr, 0x20);
 
 	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
 }
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index f7f5aa0..30da88f 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -589,6 +589,15 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 #define s3c2410wdt_resume  NULL
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_OF
+static const struct of_device_id s3c2410_wdt_match[] = {
+	{ .compatible = "samsung,s3c2410-wdt" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, s3c2410_wdt_match);
+#else
+#define s3c2410_wdt_match NULL
+#endif
 
 static struct platform_driver s3c2410wdt_driver = {
 	.probe		= s3c2410wdt_probe,
@@ -599,6 +608,7 @@ static struct platform_driver s3c2410wdt_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c2410-wdt",
+		.of_match_table	= s3c2410_wdt_match,
 	},
 };
 
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index c7cf4b0..029467e 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -472,15 +472,10 @@ static void sch311x_wdt_shutdown(struct platform_device *dev)
 	sch311x_wdt_stop();
 }
 
-#define sch311x_wdt_suspend NULL
-#define sch311x_wdt_resume  NULL
-
 static struct platform_driver sch311x_wdt_driver = {
 	.probe		= sch311x_wdt_probe,
 	.remove		= __devexit_p(sch311x_wdt_remove),
 	.shutdown	= sch311x_wdt_shutdown,
-	.suspend	= sch311x_wdt_suspend,
-	.resume		= sch311x_wdt_resume,
 	.driver		= {
 		.owner = THIS_MODULE,
 		.name = DRV_NAME,
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 0d80e08..cc2cfbe 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -134,6 +134,8 @@ static void wdt_enable(void)
 	writel(INT_ENABLE | RESET_ENABLE, wdt->base + WDTCONTROL);
 	writel(LOCK, wdt->base + WDTLOCK);
 
+	/* Flush posted writes. */
+	readl(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
 }
 
@@ -144,9 +146,10 @@ static void wdt_disable(void)
 
 	writel(UNLOCK, wdt->base + WDTLOCK);
 	writel(0, wdt->base + WDTCONTROL);
-	writel(0, wdt->base + WDTLOAD);
 	writel(LOCK, wdt->base + WDTLOCK);
 
+	/* Flush posted writes. */
+	readl(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
 }
 
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
new file mode 100644
index 0000000..cfa1a15
--- /dev/null
+++ b/drivers/watchdog/watchdog_core.c
@@ -0,0 +1,111 @@
+/*
+ *	watchdog_core.c
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>	/* For EXPORT_SYMBOL/module stuff/... */
+#include <linux/types.h>	/* For standard types */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/watchdog.h>	/* For watchdog specific items */
+#include <linux/init.h>		/* For __init/__exit/... */
+
+#include "watchdog_dev.h"	/* For watchdog_dev_register/... */
+
+/**
+ * watchdog_register_device() - register a watchdog device
+ * @wdd: watchdog device
+ *
+ * Register a watchdog device with the kernel so that the
+ * watchdog timer can be accessed from userspace.
+ *
+ * A zero is returned on success and a negative errno code for
+ * failure.
+ */
+int watchdog_register_device(struct watchdog_device *wdd)
+{
+	int ret;
+
+	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
+		return -EINVAL;
+
+	/* Mandatory operations need to be supported */
+	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
+		return -EINVAL;
+
+	/*
+	 * Check that we have valid min and max timeout values, if
+	 * not reset them both to 0 (=not used or unknown)
+	 */
+	if (wdd->min_timeout > wdd->max_timeout) {
+		pr_info("Invalid min and max timeout values, resetting to 0!\n");
+		wdd->min_timeout = 0;
+		wdd->max_timeout = 0;
+	}
+
+	/*
+	 * Note: now that all watchdog_device data has been verified, we
+	 * will not check this anymore in other functions. If data gets
+	 * corrupted in a later stage then we expect a kernel panic!
+	 */
+
+	/* We only support 1 watchdog device via the /dev/watchdog interface */
+	ret = watchdog_dev_register(wdd);
+	if (ret) {
+		pr_err("error registering /dev/watchdog (err=%d).\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(watchdog_register_device);
+
+/**
+ * watchdog_unregister_device() - unregister a watchdog device
+ * @wdd: watchdog device to unregister
+ *
+ * Unregister a watchdog device that was previously successfully
+ * registered with watchdog_register_device().
+ */
+void watchdog_unregister_device(struct watchdog_device *wdd)
+{
+	int ret;
+
+	if (wdd == NULL)
+		return;
+
+	ret = watchdog_dev_unregister(wdd);
+	if (ret)
+		pr_err("error unregistering /dev/watchdog (err=%d).\n", ret);
+}
+EXPORT_SYMBOL_GPL(watchdog_unregister_device);
+
+MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>");
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("WatchDog Timer Driver Core");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
new file mode 100644
index 0000000..d33520d
--- /dev/null
+++ b/drivers/watchdog/watchdog_dev.c
@@ -0,0 +1,395 @@
+/*
+ *	watchdog_dev.c
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	This part of the generic code takes care of the following
+ *	misc device: /dev/watchdog.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>	/* For module stuff/... */
+#include <linux/types.h>	/* For standard types (like size_t) */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/fs.h>		/* For file operations */
+#include <linux/watchdog.h>	/* For watchdog specific items */
+#include <linux/miscdevice.h>	/* For handling misc devices */
+#include <linux/init.h>		/* For __init/__exit/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+
+/* make sure we only register one /dev/watchdog device */
+static unsigned long watchdog_dev_busy;
+/* the watchdog device behind /dev/watchdog */
+static struct watchdog_device *wdd;
+
+/*
+ *	watchdog_ping: ping the watchdog.
+ *	@wddev: the watchdog device to ping
+ *
+ *	If the watchdog has no own ping operation then it needs to be
+ *	restarted via the start operation. This wrapper function does
+ *	exactly that.
+ *	We only ping when the watchdog device is running.
+ */
+
+static int watchdog_ping(struct watchdog_device *wddev)
+{
+	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+		if (wddev->ops->ping)
+			return wddev->ops->ping(wddev);  /* ping the watchdog */
+		else
+			return wddev->ops->start(wddev); /* restart watchdog */
+	}
+	return 0;
+}
+
+/*
+ *	watchdog_start: wrapper to start the watchdog.
+ *	@wddev: the watchdog device to start
+ *
+ *	Start the watchdog if it is not active and mark it active.
+ *	This function returns zero on success or a negative errno code for
+ *	failure.
+ */
+
+static int watchdog_start(struct watchdog_device *wddev)
+{
+	int err;
+
+	if (!test_bit(WDOG_ACTIVE, &wdd->status)) {
+		err = wddev->ops->start(wddev);
+		if (err < 0)
+			return err;
+
+		set_bit(WDOG_ACTIVE, &wdd->status);
+	}
+	return 0;
+}
+
+/*
+ *	watchdog_stop: wrapper to stop the watchdog.
+ *	@wddev: the watchdog device to stop
+ *
+ *	Stop the watchdog if it is still active and unmark it active.
+ *	This function returns zero on success or a negative errno code for
+ *	failure.
+ *	If the 'nowayout' feature was set, the watchdog cannot be stopped.
+ */
+
+static int watchdog_stop(struct watchdog_device *wddev)
+{
+	int err = -EBUSY;
+
+	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status)) {
+		pr_info("%s: nowayout prevents watchdog to be stopped!\n",
+							wdd->info->identity);
+		return err;
+	}
+
+	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+		err = wddev->ops->stop(wddev);
+		if (err < 0)
+			return err;
+
+		clear_bit(WDOG_ACTIVE, &wdd->status);
+	}
+	return 0;
+}
+
+/*
+ *	watchdog_write: writes to the watchdog.
+ *	@file: file from VFS
+ *	@data: user address of data
+ *	@len: length of data
+ *	@ppos: pointer to the file offset
+ *
+ *	A write to a watchdog device is defined as a keepalive ping.
+ *	Writing the magic 'V' sequence allows the next close to turn
+ *	off the watchdog (if 'nowayout' is not set).
+ */
+
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	size_t i;
+	char c;
+
+	if (len == 0)
+		return 0;
+
+	/*
+	 * Note: just in case someone wrote the magic character
+	 * five months ago...
+	 */
+	clear_bit(WDOG_ALLOW_RELEASE, &wdd->status);
+
+	/* scan to see whether or not we got the magic character */
+	for (i = 0; i != len; i++) {
+		if (get_user(c, data + i))
+			return -EFAULT;
+		if (c == 'V')
+			set_bit(WDOG_ALLOW_RELEASE, &wdd->status);
+	}
+
+	/* someone wrote to us, so we send the watchdog a keepalive ping */
+	watchdog_ping(wdd);
+
+	return len;
+}
+
+/*
+ *	watchdog_ioctl: handle the different ioctl's for the watchdog device.
+ *	@file: file handle to the device
+ *	@cmd: watchdog command
+ *	@arg: argument pointer
+ *
+ *	The watchdog API defines a common set of functions for all watchdogs
+ *	according to their available features.
+ */
+
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	unsigned int val;
+	int err;
+
+	if (wdd->ops->ioctl) {
+		err = wdd->ops->ioctl(wdd, cmd, arg);
+		if (err != -ENOIOCTLCMD)
+			return err;
+	}
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, wdd->info,
+			sizeof(struct watchdog_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		val = wdd->ops->status ? wdd->ops->status(wdd) : 0;
+		return put_user(val, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(wdd->bootstatus, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(val, p))
+			return -EFAULT;
+		if (val & WDIOS_DISABLECARD) {
+			err = watchdog_stop(wdd);
+			if (err < 0)
+				return err;
+		}
+		if (val & WDIOS_ENABLECARD) {
+			err = watchdog_start(wdd);
+			if (err < 0)
+				return err;
+		}
+		return 0;
+	case WDIOC_KEEPALIVE:
+		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
+			return -EOPNOTSUPP;
+		watchdog_ping(wdd);
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if ((wdd->ops->set_timeout == NULL) ||
+		    !(wdd->info->options & WDIOF_SETTIMEOUT))
+			return -EOPNOTSUPP;
+		if (get_user(val, p))
+			return -EFAULT;
+		if ((wdd->max_timeout != 0) &&
+		    (val < wdd->min_timeout || val > wdd->max_timeout))
+				return -EINVAL;
+		err = wdd->ops->set_timeout(wdd, val);
+		if (err < 0)
+			return err;
+		wdd->timeout = val;
+		/* If the watchdog is active then we send a keepalive ping
+		 * to make sure that the watchdog keep's running (and if
+		 * possible that it takes the new timeout) */
+		watchdog_ping(wdd);
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		/* timeout == 0 means that we don't know the timeout */
+		if (wdd->timeout == 0)
+			return -EOPNOTSUPP;
+		return put_user(wdd->timeout, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
+ *	watchdog_open: open the /dev/watchdog device.
+ *	@inode: inode of device
+ *	@file: file handle to device
+ *
+ *	When the /dev/watchdog device gets opened, we start the watchdog.
+ *	Watch out: the /dev/watchdog device is single open, so we make sure
+ *	it can only be opened once.
+ */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int err = -EBUSY;
+
+	/* the watchdog is single open! */
+	if (test_and_set_bit(WDOG_DEV_OPEN, &wdd->status))
+		return -EBUSY;
+
+	/*
+	 * If the /dev/watchdog device is open, we don't want the module
+	 * to be unloaded.
+	 */
+	if (!try_module_get(wdd->ops->owner))
+		goto out;
+
+	err = watchdog_start(wdd);
+	if (err < 0)
+		goto out_mod;
+
+	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
+	return nonseekable_open(inode, file);
+
+out_mod:
+	module_put(wdd->ops->owner);
+out:
+	clear_bit(WDOG_DEV_OPEN, &wdd->status);
+	return err;
+}
+
+/*
+ *      watchdog_release: release the /dev/watchdog device.
+ *      @inode: inode of device
+ *      @file: file handle to device
+ *
+ *	This is the code for when /dev/watchdog gets closed. We will only
+ *	stop the watchdog when we have received the magic char (and nowayout
+ *	was not set), else the watchdog will keep running.
+ */
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	int err = -EBUSY;
+
+	/*
+	 * We only stop the watchdog if we received the magic character
+	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
+	 * watchdog_stop will fail.
+	 */
+	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+		err = watchdog_stop(wdd);
+
+	/* If the watchdog was not stopped, send a keepalive ping */
+	if (err < 0) {
+		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
+		watchdog_ping(wdd);
+	}
+
+	/* Allow the owner module to be unloaded again */
+	module_put(wdd->ops->owner);
+
+	/* make sure that /dev/watchdog can be re-opened */
+	clear_bit(WDOG_DEV_OPEN, &wdd->status);
+
+	return 0;
+}
+
+static const struct file_operations watchdog_fops = {
+	.owner		= THIS_MODULE,
+	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
+	.open		= watchdog_open,
+	.release	= watchdog_release,
+};
+
+static struct miscdevice watchdog_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &watchdog_fops,
+};
+
+/*
+ *	watchdog_dev_register:
+ *	@watchdog: watchdog device
+ *
+ *	Register a watchdog device as /dev/watchdog. /dev/watchdog
+ *	is actually a miscdevice and thus we set it up like that.
+ */
+
+int watchdog_dev_register(struct watchdog_device *watchdog)
+{
+	int err;
+
+	/* Only one device can register for /dev/watchdog */
+	if (test_and_set_bit(0, &watchdog_dev_busy)) {
+		pr_err("only one watchdog can use /dev/watchdog.\n");
+		return -EBUSY;
+	}
+
+	wdd = watchdog;
+
+	err = misc_register(&watchdog_miscdev);
+	if (err != 0) {
+		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
+			watchdog->info->identity, WATCHDOG_MINOR, err);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	wdd = NULL;
+	clear_bit(0, &watchdog_dev_busy);
+	return err;
+}
+
+/*
+ *	watchdog_dev_unregister:
+ *	@watchdog: watchdog device
+ *
+ *	Deregister the /dev/watchdog device.
+ */
+
+int watchdog_dev_unregister(struct watchdog_device *watchdog)
+{
+	/* Check that a watchdog device was registered in the past */
+	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
+		return -ENODEV;
+
+	/* We can only unregister the watchdog device that was registered */
+	if (watchdog != wdd) {
+		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
+			watchdog->info->identity);
+		return -ENODEV;
+	}
+
+	misc_deregister(&watchdog_miscdev);
+	wdd = NULL;
+	clear_bit(0, &watchdog_dev_busy);
+	return 0;
+}
diff --git a/drivers/watchdog/watchdog_dev.h b/drivers/watchdog/watchdog_dev.h
new file mode 100644
index 0000000..bc7612b
--- /dev/null
+++ b/drivers/watchdog/watchdog_dev.h
@@ -0,0 +1,33 @@
+/*
+ *	watchdog_core.h
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+/*
+ *	Functions/procedures to be called by the core
+ */
+int watchdog_dev_register(struct watchdog_device *);
+int watchdog_dev_unregister(struct watchdog_device *);
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 011bcfe..111843f 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -59,6 +59,84 @@ struct watchdog_info {
 #define WATCHDOG_NOWAYOUT	0
 #endif
 
+struct watchdog_ops;
+struct watchdog_device;
+
+/** struct watchdog_ops - The watchdog-devices operations
+ *
+ * @owner:	The module owner.
+ * @start:	The routine for starting the watchdog device.
+ * @stop:	The routine for stopping the watchdog device.
+ * @ping:	The routine that sends a keepalive ping to the watchdog device.
+ * @status:	The routine that shows the status of the watchdog device.
+ * @set_timeout:The routine for setting the watchdog devices timeout value.
+ * @ioctl:	The routines that handles extra ioctl calls.
+ *
+ * The watchdog_ops structure contains a list of low-level operations
+ * that control a watchdog device. It also contains the module that owns
+ * these operations. The start and stop function are mandatory, all other
+ * functions are optonal.
+ */
+struct watchdog_ops {
+	struct module *owner;
+	/* mandatory operations */
+	int (*start)(struct watchdog_device *);
+	int (*stop)(struct watchdog_device *);
+	/* optional operations */
+	int (*ping)(struct watchdog_device *);
+	unsigned int (*status)(struct watchdog_device *);
+	int (*set_timeout)(struct watchdog_device *, unsigned int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
+};
+
+/** struct watchdog_device - The structure that defines a watchdog device
+ *
+ * @info:	Pointer to a watchdog_info structure.
+ * @ops:	Pointer to the list of watchdog operations.
+ * @bootstatus:	Status of the watchdog device at boot.
+ * @timeout:	The watchdog devices timeout value.
+ * @min_timeout:The watchdog devices minimum timeout value.
+ * @max_timeout:The watchdog devices maximum timeout value.
+ * @driver-data:Pointer to the drivers private data.
+ * @status:	Field that contains the devices internal status bits.
+ *
+ * The watchdog_device structure contains all information about a
+ * watchdog timer device.
+ *
+ * The driver-data field may not be accessed directly. It must be accessed
+ * via the watchdog_set_drvdata and watchdog_get_drvdata helpers.
+ */
+struct watchdog_device {
+	const struct watchdog_info *info;
+	const struct watchdog_ops *ops;
+	unsigned int bootstatus;
+	unsigned int timeout;
+	unsigned int min_timeout;
+	unsigned int max_timeout;
+	void *driver_data;
+	unsigned long status;
+/* Bit numbers for status flags */
+#define WDOG_ACTIVE		0	/* Is the watchdog running/active */
+#define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
+#define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
+#define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
+};
+
+/* Use the following functions to manipulate watchdog driver specific data */
+static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
+{
+	wdd->driver_data = data;
+}
+
+static inline void *watchdog_get_drvdata(struct watchdog_device *wdd)
+{
+	return wdd->driver_data;
+}
+
+/* drivers/watchdog/core/watchdog_core.c */
+extern int watchdog_register_device(struct watchdog_device *);
+extern void watchdog_unregister_device(struct watchdog_device *);
+
 #endif	/* __KERNEL__ */
 
 #endif  /* ifndef _LINUX_WATCHDOG_H */
