Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab0DFQwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:52:46 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:5575 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756926Ab0DFQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:52:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOoBu0tbstaW/2dsb2JhbACbOnK7MA2CSYIzBINA
Date: Tue, 6 Apr 2010 18:52:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Marc Zyngier <maz@misterjones.org>, Giel van Schijndel <me@mortis.eu>,
       James Hogan <james.hogan@imgtec.com>,
       Seth Heasley <seth.heasley@intel.com>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: [WATCHDOG] v2.6.34-rc4 fixes
Message-ID: <20100406165237.GM3823@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/src/watchdog-simple.c |    3 
 Documentation/watchdog/src/watchdog-test.c   |    8 +-
 Documentation/watchdog/watchdog-api.txt      |    5 -
 drivers/watchdog/Kconfig                     |   11 +--
 drivers/watchdog/hpwdt.c                     |    2 
 drivers/watchdog/iTCO_wdt.c                  |   99 +++++++++++++++++++++++++--
 drivers/watchdog/pika_wdt.c                  |    2 
 7 files changed, 109 insertions(+), 21 deletions(-)

with these Changes:

Author: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Date:   Wed Mar 17 15:33:31 2010 +0000

    [WATCHDOG] hpwdt - fix lower timeout limit
    
    [Novell Bug 581103] HP Watchdog driver has arbitrary (wrong) timeout limits.
    Fix the lower timeout limit to a more appropriate value.
    
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Thu Mar 25 16:14:41 2010 -0700

    [WATCHDOG] iTCO_wdt: TCO Watchdog patch for additional Intel Cougar Point DeviceIDs
    
    This patch adds the Intel Cougar Point PCH LPC Controller DeviceIDs for iTCO Watchdog.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

Author: James Hogan <james.hogan@imgtec.com>
Date:   Mon Apr 5 11:31:29 2010 +0100

    [WATCHDOG] doc: Fix use of WDIOC_SETOPTIONS ioctl.
    
    In the watchdog-test program and watchdog-api.txt, pass the values to
    the WDIOC_SETOPTIONS ioctl as a pointer to an integer containing the
    values intead of directly in the third ioctl argument. The actual
    watchdog drivers in drivers/watchdog don't read the options directly
    from the argument but use get_user and copy_from_user.
    
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Giel van Schijndel <me@mortis.eu>
Date:   Mon Mar 29 21:12:09 2010 +0200

    [WATCHDOG] doc: watchdog simple example: don't fail on fsync()
    
    Don't terminate the watchdog daemon when fsync() fails because no
    watchdog driver actually implements the fsync() syscall.
    
    Signed-off-by: Giel van Schijndel <me@mortis.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Marc Zyngier <maz@misterjones.org>
Date:   Mon Mar 29 20:09:14 2010 +0100

    [WATCHDOG] set max63xx driver as ARM only
    
    Use of ioremap() causes build failure on S390.
    Restrict the driver to ARM until another architecture comes along
    and enables the driver for its own use.
    
    Signed-off-by: Marc Zyngier <maz@misterjones.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Sean MacLennan <smaclennan@pikatech.com>
Date:   Mon Mar 8 19:46:41 2010 -0500

    [WATCHDOG] powerpc: pika_wdt ident cannot be const
    
    The watchdog_info struct cannot be a const since we dynamically fill
    in the firmware version.
    
    Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/src/watchdog-simple.c b/Documentation/watchdog/src/watchdog-simple.c
index 4cf72f3..ba45803 100644
--- a/Documentation/watchdog/src/watchdog-simple.c
+++ b/Documentation/watchdog/src/watchdog-simple.c
@@ -17,9 +17,6 @@ int main(void)
 			ret = -1;
 			break;
 		}
-		ret = fsync(fd);
-		if (ret)
-			break;
 		sleep(10);
 	}
 	close(fd);
diff --git a/Documentation/watchdog/src/watchdog-test.c b/Documentation/watchdog/src/watchdog-test.c
index a750532..63fdc34 100644
--- a/Documentation/watchdog/src/watchdog-test.c
+++ b/Documentation/watchdog/src/watchdog-test.c
@@ -31,6 +31,8 @@ static void keep_alive(void)
  */
 int main(int argc, char *argv[])
 {
+    int flags;
+
     fd = open("/dev/watchdog", O_WRONLY);
 
     if (fd == -1) {
@@ -41,12 +43,14 @@ int main(int argc, char *argv[])
 
     if (argc > 1) {
 	if (!strncasecmp(argv[1], "-d", 2)) {
-	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_DISABLECARD);
+	    flags = WDIOS_DISABLECARD;
+	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card disabled.\n");
 	    fflush(stderr);
 	    exit(0);
 	} else if (!strncasecmp(argv[1], "-e", 2)) {
-	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_ENABLECARD);
+	    flags = WDIOS_ENABLECARD;
+	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card enabled.\n");
 	    fflush(stderr);
 	    exit(0);
diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index 4cc4ba9..eb7132e 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -222,11 +222,10 @@ returned value is the temperature in degrees fahrenheit.
     ioctl(fd, WDIOC_GETTEMP, &temperature);
 
 Finally the SETOPTIONS ioctl can be used to control some aspects of
-the cards operation; right now the pcwd driver is the only one
-supporting this ioctl.
+the cards operation.
 
     int options = 0;
-    ioctl(fd, WDIOC_SETOPTIONS, options);
+    ioctl(fd, WDIOC_SETOPTIONS, &options);
 
 The following options are available:
 
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index bdcdbd5..0e8468f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,11 +55,6 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
-config MAX63XX_WATCHDOG
-       tristate "Max63xx watchdog"
-       help
-         Support for memory mapped max63{69,70,71,72,73,74} watchdog timer.
-
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
@@ -305,6 +300,12 @@ config TS72XX_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called ts72xx_wdt.
 
+config MAX63XX_WATCHDOG
+	tristate "Max63xx watchdog"
+	depends on ARM
+	help
+	  Support for memory mapped max63{69,70,71,72,73,74} watchdog timer.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 70c2c24..af48075 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -443,7 +443,7 @@ static void hpwdt_ping(void)
 static int hpwdt_change_timer(int new_margin)
 {
 	/* Arbitrary, can't find the card's limits */
-	if (new_margin < 30 || new_margin > 600) {
+	if (new_margin < 5 || new_margin > 600) {
 		printk(KERN_WARNING
 			"hpwdt: New value passed in is invalid: %d seconds.\n",
 			new_margin);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 44bc6aa..8da8860 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -115,8 +115,37 @@ enum iTCO_chipsets {
 	TCO_3420,	/* 3420 */
 	TCO_3450,	/* 3450 */
 	TCO_EP80579,	/* EP80579 */
-	TCO_CPTD,	/* CPT Desktop */
-	TCO_CPTM,	/* CPT Mobile */
+	TCO_CPT1,	/* Cougar Point */
+	TCO_CPT2,	/* Cougar Point Desktop */
+	TCO_CPT3,	/* Cougar Point Mobile */
+	TCO_CPT4,	/* Cougar Point */
+	TCO_CPT5,	/* Cougar Point */
+	TCO_CPT6,	/* Cougar Point */
+	TCO_CPT7,	/* Cougar Point */
+	TCO_CPT8,	/* Cougar Point */
+	TCO_CPT9,	/* Cougar Point */
+	TCO_CPT10,	/* Cougar Point */
+	TCO_CPT11,	/* Cougar Point */
+	TCO_CPT12,	/* Cougar Point */
+	TCO_CPT13,	/* Cougar Point */
+	TCO_CPT14,	/* Cougar Point */
+	TCO_CPT15,	/* Cougar Point */
+	TCO_CPT16,	/* Cougar Point */
+	TCO_CPT17,	/* Cougar Point */
+	TCO_CPT18,	/* Cougar Point */
+	TCO_CPT19,	/* Cougar Point */
+	TCO_CPT20,	/* Cougar Point */
+	TCO_CPT21,	/* Cougar Point */
+	TCO_CPT22,	/* Cougar Point */
+	TCO_CPT23,	/* Cougar Point */
+	TCO_CPT24,	/* Cougar Point */
+	TCO_CPT25,	/* Cougar Point */
+	TCO_CPT26,	/* Cougar Point */
+	TCO_CPT27,	/* Cougar Point */
+	TCO_CPT28,	/* Cougar Point */
+	TCO_CPT29,	/* Cougar Point */
+	TCO_CPT30,	/* Cougar Point */
+	TCO_CPT31,	/* Cougar Point */
 };
 
 static struct {
@@ -173,8 +202,37 @@ static struct {
 	{"3420", 2},
 	{"3450", 2},
 	{"EP80579", 2},
-	{"CPT Desktop", 2},
-	{"CPT Mobile", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
+	{"Cougar Point", 2},
 	{NULL, 0}
 };
 
@@ -259,8 +317,37 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x3b14,				TCO_3420)},
 	{ ITCO_PCI_DEVICE(0x3b16,				TCO_3450)},
 	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
-	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPTD)},
-	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPTM)},
+	{ ITCO_PCI_DEVICE(0x1c41,				TCO_CPT1)},
+	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPT2)},
+	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPT3)},
+	{ ITCO_PCI_DEVICE(0x1c44,				TCO_CPT4)},
+	{ ITCO_PCI_DEVICE(0x1c45,				TCO_CPT5)},
+	{ ITCO_PCI_DEVICE(0x1c46,				TCO_CPT6)},
+	{ ITCO_PCI_DEVICE(0x1c47,				TCO_CPT7)},
+	{ ITCO_PCI_DEVICE(0x1c48,				TCO_CPT8)},
+	{ ITCO_PCI_DEVICE(0x1c49,				TCO_CPT9)},
+	{ ITCO_PCI_DEVICE(0x1c4a,				TCO_CPT10)},
+	{ ITCO_PCI_DEVICE(0x1c4b,				TCO_CPT11)},
+	{ ITCO_PCI_DEVICE(0x1c4c,				TCO_CPT12)},
+	{ ITCO_PCI_DEVICE(0x1c4d,				TCO_CPT13)},
+	{ ITCO_PCI_DEVICE(0x1c4e,				TCO_CPT14)},
+	{ ITCO_PCI_DEVICE(0x1c4f,				TCO_CPT15)},
+	{ ITCO_PCI_DEVICE(0x1c50,				TCO_CPT16)},
+	{ ITCO_PCI_DEVICE(0x1c51,				TCO_CPT17)},
+	{ ITCO_PCI_DEVICE(0x1c52,				TCO_CPT18)},
+	{ ITCO_PCI_DEVICE(0x1c53,				TCO_CPT19)},
+	{ ITCO_PCI_DEVICE(0x1c54,				TCO_CPT20)},
+	{ ITCO_PCI_DEVICE(0x1c55,				TCO_CPT21)},
+	{ ITCO_PCI_DEVICE(0x1c56,				TCO_CPT22)},
+	{ ITCO_PCI_DEVICE(0x1c57,				TCO_CPT23)},
+	{ ITCO_PCI_DEVICE(0x1c58,				TCO_CPT24)},
+	{ ITCO_PCI_DEVICE(0x1c59,				TCO_CPT25)},
+	{ ITCO_PCI_DEVICE(0x1c5a,				TCO_CPT26)},
+	{ ITCO_PCI_DEVICE(0x1c5b,				TCO_CPT27)},
+	{ ITCO_PCI_DEVICE(0x1c5c,				TCO_CPT28)},
+	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
+	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
+	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 435ec2a..2d22e99 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -52,7 +52,7 @@ static struct {
 	struct timer_list timer;	/* The timer that pings the watchdog */
 } pikawdt_private;
 
-static const struct watchdog_info ident = {
+static struct watchdog_info ident = {
 	.identity	= DRV_NAME,
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_SETTIMEOUT |
