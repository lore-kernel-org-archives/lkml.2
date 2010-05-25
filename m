Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0EYJOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:14:14 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:6865 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756484Ab0EYJOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:14:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIow+0tbstI2/2dsb2JhbACdenK9bw6FBQSDYQ
Date: Tue, 25 May 2010 11:14:04 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
       Banajit Goswami <banajit.g@samsung.com>,
       =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [WATCHDOG] v2.6.35-rc1 patches
Message-ID: <20100525091404.GX3972@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There still is one new watchdog driver sitting in my queue (imx2_wdt.c for freescale i.MX platform) but I'm not sure if I can sent that out on time.

iSo please allready pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/kernel-parameters.txt            |   15 
 Documentation/watchdog/00-INDEX                |    5 
 Documentation/watchdog/watchdog-parameters.txt |  390 +++++++++++++++++++++++++
 Documentation/watchdog/wdt.txt                 |   15 
 drivers/watchdog/Kconfig                       |   14 
 drivers/watchdog/bfin_wdt.c                    |   19 -
 drivers/watchdog/booke_wdt.c                   |    6 
 drivers/watchdog/eurotechwdt.c                 |    1 
 drivers/watchdog/iTCO_vendor_support.c         |   11 
 drivers/watchdog/iTCO_wdt.c                    |   29 +
 drivers/watchdog/mpc8xxx_wdt.c                 |    2 
 drivers/watchdog/pc87413_wdt.c                 |    9 
 drivers/watchdog/pnx833x_wdt.c                 |   11 
 drivers/watchdog/s3c2410_wdt.c                 |    9 
 drivers/watchdog/shwdt.c                       |    2 
 drivers/watchdog/twl4030_wdt.c                 |    2 
 drivers/watchdog/wdt.c                         |    2 
 drivers/watchdog/wdt977.c                      |    2 
 18 files changed, 468 insertions(+), 76 deletions(-)

with these Changes:

Author: Banajit Goswami <banajit.g@samsung.com>
Date:   Thu May 20 11:58:25 2010 +0100

    watchdog: s3c2410_wdt - Fix on handling of the request_mem_region fail
    
    If the request for wdt_mem region fails, this patch modifies the driver
    such that, it does not try to release the wdt_mem region on exit.
    
    Signed-off-by: Banajit Goswami <banajit.g@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Banajit Goswami <banajit.g@samsung.com>
Date:   Thu May 20 11:58:24 2010 +0100

    watchdog: s3c2410_wdt - Add extra option to include watchdog for Samsung SoCs
    
    This patch adds HAVE_S3C2410_WATCHDOG to control inclusion of watchdog driver
    for Samsung SoCs. This option will help to include the driver only for the
    necessary machines and not for all for any given arch.
    
    Signed-off-by: Banajit Goswami <banajit.g@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Pádraig Brady <P@draigBrady.com>
Date:   Mon Apr 19 13:38:25 2010 +0100

    iTCO_wdt: fix TCO V1 timeout values and limits
    
    For TCO V1 devices the programmed timeout was twice too long
    because the fact that the TCO V1 timer needs to count down
    twice before triggering the watchdog, wasn't accounted for.
    Also the timeout values in the module description and error
    message were clarified. And the _STS registers are 16 bit
    instead of 8 bit.
    
    Signed-off-by: Pádraig Brady <P@draigBrady.com>
    Tested-by: Simon Kagstrom <simon.kagstrom@netinsight.se>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ameya Palande <ameya.palande@nokia.com>
Date:   Mon May 17 14:12:15 2010 +0300

    watchdog: twl4030_wdt: Disable watchdog during probing
    
    If we are not able to register then it is better to have
    watchdog in disabled state than noticing a system reboot.
    
    Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
    Acked-By: Timo Kokkonen <timo.t.kokkonen@nokia.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon May 3 11:42:52 2010 -0700

    watchdog: update/improve/consolidate watchdog driver
    
    Move the limited watchdog driver help from kernel-parameters.txt
    to Documentation/watchdog/watchdog-parameters.txt and add info to it
    for all watchdog drivers except the ones that have driver-specific
    files already.
    
    Correct minor comments and MODULE_PARM_DESC() text in 2 places.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Apr 27 08:24:11 2010 +0000

    watchdog: booke_wdt: fix ioctl status flags
    
    The WDIOC_GETSTATUS & WDIOC_GETBOOTSTATUS ioctl calls return the WDIOF_* flags
    and nothing else.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Sat May 1 09:46:15 2010 -0700

    watchdog: fix several MODULE_PARM_DESC strings
    
    Fix MODULE_PARM_DESC() strings in several watchdog drivers.
    Some are simple as add a parenthesis.
    Others are problems from __stringify() being used on a
    variable name instead of a macro name, so the variable name
    is produced in the string instead of its build-time value.
    In these cases, create a macro for the value so that the
    module param description string is useful.
    
    Only pc87413_wdt has been built (due to toolchains).
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mike Frysinger <vapier@gentoo.org>
Date:   Tue Mar 9 11:07:40 2010 -0500

    watchdog: bfin: use new common Blackfin watchdog header
    
    use new common Blackfin watchdog header
    
    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f5fce48..b56ea86 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -290,9 +290,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	advansys=	[HW,SCSI]
 			See header of drivers/scsi/advansys.c.
 
-	advwdt=		[HW,WDT] Advantech WDT
-			Format: <iostart>,<iostop>
-
 	aedsp16=	[HW,OSS] Audio Excel DSP 16
 			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
 			See also header of sound/oss/aedsp16.c.
@@ -765,9 +762,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			This option is obsoleted by the "netdev=" option, which
 			has equivalent usage. See its documentation for details.
 
-	eurwdt=		[HW,WDT] Eurotech CPU-1220/1410 onboard watchdog.
-			Format: <io>[,<irq>]
-
 	failslab=
 	fail_page_alloc=
 	fail_make_request=[KNL]
@@ -2267,9 +2261,6 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
-	sc1200wdt=	[HW,WDT] SC1200 WDT (watchdog) driver
-			Format: <io>[,<timeout>[,<isapnp>]]
-
 	scsi_debug_*=	[SCSI]
 			See drivers/scsi/scsi_debug.c.
 
@@ -2858,8 +2849,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	wd7000=		[HW,SCSI]
 			See header of drivers/scsi/wd7000.c.
 
-	wdt=		[WDT] Watchdog
-			See Documentation/watchdog/wdt.txt.
+	watchdog timers	[HW,WDT] For information on watchdog timers,
+			see Documentation/watchdog/watchdog-parameters.txt
+			or other driver-specific files in the
+			Documentation/watchdog/ directory.
 
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-INDEX
index c3ea47e..ee99451 100644
--- a/Documentation/watchdog/00-INDEX
+++ b/Documentation/watchdog/00-INDEX
@@ -1,10 +1,15 @@
 00-INDEX
 	- this file.
+hpwdt.txt
+	- information on the HP iLO2 NMI watchdog
 pcwd-watchdog.txt
 	- documentation for Berkshire Products PC Watchdog ISA cards.
 src/
 	- directory holding watchdog related example programs.
 watchdog-api.txt
 	- description of the Linux Watchdog driver API.
+watchdog-parameters.txt
+	- information on driver parameters (for drivers other than
+	  the ones that have driver-specific files here)
 wdt.txt
 	- description of the Watchdog Timer Interfaces for Linux.
diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
new file mode 100644
index 0000000..41c95cc
--- /dev/null
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -0,0 +1,390 @@
+This file provides information on the module parameters of many of
+the Linux watchdog drivers.  Watchdog driver parameter specs should
+be listed here unless the driver has its own driver-specific information
+file.
+
+
+See Documentation/kernel-parameters.txt for information on
+providing kernel parameters for builtin drivers versus loadable
+modules.
+
+
+-------------------------------------------------
+acquirewdt:
+wdt_stop: Acquire WDT 'stop' io port (default 0x43)
+wdt_start: Acquire WDT 'start' io port (default 0x443)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+advantechwdt:
+wdt_stop: Advantech WDT 'stop' io port (default 0x443)
+wdt_start: Advantech WDT 'start' io port (default 0x443)
+timeout: Watchdog timeout in seconds. 1<= timeout <=63, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+alim1535_wdt:
+timeout: Watchdog timeout in seconds. (0 < timeout < 18000, default=60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+alim7101_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=30
+use_gpio: Use the gpio watchdog (required by old cobalt boards).
+	default=0/off/no
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ar7_wdt:
+margin: Watchdog margin in seconds (default=60)
+nowayout: Disable watchdog shutdown on close
+	(default=kernel config parameter)
+-------------------------------------------------
+at32ap700x_wdt:
+timeout: Timeout value. Limited to be 1 or 2 seconds. (default=2)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+at91rm9200_wdt:
+wdt_time: Watchdog time in seconds. (default=5)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+at91sam9_wdt:
+heartbeat: Watchdog heartbeats in seconds. (default = 15)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+bcm47xx_wdt:
+wdt_time: Watchdog time in seconds. (default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+bfin_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=20)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+coh901327_wdt:
+margin: Watchdog margin in seconds (default 60s)
+-------------------------------------------------
+cpu5wdt:
+port: base address of watchdog card, default is 0x91
+verbose: be verbose, default is 0 (no)
+ticks: count down ticks, default is 10000
+-------------------------------------------------
+cpwd:
+wd0_timeout: Default watchdog0 timeout in 1/10secs
+wd1_timeout: Default watchdog1 timeout in 1/10secs
+wd2_timeout: Default watchdog2 timeout in 1/10secs
+-------------------------------------------------
+davinci_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 600, default 60
+-------------------------------------------------
+ep93xx_wdt:
+nowayout: Watchdog cannot be stopped once started
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=TBD)
+-------------------------------------------------
+eurotechwdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+io: Eurotech WDT io port (default=0x3f0)
+irq: Eurotech WDT irq (default=10)
+ev: Eurotech WDT event type (default is `int')
+-------------------------------------------------
+gef_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+geodewdt:
+timeout: Watchdog timeout in seconds. 1<= timeout <=131, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+i6300esb:
+heartbeat: Watchdog heartbeat in seconds. (1<heartbeat<2046, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+iTCO_wdt:
+heartbeat: Watchdog heartbeat in seconds.
+	(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+iTCO_vendor_support:
+vendorsupport: iTCO vendor specific support mode, default=0 (none),
+	1=SuperMicro Pent3, 2=SuperMicro Pent4+, 911=Broken SMI BIOS
+-------------------------------------------------
+ib700wdt:
+timeout: Watchdog timeout in seconds. 0<= timeout <=30, default=30.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ibmasr:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+indydog:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+iop_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+it8712f_wdt:
+margin: Watchdog margin in seconds (default 60)
+nowayout: Disable watchdog shutdown on close
+	(default=kernel config parameter)
+-------------------------------------------------
+it87_wdt:
+nogameport: Forbid the activation of game port, default=0
+exclusive: Watchdog exclusive device open, default=1
+timeout: Watchdog timeout in seconds, default=60
+testmode: Watchdog test mode (1 = no reboot), default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ixp2000_wdt:
+heartbeat: Watchdog heartbeat in seconds (default 60s)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ixp4xx_wdt:
+heartbeat: Watchdog heartbeat in seconds (default 60s)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+ks8695_wdt:
+wdt_time: Watchdog time in seconds. (default=5)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+machzwd:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+action: after watchdog resets, generate:
+	0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI
+-------------------------------------------------
+max63xx_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 60, default 60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+nodelay: Force selection of a timeout setting without initial delay
+	(max6373/74 only, default=0)
+-------------------------------------------------
+mixcomwd:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+mpc8xxx_wdt:
+timeout: Watchdog timeout in ticks. (0<timeout<65536, default=65535)
+reset: Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+mpcore_wdt:
+mpcore_margin: MPcore timer margin in seconds.
+	(0 < mpcore_margin < 65536, default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+mpcore_noboot: MPcore watchdog action, set to 1 to ignore reboots,
+	0 to reboot (default=0
+-------------------------------------------------
+mv64x60_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+nuc900_wdt:
+heartbeat: Watchdog heartbeats in seconds.
+	(default = 15)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+omap_wdt:
+timer_margin: initial watchdog timeout (in seconds)
+-------------------------------------------------
+orion_wdt:
+heartbeat: Initial watchdog heartbeat in seconds
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+pc87413_wdt:
+io: pc87413 WDT I/O port (default: io).
+timeout: Watchdog timeout in minutes (default=timeout).
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+pika_wdt:
+heartbeat: Watchdog heartbeats in seconds. (default = 15)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+pnx4008_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 60, default 19
+nowayout: Set to 1 to keep watchdog running after device release
+-------------------------------------------------
+pnx833x_wdt:
+timeout: Watchdog timeout in Mhz. (68Mhz clock), default=2040000000 (30 seconds)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+start_enabled: Watchdog is started on module insertion (default=1)
+-------------------------------------------------
+rc32434_wdt:
+timeout: Watchdog timeout value, in seconds (default=20)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+riowd:
+riowd_timeout: Watchdog timeout in minutes (default=1)
+-------------------------------------------------
+s3c2410_wdt:
+tmr_margin: Watchdog tmr_margin in seconds. (default=15)
+tmr_atboot: Watchdog is started at boot time if set to 1, default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+soft_noboot: Watchdog action, set to 1 to ignore reboots, 0 to reboot
+debug: Watchdog debug, set to >1 for debug, (default 0)
+-------------------------------------------------
+sa1100_wdt:
+margin: Watchdog margin in seconds (default 60s)
+-------------------------------------------------
+sb_wdog:
+timeout: Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)
+-------------------------------------------------
+sbc60xxwdt:
+wdt_stop: SBC60xx WDT 'stop' io port (default 0x45)
+wdt_start: SBC60xx WDT 'start' io port (default 0x443)
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sbc7240_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=255, default=30)
+nowayout: Disable watchdog when closing device file
+-------------------------------------------------
+sbc8360:
+timeout: Index into timeout table (0-63) (default=27 (60s))
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sbc_epx_c3:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sbc_fitpc2_wdt:
+margin: Watchdog margin in seconds (default 60s)
+nowayout: Watchdog cannot be stopped once started
+-------------------------------------------------
+sc1200wdt:
+isapnp: When set to 0 driver ISA PnP support will be disabled (default=1)
+io: io port
+timeout: range is 0-255 minutes, default is 1
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sc520_wdt:
+timeout: Watchdog timeout in seconds. (1 <= timeout <= 3600, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+sch311x_wdt:
+force_id: Override the detected device ID
+therm_trip: Should a ThermTrip trigger the reset generator
+timeout: Watchdog timeout in seconds. 1<= timeout <=15300, default=60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+scx200_wdt:
+margin: Watchdog margin in seconds
+nowayout: Disable watchdog shutdown on close
+-------------------------------------------------
+shwdt:
+clock_division_ratio: Clock division ratio. Valid ranges are from 0x5 (1.31ms)
+	to 0x7 (5.25ms). (default=7)
+heartbeat: Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default=30
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+smsc37b787_wdt:
+timeout: range is 1-255 units, default is 60
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+softdog:
+soft_margin: Watchdog soft_margin in seconds.
+	(0 < soft_margin < 65536, default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+soft_noboot: Softdog action, set to 1 to ignore reboots, 0 to reboot
+	(default=0)
+-------------------------------------------------
+stmp3xxx_wdt:
+heartbeat: Watchdog heartbeat period in seconds from 1 to 4194304, default 19
+-------------------------------------------------
+ts72xx_wdt:
+timeout: Watchdog timeout in seconds. (1 <= timeout <= 8, default=8)
+nowayout: Disable watchdog shutdown on close
+-------------------------------------------------
+twl4030_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+txx9wdt:
+timeout: Watchdog timeout in seconds. (0<timeout<N, default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83627hf_wdt:
+wdt_io: w83627hf/thf WDT io port (default 0x2E)
+timeout: Watchdog timeout in seconds. 1 <= timeout <= 255, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83697hf_wdt:
+wdt_io: w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)
+timeout: Watchdog timeout in seconds. 1<= timeout <=255 (default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+early_disable: Watchdog gets disabled at boot time (default=1)
+-------------------------------------------------
+w83697ug_wdt:
+wdt_io: w83697ug/uf WDT io port (default 0x2e)
+timeout: Watchdog timeout in seconds. 1<= timeout <=255 (default=60)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83877f_wdt:
+timeout: Watchdog timeout in seconds. (1<=timeout<=3600, default=30)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+w83977f_wdt:
+timeout: Watchdog timeout in seconds (15..7635), default=45)
+testmode: Watchdog testmode (1 = no reboot), default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wafer5823wdt:
+timeout: Watchdog timeout in seconds. 1 <= timeout <= 255, default=60.
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wdt285:
+soft_margin: Watchdog timeout in seconds (default=60)
+-------------------------------------------------
+wdt977:
+timeout: Watchdog timeout in seconds (60..15300, default=60)
+testmode: Watchdog testmode (1 = no reboot), default=0
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wm831x_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
+wm8350_wdt:
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
diff --git a/Documentation/watchdog/wdt.txt b/Documentation/watchdog/wdt.txt
index 03fd756..061c2e3 100644
--- a/Documentation/watchdog/wdt.txt
+++ b/Documentation/watchdog/wdt.txt
@@ -14,14 +14,22 @@ reboot will depend on the state of the machines and interrupts. The hardware
 boards physically pull the machine down off their own onboard timers and
 will reboot from almost anything.
 
-A second temperature monitoring interface is available on the WDT501P cards
+A second temperature monitoring interface is available on the WDT501P cards.
 This provides /dev/temperature. This is the machine internal temperature in
 degrees Fahrenheit. Each read returns a single byte giving the temperature.
 
 The third interface logs kernel messages on additional alert events.
 
-The wdt card cannot be safely probed for. Instead you need to pass
-wdt=ioaddr,irq as a boot parameter - eg "wdt=0x240,11".
+The ICS ISA-bus wdt card cannot be safely probed for. Instead you need to
+pass IO address and IRQ boot parameters.  E.g.:
+	wdt.io=0x240 wdt.irq=11
+
+Other "wdt" driver parameters are:
+	heartbeat	Watchdog heartbeat in seconds (default 60)
+	nowayout	Watchdog cannot be stopped once started (kernel
+				build parameter)
+	tachometer	WDT501-P Fan Tachometer support (0=disable, default=0)
+	type		WDT501-P Card type (500 or 501, default=500)
 
 Features
 --------
@@ -40,4 +48,3 @@ Minor numbers are however allocated for it.
 
 
 Example Watchdog Driver:  see Documentation/watchdog/src/watchdog-simple.c
-
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b87ba23..c57ecff 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -145,13 +145,19 @@ config KS8695_WATCHDOG
 	  Watchdog timer embedded into KS8695 processor. This will reboot your
 	  system when the timeout is reached.
 
+config HAVE_S3C2410_WATCHDOG
+	bool
+	help
+	  This will include watchdog timer support for Samsung SoCs. If
+	  you want to include watchdog support for any machine, kindly
+	  select this in the respective mach-XXXX/Kconfig file.
+
 config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
-	depends on ARCH_S3C2410
+	depends on ARCH_S3C2410 || HAVE_S3C2410_WATCHDOG
 	help
-	  Watchdog timer block in the Samsung S3C2410 chips. This will
-	  reboot the system when the timer expires with the watchdog
-	  enabled.
+	  Watchdog timer block in the Samsung SoCs. This will reboot
+	  the system when the timer expires with the watchdog enabled.
 
 	  The driver is limited by the speed of the system's PCLK
 	  signal, so with reasonably fast systems (PCLK around 50-66MHz)
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 9c7ccd1..9042a95 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <asm/blackfin.h>
+#include <asm/bfin_watchdog.h>
 
 #define stamp(fmt, args...) \
 	pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
@@ -49,24 +50,6 @@
 # define bfin_write_WDOG_STAT(x) bfin_write_WDOGA_STAT(x)
 #endif
 
-/* Bit in SWRST that indicates boot caused by watchdog */
-#define SWRST_RESET_WDOG 0x4000
-
-/* Bit in WDOG_CTL that indicates watchdog has expired (WDR0) */
-#define WDOG_EXPIRED 0x8000
-
-/* Masks for WDEV field in WDOG_CTL register */
-#define ICTL_RESET   0x0
-#define ICTL_NMI     0x2
-#define ICTL_GPI     0x4
-#define ICTL_NONE    0x6
-#define ICTL_MASK    0x6
-
-/* Masks for WDEN field in WDOG_CTL register */
-#define WDEN_MASK    0x0FF0
-#define WDEN_ENABLE  0x0000
-#define WDEN_DISABLE 0x0AD0
-
 /* some defaults */
 #define WATCHDOG_TIMEOUT 20
 
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 801ead1..3d49671 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -137,12 +137,12 @@ static long booke_wdt_ioctl(struct file *file,
 		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
-		return put_user(ident.options, p);
+		return put_user(0, p);
 	case WDIOC_GETBOOTSTATUS:
 		/* XXX: something is clearing TSR */
 		tmp = mfspr(SPRN_TSR) & TSR_WRS(3);
-		/* returns 1 if last reset was caused by the WDT */
-		return (tmp ? 1 : 0);
+		/* returns CARDRESET if last reset was caused by the WDT */
+		return (tmp ? WDIOF_CARDRESET : 0);
 	case WDIOC_SETOPTIONS:
 		if (get_user(tmp, p))
 			return -EINVAL;
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index d1c4e55..3f3dc09 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -68,7 +68,6 @@ static spinlock_t eurwdt_lock;
 
 /*
  * You must set these - there is no sane way to probe for this board.
- * You can use eurwdt=x,y to set these now.
  */
 
 static int io = 0x3f0;
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index 5133bca..481d1ad 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -101,13 +101,6 @@ static void supermicro_old_pre_stop(unsigned long acpibase)
 	outl(val32, SMI_EN);	/* Needed to deactivate watchdog */
 }
 
-static void supermicro_old_pre_keepalive(unsigned long acpibase)
-{
-	/* Reload TCO Timer (done in iTCO_wdt_keepalive) + */
-	/* Clear "Expire Flag" (Bit 3 of TC01_STS register) */
-	outb(0x08, TCO1_STS);
-}
-
 /*
  *	Vendor Support: 2
  *	Board: Super Micro Computer Inc. P4SBx, P4DPx
@@ -337,9 +330,7 @@ EXPORT_SYMBOL(iTCO_vendor_pre_stop);
 
 void iTCO_vendor_pre_keepalive(unsigned long acpibase, unsigned int heartbeat)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
-		supermicro_old_pre_keepalive(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+	if (vendorsupport == SUPERMICRO_NEW_BOARD)
 		supermicro_new_pre_set_heartbeat(heartbeat);
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_keepalive);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 8da8860..69de871 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -40,7 +40,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.05"
+#define DRV_VERSION	"1.06"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -391,8 +391,8 @@ static struct platform_device *iTCO_wdt_platform_device;
 #define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
-	"(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default="
+MODULE_PARM_DESC(heartbeat, "Watchdog timeout in seconds. "
+	"5..76 (TCO v1) or 3..614 (TCO v2), default="
 				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
@@ -523,8 +523,13 @@ static int iTCO_wdt_keepalive(void)
 	/* Reload the timer by writing to the TCO Timer Counter register */
 	if (iTCO_wdt_private.iTCO_version == 2)
 		outw(0x01, TCO_RLD);
-	else if (iTCO_wdt_private.iTCO_version == 1)
+	else if (iTCO_wdt_private.iTCO_version == 1) {
+		/* Reset the timeout status bit so that the timer
+		 * needs to count down twice again before rebooting */
+		outw(0x0008, TCO1_STS);	/* write 1 to clear bit */
+
 		outb(0x01, TCO_RLD);
+	}
 
 	spin_unlock(&iTCO_wdt_private.io_lock);
 	return 0;
@@ -537,6 +542,11 @@ static int iTCO_wdt_set_heartbeat(int t)
 	unsigned int tmrval;
 
 	tmrval = seconds_to_ticks(t);
+
+	/* For TCO v1 the timer counts down twice before rebooting */
+	if (iTCO_wdt_private.iTCO_version == 1)
+		tmrval /= 2;
+
 	/* from the specs: */
 	/* "Values of 0h-3h are ignored and should not be attempted" */
 	if (tmrval < 0x04)
@@ -593,6 +603,8 @@ static int iTCO_wdt_get_timeleft(int *time_left)
 		spin_lock(&iTCO_wdt_private.io_lock);
 		val8 = inb(TCO_RLD);
 		val8 &= 0x3f;
+		if (!(inw(TCO1_STS) & 0x0008))
+			val8 += (inb(TCOv1_TMR) & 0x3f);
 		spin_unlock(&iTCO_wdt_private.io_lock);
 
 		*time_left = (val8 * 6) / 10;
@@ -832,9 +844,9 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 			TCOBASE);
 
 	/* Clear out the (probably old) status */
-	outb(8, TCO1_STS);	/* Clear the Time Out Status bit */
-	outb(2, TCO2_STS);	/* Clear SECOND_TO_STS bit */
-	outb(4, TCO2_STS);	/* Clear BOOT_STS bit */
+	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */
+	outw(0x0002, TCO2_STS);	/* Clear SECOND_TO_STS bit */
+	outw(0x0004, TCO2_STS);	/* Clear BOOT_STS bit */
 
 	/* Make sure the watchdog is not running */
 	iTCO_wdt_stop();
@@ -844,8 +856,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
 		printk(KERN_INFO PFX
-			"heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
-				"or 613 (TCO v2), using %d\n", heartbeat);
+			"timeout value out of range, using %d\n", heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 7b55974..6622335 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -53,7 +53,7 @@ static int mpc8xxx_wdt_init_late(void);
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
 MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535)");
 
 static int reset = 1;
 module_param(reset, bool, 0);
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index d3aa2f1..3a56bc3 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -53,7 +53,9 @@
 #define WDTO                0x11	/* Watchdog timeout register */
 #define WDCFG               0x12	/* Watchdog config register */
 
-static int io = 0x2E;			/* Address used on Portwell Boards */
+#define IO_DEFAULT	0x2E		/* Address used on Portwell Boards */
+
+static int io = IO_DEFAULT;
 
 static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
 static unsigned long timer_enabled;	/* is the timer enabled? */
@@ -583,12 +585,13 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(io, int, 0);
-MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(io) ").");
+MODULE_PARM_DESC(io, MODNAME " I/O port (default: "
+					__MODULE_STRING(IO_DEFAULT) ").");
 
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
 		"Watchdog timeout in minutes (default="
-				__MODULE_STRING(timeout) ").");
+				__MODULE_STRING(DEFAULT_TIMEOUT) ").");
 
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index 09102f0..a7b5ad2 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -33,6 +33,8 @@
 #define PFX "pnx833x: "
 #define WATCHDOG_TIMEOUT 30		/* 30 sec Maximum timeout */
 #define WATCHDOG_COUNT_FREQUENCY 68000000U /* Watchdog counts at 68MHZ. */
+#define	PNX_WATCHDOG_TIMEOUT	(WATCHDOG_TIMEOUT * WATCHDOG_COUNT_FREQUENCY)
+#define PNX_TIMEOUT_VALUE	2040000000U
 
 /** CONFIG block */
 #define PNX833X_CONFIG                      (0x07000U)
@@ -47,20 +49,21 @@
 static int pnx833x_wdt_alive;
 
 /* Set default timeout in MHZ.*/
-static int pnx833x_wdt_timeout = (WATCHDOG_TIMEOUT * WATCHDOG_COUNT_FREQUENCY);
+static int pnx833x_wdt_timeout = PNX_WATCHDOG_TIMEOUT;
 module_param(pnx833x_wdt_timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout in Mhz. (68Mhz clock), default="
-			__MODULE_STRING(pnx833x_wdt_timeout) "(30 seconds).");
+			__MODULE_STRING(PNX_TIMEOUT_VALUE) "(30 seconds).");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 					__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static int start_enabled = 1;
+#define START_DEFAULT	1
+static int start_enabled = START_DEFAULT;
 module_param(start_enabled, int, 0);
 MODULE_PARM_DESC(start_enabled, "Watchdog is started on module insertion "
-				"(default=" __MODULE_STRING(start_enabled) ")");
+				"(default=" __MODULE_STRING(START_DEFAULT) ")");
 
 static void pnx833x_wdt_start(void)
 {
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index e4cebef..3009325 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -63,7 +63,7 @@ module_param(nowayout,    int, 0);
 module_param(soft_noboot, int, 0);
 module_param(debug,	  int, 0);
 
-MODULE_PARM_DESC(tmr_margin, "Watchdog tmr_margin in seconds. default="
+MODULE_PARM_DESC(tmr_margin, "Watchdog tmr_margin in seconds. (default="
 		__MODULE_STRING(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME) ")");
 MODULE_PARM_DESC(tmr_atboot,
 		"Watchdog is started at boot time if set to 1, default="
@@ -71,8 +71,8 @@ MODULE_PARM_DESC(tmr_atboot,
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 			__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
-			"0 to reboot (default depends on ONLY_TESTING)");
-MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug, (default 0)");
+			"0 to reboot (default 0)");
+MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
 
 static unsigned long open_lock;
 static struct device    *wdt_dev;	/* platform device attached to */
@@ -426,8 +426,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region\n");
-		ret = -ENOENT;
-		goto err_req;
+		return -EBUSY;
 	}
 
 	wdt_base = ioremap(res->start, size);
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index a03f84e..6fc7406 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -496,7 +496,7 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 module_param(clock_division_ratio, int, 0);
 MODULE_PARM_DESC(clock_division_ratio,
 	"Clock division ratio. Valid ranges are from 0x5 (1.31ms) "
-	"to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
+	"to 0x7 (5.25ms). (default=" __MODULE_STRING(WTCSR_CKS_4096) ")");
 
 module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat,
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
index dcabe77..b5045ca 100644
--- a/drivers/watchdog/twl4030_wdt.c
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -190,6 +190,8 @@ static int __devinit twl4030_wdt_probe(struct platform_device *pdev)
 
 	twl4030_wdt_dev = pdev;
 
+	twl4030_wdt_disable(wdt);
+
 	ret = misc_register(&wdt->miscdev);
 	if (ret) {
 		dev_err(wdt->miscdev.parent,
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index bfda2e9..552a438 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(tachometer,
 static int type = 500;
 module_param(type, int, 0);
 MODULE_PARM_DESC(type,
-		"WDT501-P Card type (500 or 501 , default=500)");
+		"WDT501-P Card type (500 or 501, default=500)");
 
 /*
  *	Programming support
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 90ef70e..5c2521f 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -63,7 +63,7 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300), default="
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300, default="
 				__MODULE_STRING(DEFAULT_TIMEOUT) ")");
 module_param(testmode, int, 0);
 MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default=0");
