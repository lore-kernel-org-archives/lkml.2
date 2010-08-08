Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0HHSbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 14:31:13 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:61101 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896Ab0HHSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 14:31:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFuTXkxQycCH/2dsb2JhbACgQ3LAFg2CZIJJBA
Date: Sun, 8 Aug 2010 20:31:03 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Giel van Schijndel <me@mortis.eu>, Viresh KUMAR <viresh.kumar@st.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v2.6.36-rc1 - part 1
Message-ID: <20100808183103.GC4288@infomag.iguana.be>
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

(note part 2 should normaly be for tuesday: it will contain hpwdt.c changes).

This will update the following files:

 drivers/watchdog/Kconfig       |   18 
 drivers/watchdog/Makefile      |    2 
 drivers/watchdog/f71808e_wdt.c |  768 +++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/hpwdt.c       |    4 
 drivers/watchdog/s3c2410_wdt.c |   17 
 drivers/watchdog/sch311x_wdt.c |    4 
 drivers/watchdog/sp805_wdt.c   |  387 ++++++++++++++++++++
 drivers/watchdog/wdt_pci.c     |   15 
 include/linux/pci_ids.h        |    3 
 9 files changed, 1192 insertions(+), 26 deletions(-)

with these Changes:

Author: Kulikov Vasiliy <segooon@gmail.com>
Date:   Wed Jul 14 22:06:30 2010 +0400

    watchdog: hpwdt: formatting of pointers in printk()
    
    Use %p instead of %08x in printk().
    
    Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Viresh KUMAR <viresh.kumar@st.com>
Date:   Wed Aug 4 11:44:14 2010 +0530

    watchdog: Adding support for ARM Primecell SP805 Watchdog
    
    Technical Reference Manual can be found at:
    http://infocenter.arm.com/help/topic/com.arm.doc.ddi0270b/DDI0270.pdf
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Giel van Schijndel <me@mortis.eu>
Date:   Sun Aug 1 15:30:55 2010 +0200

    watchdog: f71808e_wdt: new watchdog driver for Fintek F71808E and F71882FG
    
    Add a new watchdog driver for the Fintek F71808E and F71882FG Super I/O
    controllers.
    
    Signed-off-by: Giel van Schijndel <me@mortis.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jun 10 06:46:56 2010 +0000

    watchdog: sch311x_wdt.c: set parent before registeriing the misc device in probe() function
    
    Set the paranet of the misc_device before we register the misc_device.
    
    Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
    Signed-off-by: Wim Van sebroeck <wim@iguana.be>

Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Fri May 21 18:38:52 2010 -0500

    watchdog: wdt_pci.c: move ids to pci_ids.h
    
    Move the VENDOR/DEVICE ids to pci_ids.h.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri May 21 08:11:42 2010 +0000

    watchdog: s3c2410_wdt - Fix removing of platform device
    
    When removing the watchdog platform device, we need to
    disable the access to userspace first. It makes no sense
    to remove the drivers clock, irq's, ... and then disable
    userspace access.
    the order of removal has also been changed so that it
    is the reverse of probing (this way the clock is also
    disabled sooner).
    
    Cc: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b04b184..4d2992a 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -73,6 +73,13 @@ config WM8350_WATCHDOG
 
 # ARM Architecture
 
+config ARM_SP805_WATCHDOG
+	tristate "ARM SP805 Watchdog"
+	depends on ARM_AMBA
+	help
+	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
+	  the timeout is reached.
+
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
 	depends on ARCH_AT91RM9200
@@ -401,6 +408,17 @@ config ALIM7101_WDT
 
 	  Most people will say N.
 
+config F71808E_WDT
+	tristate "Fintek F71808E and F71882FG Watchdog"
+	depends on X86 && EXPERIMENTAL
+	help
+	  This is the driver for the hardware watchdog on the Fintek
+	  F71808E and F71882FG Super I/O controllers.
+
+	  You can compile this driver directly into the kernel, or use
+	  it as a module.  The module will be called f71808e_wdt.
+
+
 config GEODE_WDT
 	tristate "AMD Geode CS5535/CS5536 Watchdog"
 	depends on CS5535_MFGPT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index e30289a..8374503 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_USBPCWATCHDOG) += pcwd_usb.o
 # ALPHA Architecture
 
 # ARM Architecture
+obj-$(CONFIG_ARM_SP805_WATCHDOG) += sp805_wdt.o
 obj-$(CONFIG_AT91RM9200_WATCHDOG) += at91rm9200_wdt.o
 obj-$(CONFIG_AT91SAM9X_WATCHDOG) += at91sam9_wdt.o
 obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
@@ -66,6 +67,7 @@ obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
 obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
+obj-$(CONFIG_F71808E_WDT) += f71808e_wdt.o
 obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
new file mode 100644
index 0000000..7e5c266
--- /dev/null
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -0,0 +1,768 @@
+/***************************************************************************
+ *   Copyright (C) 2006 by Hans Edgington <hans@edgington.nl>              *
+ *   Copyright (C) 2007-2009 Hans de Goede <hdegoede@redhat.com>           *
+ *   Copyright (C) 2010 Giel van Schijndel <me@mortis.eu>                  *
+ *                                                                         *
+ *   This program is free software; you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation; either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
+ *   GNU General Public License for more details.                          *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this program; if not, write to the                         *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+#define DRVNAME "f71808e_wdt"
+
+#define SIO_F71808FG_LD_WDT	0x07	/* Watchdog timer logical device */
+#define SIO_UNLOCK_KEY		0x87	/* Key to enable Super-I/O */
+#define SIO_LOCK_KEY		0xAA	/* Key to diasble Super-I/O */
+
+#define SIO_REG_LDSEL		0x07	/* Logical device select */
+#define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
+#define SIO_REG_DEVREV		0x22	/* Device revision */
+#define SIO_REG_MANID		0x23	/* Fintek ID (2 bytes) */
+#define SIO_REG_ENABLE		0x30	/* Logical device enable */
+#define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
+
+#define SIO_FINTEK_ID		0x1934	/* Manufacturers ID */
+#define SIO_F71808_ID		0x0901  /* Chipset ID */
+#define SIO_F71858_ID		0x0507  /* Chipset ID */
+#define SIO_F71862_ID		0x0601	/* Chipset ID */
+#define SIO_F71882_ID		0x0541	/* Chipset ID */
+#define SIO_F71889_ID		0x0723	/* Chipset ID */
+
+#define	F71882FG_REG_START		0x01
+
+#define F71808FG_REG_WDO_CONF		0xf0
+#define F71808FG_REG_WDT_CONF		0xf5
+#define F71808FG_REG_WD_TIME		0xf6
+
+#define F71808FG_FLAG_WDOUT_EN		7
+
+#define F71808FG_FLAG_WDTMOUT_STS	5
+#define F71808FG_FLAG_WD_EN		5
+#define F71808FG_FLAG_WD_PULSE		4
+#define F71808FG_FLAG_WD_UNIT		3
+
+/* Default values */
+#define WATCHDOG_TIMEOUT	60	/* 1 minute default timeout */
+#define WATCHDOG_MAX_TIMEOUT	(60 * 255)
+#define WATCHDOG_PULSE_WIDTH	125	/* 125 ms, default pulse width for
+					   watchdog signal */
+
+static unsigned short force_id;
+module_param(force_id, ushort, 0);
+MODULE_PARM_DESC(force_id, "Override the detected device ID");
+
+static const int max_timeout = WATCHDOG_MAX_TIMEOUT;
+static int timeout = 60;	/* default timeout in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <="
+			__MODULE_STRING(WATCHDOG_MAX_TIMEOUT) " (default="
+			__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+static unsigned int pulse_width = WATCHDOG_PULSE_WIDTH;
+module_param(pulse_width, uint, 0);
+MODULE_PARM_DESC(pulse_width,
+	"Watchdog signal pulse width. 0(=level), 1 ms, 25 ms, 125 ms or 5000 ms"
+			" (default=" __MODULE_STRING(WATCHDOG_PULSE_WIDTH) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0444);
+MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
+
+static unsigned int start_withtimeout;
+module_param(start_withtimeout, uint, 0);
+MODULE_PARM_DESC(start_withtimeout, "Start watchdog timer on module load with"
+	" given initial timeout. Zero (default) disables this feature.");
+
+enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg };
+
+static const char *f71808e_names[] = {
+	"f71808fg",
+	"f71858fg",
+	"f71862fg",
+	"f71882fg",
+	"f71889fg",
+};
+
+/* Super-I/O Function prototypes */
+static inline int superio_inb(int base, int reg);
+static inline int superio_inw(int base, int reg);
+static inline void superio_outb(int base, int reg, u8 val);
+static inline void superio_set_bit(int base, int reg, int bit);
+static inline void superio_clear_bit(int base, int reg, int bit);
+static inline int superio_enter(int base);
+static inline void superio_select(int base, int ld);
+static inline void superio_exit(int base);
+
+struct watchdog_data {
+	unsigned short	sioaddr;
+	enum chips	type;
+	unsigned long	opened;
+	struct mutex	lock;
+	char		expect_close;
+	struct watchdog_info ident;
+
+	unsigned short	timeout;
+	u8		timer_val;	/* content for the wd_time register */
+	char		minutes_mode;
+	u8		pulse_val;	/* pulse width flag */
+	char		pulse_mode;	/* enable pulse output mode? */
+	char		caused_reboot;	/* last reboot was by the watchdog */
+};
+
+static struct watchdog_data watchdog = {
+	.lock = __MUTEX_INITIALIZER(watchdog.lock),
+};
+
+/* Super I/O functions */
+static inline int superio_inb(int base, int reg)
+{
+	outb(reg, base);
+	return inb(base + 1);
+}
+
+static int superio_inw(int base, int reg)
+{
+	int val;
+	val  = superio_inb(base, reg) << 8;
+	val |= superio_inb(base, reg + 1);
+	return val;
+}
+
+static inline void superio_outb(int base, int reg, u8 val)
+{
+	outb(reg, base);
+	outb(val, base + 1);
+}
+
+static inline void superio_set_bit(int base, int reg, int bit)
+{
+	unsigned long val = superio_inb(base, reg);
+	__set_bit(bit, &val);
+	superio_outb(base, reg, val);
+}
+
+static inline void superio_clear_bit(int base, int reg, int bit)
+{
+	unsigned long val = superio_inb(base, reg);
+	__clear_bit(bit, &val);
+	superio_outb(base, reg, val);
+}
+
+static inline int superio_enter(int base)
+{
+	/* Don't step on other drivers' I/O space by accident */
+	if (!request_muxed_region(base, 2, DRVNAME)) {
+		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
+				(int)base);
+		return -EBUSY;
+	}
+
+	/* according to the datasheet the key must be send twice! */
+	outb(SIO_UNLOCK_KEY, base);
+	outb(SIO_UNLOCK_KEY, base);
+
+	return 0;
+}
+
+static inline void superio_select(int base, int ld)
+{
+	outb(SIO_REG_LDSEL, base);
+	outb(ld, base + 1);
+}
+
+static inline void superio_exit(int base)
+{
+	outb(SIO_LOCK_KEY, base);
+	release_region(base, 2);
+}
+
+static int watchdog_set_timeout(int timeout)
+{
+	if (timeout <= 0
+	 || timeout >  max_timeout) {
+		printk(KERN_ERR DRVNAME ": watchdog timeout out of range\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&watchdog.lock);
+
+	watchdog.timeout = timeout;
+	if (timeout > 0xff) {
+		watchdog.timer_val = DIV_ROUND_UP(timeout, 60);
+		watchdog.minutes_mode = true;
+	} else {
+		watchdog.timer_val = timeout;
+		watchdog.minutes_mode = false;
+	}
+
+	mutex_unlock(&watchdog.lock);
+
+	return 0;
+}
+
+static int watchdog_set_pulse_width(unsigned int pw)
+{
+	int err = 0;
+
+	mutex_lock(&watchdog.lock);
+
+	if        (pw <=    1) {
+		watchdog.pulse_val = 0;
+	} else if (pw <=   25) {
+		watchdog.pulse_val = 1;
+	} else if (pw <=  125) {
+		watchdog.pulse_val = 2;
+	} else if (pw <= 5000) {
+		watchdog.pulse_val = 3;
+	} else {
+		printk(KERN_ERR DRVNAME ": pulse width out of range\n");
+		err = -EINVAL;
+		goto exit_unlock;
+	}
+
+	watchdog.pulse_mode = pw;
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return err;
+}
+
+static int watchdog_keepalive(void)
+{
+	int err = 0;
+
+	mutex_lock(&watchdog.lock);
+	err = superio_enter(watchdog.sioaddr);
+	if (err)
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	if (watchdog.minutes_mode)
+		/* select minutes for timer units */
+		superio_set_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+	else
+		/* select seconds for timer units */
+		superio_clear_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+
+	/* Set timer value */
+	superio_outb(watchdog.sioaddr, F71808FG_REG_WD_TIME,
+			   watchdog.timer_val);
+
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return err;
+}
+
+static int watchdog_start(void)
+{
+	/* Make sure we don't die as soon as the watchdog is enabled below */
+	int err = watchdog_keepalive();
+	if (err)
+		return err;
+
+	mutex_lock(&watchdog.lock);
+	err = superio_enter(watchdog.sioaddr);
+	if (err)
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	/* Watchdog pin configuration */
+	switch (watchdog.type) {
+	case f71808fg:
+		/* Set pin 21 to GPIO23/WDTRST#, then to WDTRST# */
+		superio_clear_bit(watchdog.sioaddr, 0x2a, 3);
+		superio_clear_bit(watchdog.sioaddr, 0x2b, 3);
+		break;
+
+	case f71882fg:
+		/* Set pin 56 to WDTRST# */
+		superio_set_bit(watchdog.sioaddr, 0x29, 1);
+		break;
+
+	default:
+		/*
+		 * 'default' label to shut up the compiler and catch
+		 * programmer errors
+		 */
+		err = -ENODEV;
+		goto exit_superio;
+	}
+
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+	superio_set_bit(watchdog.sioaddr, SIO_REG_ENABLE, 0);
+	superio_set_bit(watchdog.sioaddr, F71808FG_REG_WDO_CONF,
+			F71808FG_FLAG_WDOUT_EN);
+
+	superio_set_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+			F71808FG_FLAG_WD_EN);
+
+	if (watchdog.pulse_mode) {
+		/* Select "pulse" output mode with given duration */
+		u8 wdt_conf = superio_inb(watchdog.sioaddr,
+				F71808FG_REG_WDT_CONF);
+
+		/* Set WD_PSWIDTH bits (1:0) */
+		wdt_conf = (wdt_conf & 0xfc) | (watchdog.pulse_val & 0x03);
+		/* Set WD_PULSE to "pulse" mode */
+		wdt_conf |= BIT(F71808FG_FLAG_WD_PULSE);
+
+		superio_outb(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				wdt_conf);
+	} else {
+		/* Select "level" output mode */
+		superio_clear_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_PULSE);
+	}
+
+exit_superio:
+	superio_exit(watchdog.sioaddr);
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+
+	return err;
+}
+
+static int watchdog_stop(void)
+{
+	int err = 0;
+
+	mutex_lock(&watchdog.lock);
+	err = superio_enter(watchdog.sioaddr);
+	if (err)
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	superio_clear_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+			F71808FG_FLAG_WD_EN);
+
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+
+	return err;
+}
+
+static int watchdog_get_status(void)
+{
+	int status = 0;
+
+	mutex_lock(&watchdog.lock);
+	status = (watchdog.caused_reboot) ? WDIOF_CARDRESET : 0;
+	mutex_unlock(&watchdog.lock);
+
+	return status;
+}
+
+static bool watchdog_is_running(void)
+{
+	/*
+	 * if we fail to determine the watchdog's status assume it to be
+	 * running to be on the safe side
+	 */
+	bool is_running = true;
+
+	mutex_lock(&watchdog.lock);
+	if (superio_enter(watchdog.sioaddr))
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	is_running = (superio_inb(watchdog.sioaddr, SIO_REG_ENABLE) & BIT(0))
+		&& (superio_inb(watchdog.sioaddr, F71808FG_REG_WDT_CONF)
+			& F71808FG_FLAG_WD_EN);
+
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return is_running;
+}
+
+/* /dev/watchdog api */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int err;
+
+	/* If the watchdog is alive we don't need to start it again */
+	if (test_and_set_bit(0, &watchdog.opened))
+		return -EBUSY;
+
+	err = watchdog_start();
+	if (err) {
+		clear_bit(0, &watchdog.opened);
+		return err;
+	}
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	watchdog.expect_close = 0;
+	return nonseekable_open(inode, file);
+}
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &watchdog.opened);
+
+	if (!watchdog.expect_close) {
+		watchdog_keepalive();
+		printk(KERN_CRIT DRVNAME
+			": Unexpected close, not stopping watchdog!\n");
+	} else if (!nowayout) {
+		watchdog_stop();
+	}
+	return 0;
+}
+
+/*
+ *      watchdog_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we we don't define content meaning.
+ */
+
+static ssize_t watchdog_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	if (count) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			bool expect_close = false;
+
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				expect_close = (c == 'V');
+			}
+
+			/* Properly order writes across fork()ed processes */
+			mutex_lock(&watchdog.lock);
+			watchdog.expect_close = expect_close;
+			mutex_unlock(&watchdog.lock);
+		}
+
+		/* someone wrote to us, we should restart timer */
+		watchdog_keepalive();
+	}
+	return count;
+}
+
+/*
+ *      watchdog_ioctl:
+ *      @inode: inode of the device
+ *      @file: file handle to the device
+ *      @cmd: watchdog command
+ *      @arg: argument pointer
+ *
+ *      The watchdog API defines a common set of functions for all watchdogs
+ *      according to their available features.
+ */
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	int status;
+	int new_options;
+	int new_timeout;
+	union {
+		struct watchdog_info __user *ident;
+		int __user *i;
+	} uarg;
+
+	uarg.i = (int __user *)arg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &watchdog.ident,
+			sizeof(watchdog.ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+		status = watchdog_get_status();
+		if (status < 0)
+			return status;
+		return put_user(status, uarg.i);
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, uarg.i))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD)
+			watchdog_stop();
+
+		if (new_options & WDIOS_ENABLECARD)
+			return watchdog_start();
+
+
+	case WDIOC_KEEPALIVE:
+		watchdog_keepalive();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+
+		if (watchdog_set_timeout(new_timeout))
+			return -EINVAL;
+
+		watchdog_keepalive();
+		/* Fall */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdog.timeout, uarg.i);
+
+	default:
+		return -ENOTTY;
+
+	}
+}
+
+static int watchdog_notify_sys(struct notifier_block *this, unsigned long code,
+	void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		watchdog_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations watchdog_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= watchdog_open,
+	.release	= watchdog_release,
+	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
+};
+
+static struct miscdevice watchdog_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &watchdog_fops,
+};
+
+static struct notifier_block watchdog_notifier = {
+	.notifier_call = watchdog_notify_sys,
+};
+
+static int __init watchdog_init(int sioaddr)
+{
+	int wdt_conf, err = 0;
+
+	/* No need to lock watchdog.lock here because no entry points
+	 * into the module have been registered yet.
+	 */
+	watchdog.sioaddr = sioaddr;
+	watchdog.ident.options = WDIOC_SETTIMEOUT
+				| WDIOF_MAGICCLOSE
+				| WDIOF_KEEPALIVEPING;
+
+	snprintf(watchdog.ident.identity,
+		sizeof(watchdog.ident.identity), "%s watchdog",
+		f71808e_names[watchdog.type]);
+
+	err = superio_enter(sioaddr);
+	if (err)
+		return err;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	wdt_conf = superio_inb(sioaddr, F71808FG_REG_WDT_CONF);
+	watchdog.caused_reboot = wdt_conf & F71808FG_FLAG_WDTMOUT_STS;
+
+	superio_exit(sioaddr);
+
+	err = watchdog_set_timeout(timeout);
+	if (err)
+		return err;
+	err = watchdog_set_pulse_width(pulse_width);
+	if (err)
+		return err;
+
+	err = register_reboot_notifier(&watchdog_notifier);
+	if (err)
+		return err;
+
+	err = misc_register(&watchdog_miscdev);
+	if (err) {
+		printk(KERN_ERR DRVNAME
+			": cannot register miscdev on minor=%d\n",
+				watchdog_miscdev.minor);
+		goto exit_reboot;
+	}
+
+	if (start_withtimeout) {
+		if (start_withtimeout <= 0
+		 || start_withtimeout >  max_timeout) {
+			printk(KERN_ERR DRVNAME
+				": starting timeout out of range\n");
+			err = -EINVAL;
+			goto exit_miscdev;
+		}
+
+		err = watchdog_start();
+		if (err) {
+			printk(KERN_ERR DRVNAME
+				": cannot start watchdog timer\n");
+			goto exit_miscdev;
+		}
+
+		mutex_lock(&watchdog.lock);
+		err = superio_enter(sioaddr);
+		if (err)
+			goto exit_unlock;
+		superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+		if (start_withtimeout > 0xff) {
+			/* select minutes for timer units */
+			superio_set_bit(sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+			superio_outb(sioaddr, F71808FG_REG_WD_TIME,
+				DIV_ROUND_UP(start_withtimeout, 60));
+		} else {
+			/* select seconds for timer units */
+			superio_clear_bit(sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+			superio_outb(sioaddr, F71808FG_REG_WD_TIME,
+				start_withtimeout);
+		}
+
+		superio_exit(sioaddr);
+		mutex_unlock(&watchdog.lock);
+
+		if (nowayout)
+			__module_get(THIS_MODULE);
+
+		printk(KERN_INFO DRVNAME
+			": watchdog started with initial timeout of %u sec\n",
+			start_withtimeout);
+	}
+
+	return 0;
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+exit_miscdev:
+	misc_deregister(&watchdog_miscdev);
+exit_reboot:
+	unregister_reboot_notifier(&watchdog_notifier);
+
+	return err;
+}
+
+static int __init f71808e_find(int sioaddr)
+{
+	u16 devid;
+	int err = superio_enter(sioaddr);
+	if (err)
+		return err;
+
+	devid = superio_inw(sioaddr, SIO_REG_MANID);
+	if (devid != SIO_FINTEK_ID) {
+		pr_debug(DRVNAME ": Not a Fintek device\n");
+		err = -ENODEV;
+		goto exit;
+	}
+
+	devid = force_id ? force_id : superio_inw(sioaddr, SIO_REG_DEVID);
+	switch (devid) {
+	case SIO_F71808_ID:
+		watchdog.type = f71808fg;
+		break;
+	case SIO_F71882_ID:
+		watchdog.type = f71882fg;
+		break;
+	case SIO_F71862_ID:
+	case SIO_F71889_ID:
+		/* These have a watchdog, though it isn't implemented (yet). */
+		err = -ENOSYS;
+		goto exit;
+	case SIO_F71858_ID:
+		/* Confirmed (by datasheet) not to have a watchdog. */
+		err = -ENODEV;
+		goto exit;
+	default:
+		printk(KERN_INFO DRVNAME ": Unrecognized Fintek device: %04x\n",
+		       (unsigned int)devid);
+		err = -ENODEV;
+		goto exit;
+	}
+
+	printk(KERN_INFO DRVNAME ": Found %s watchdog chip, revision %d\n",
+		f71808e_names[watchdog.type],
+		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
+exit:
+	superio_exit(sioaddr);
+	return err;
+}
+
+static int __init f71808e_init(void)
+{
+	static const unsigned short addrs[] = { 0x2e, 0x4e };
+	int err = -ENODEV;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(addrs); i++) {
+		err = f71808e_find(addrs[i]);
+		if (err == 0)
+			break;
+	}
+	if (i == ARRAY_SIZE(addrs))
+		return err;
+
+	return watchdog_init(addrs[i]);
+}
+
+static void __exit f71808e_exit(void)
+{
+	if (watchdog_is_running()) {
+		printk(KERN_WARNING DRVNAME
+			": Watchdog timer still running, stopping it\n");
+		watchdog_stop();
+	}
+	misc_deregister(&watchdog_miscdev);
+	unregister_reboot_notifier(&watchdog_notifier);
+}
+
+MODULE_DESCRIPTION("F71808E Watchdog Driver");
+MODULE_AUTHOR("Giel van Schijndel <me@mortis.eu>");
+MODULE_LICENSE("GPL");
+
+module_init(f71808e_init);
+module_exit(f71808e_exit);
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 809e716..fd312fc 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -246,8 +246,8 @@ static int __devinit cru_detect(unsigned long map_entry,
 			physical_bios_offset);
 		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
 			cru_length);
-		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: 0x%x\n",
-			(unsigned int)&cru_rom_addr);
+		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: %p\n",
+			&cru_rom_addr);
 	}
 	iounmap(bios32_map);
 	return retval;
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 3009325..ae53662 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -532,21 +532,22 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
-	s3c2410wdt_cpufreq_deregister();
-
-	release_resource(wdt_mem);
-	kfree(wdt_mem);
-	wdt_mem = NULL;
+	misc_deregister(&s3c2410wdt_miscdev);
 
-	free_irq(wdt_irq->start, dev);
-	wdt_irq = NULL;
+	s3c2410wdt_cpufreq_deregister();
 
 	clk_disable(wdt_clock);
 	clk_put(wdt_clock);
 	wdt_clock = NULL;
 
+	free_irq(wdt_irq->start, dev);
+	wdt_irq = NULL;
+
 	iounmap(wdt_base);
-	misc_deregister(&s3c2410wdt_miscdev);
+
+	release_resource(wdt_mem);
+	kfree(wdt_mem);
+	wdt_mem = NULL;
 	return 0;
 }
 
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 9c40f48..0461858 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -425,6 +425,8 @@ static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
 	val = therm_trip ? 0x06 : 0x04;
 	outb(val, sch311x_wdt_data.runtime_reg + RESGEN);
 
+	sch311x_wdt_miscdev.parent = dev;
+
 	err = misc_register(&sch311x_wdt_miscdev);
 	if (err != 0) {
 		dev_err(dev, "cannot register miscdev on minor=%d (err=%d)\n",
@@ -432,8 +434,6 @@ static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
 		goto exit_release_region3;
 	}
 
-	sch311x_wdt_miscdev.parent = dev;
-
 	dev_info(dev,
 		"SMSC SCH311x WDT initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
new file mode 100644
index 0000000..9127eda
--- /dev/null
+++ b/drivers/watchdog/sp805_wdt.c
@@ -0,0 +1,387 @@
+/*
+ * drivers/char/watchdog/sp805-wdt.c
+ *
+ * Watchdog driver for ARM SP805 watchdog module
+ *
+ * Copyright (C) 2010 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2 or later. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/device.h>
+#include <linux/resource.h>
+#include <linux/amba/bus.h>
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/math64.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+/* default timeout in seconds */
+#define DEFAULT_TIMEOUT		60
+
+#define MODULE_NAME		"sp805-wdt"
+
+/* watchdog register offsets and masks */
+#define WDTLOAD			0x000
+	#define LOAD_MIN	0x00000001
+	#define LOAD_MAX	0xFFFFFFFF
+#define WDTVALUE		0x004
+#define WDTCONTROL		0x008
+	/* control register masks */
+	#define	INT_ENABLE	(1 << 0)
+	#define	RESET_ENABLE	(1 << 1)
+#define WDTINTCLR		0x00C
+#define WDTRIS			0x010
+#define WDTMIS			0x014
+	#define INT_MASK	(1 << 0)
+#define WDTLOCK			0xC00
+	#define	UNLOCK		0x1ACCE551
+	#define	LOCK		0x00000001
+
+/**
+ * struct sp805_wdt: sp805 wdt device structure
+ *
+ * lock: spin lock protecting dev structure and io access
+ * base: base address of wdt
+ * clk: clock structure of wdt
+ * dev: amba device structure of wdt
+ * status: current status of wdt
+ * load_val: load value to be set for current timeout
+ * timeout: current programmed timeout
+ */
+struct sp805_wdt {
+	spinlock_t			lock;
+	void __iomem			*base;
+	struct clk			*clk;
+	struct amba_device		*adev;
+	unsigned long			status;
+	#define WDT_BUSY		0
+	#define WDT_CAN_BE_CLOSED	1
+	unsigned int			load_val;
+	unsigned int			timeout;
+};
+
+/* local variables */
+static struct sp805_wdt *wdt;
+static int nowayout = WATCHDOG_NOWAYOUT;
+
+/* This routine finds load value that will reset system in required timout */
+static void wdt_setload(unsigned int timeout)
+{
+	u64 load, rate;
+
+	rate = clk_get_rate(wdt->clk);
+
+	/*
+	 * sp805 runs counter with given value twice, after the end of first
+	 * counter it gives an interrupt and then starts counter again. If
+	 * interrupt already occured then it resets the system. This is why
+	 * load is half of what should be required.
+	 */
+	load = div_u64(rate, 2) * timeout - 1;
+
+	load = (load > LOAD_MAX) ? LOAD_MAX : load;
+	load = (load < LOAD_MIN) ? LOAD_MIN : load;
+
+	spin_lock(&wdt->lock);
+	wdt->load_val = load;
+	/* roundup timeout to closest positive integer value */
+	wdt->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
+	spin_unlock(&wdt->lock);
+}
+
+/* returns number of seconds left for reset to occur */
+static u32 wdt_timeleft(void)
+{
+	u64 load, rate;
+
+	rate = clk_get_rate(wdt->clk);
+
+	spin_lock(&wdt->lock);
+	load = readl(wdt->base + WDTVALUE);
+
+	/*If the interrupt is inactive then time left is WDTValue + WDTLoad. */
+	if (!(readl(wdt->base + WDTRIS) & INT_MASK))
+		load += wdt->load_val + 1;
+	spin_unlock(&wdt->lock);
+
+	return div_u64(load, rate);
+}
+
+/* enables watchdog timers reset */
+static void wdt_enable(void)
+{
+	spin_lock(&wdt->lock);
+
+	writel(UNLOCK, wdt->base + WDTLOCK);
+	writel(wdt->load_val, wdt->base + WDTLOAD);
+	writel(INT_MASK, wdt->base + WDTINTCLR);
+	writel(INT_ENABLE | RESET_ENABLE, wdt->base + WDTCONTROL);
+	writel(LOCK, wdt->base + WDTLOCK);
+
+	spin_unlock(&wdt->lock);
+}
+
+/* disables watchdog timers reset */
+static void wdt_disable(void)
+{
+	spin_lock(&wdt->lock);
+
+	writel(UNLOCK, wdt->base + WDTLOCK);
+	writel(0, wdt->base + WDTCONTROL);
+	writel(0, wdt->base + WDTLOAD);
+	writel(LOCK, wdt->base + WDTLOCK);
+
+	spin_unlock(&wdt->lock);
+}
+
+static ssize_t sp805_wdt_write(struct file *file, const char *data,
+		size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_CAN_BE_CLOSED, &wdt->status);
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+				/* Check for Magic Close character */
+				if (c == 'V') {
+					set_bit(WDT_CAN_BE_CLOSED,
+							&wdt->status);
+					break;
+				}
+			}
+		}
+		wdt_enable();
+	}
+	return len;
+}
+
+static const struct watchdog_info ident = {
+	.options = WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = MODULE_NAME,
+};
+
+static long sp805_wdt_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	int ret = -ENOTTY;
+	unsigned int timeout;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(timeout, (unsigned int *)arg);
+		if (ret)
+			break;
+
+		wdt_setload(timeout);
+
+		wdt_enable();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(wdt->timeout, (unsigned int *)arg);
+		break;
+	case WDIOC_GETTIMELEFT:
+		ret = put_user(wdt_timeleft(), (unsigned int *)arg);
+		break;
+	}
+	return ret;
+}
+
+static int sp805_wdt_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	if (test_and_set_bit(WDT_BUSY, &wdt->status))
+		return -EBUSY;
+
+	ret = clk_enable(wdt->clk);
+	if (ret) {
+		dev_err(&wdt->adev->dev, "clock enable fail");
+		goto err;
+	}
+
+	wdt_enable();
+
+	/* can not be closed, once enabled */
+	clear_bit(WDT_CAN_BE_CLOSED, &wdt->status);
+	return nonseekable_open(inode, file);
+
+err:
+	clear_bit(WDT_BUSY, &wdt->status);
+	return ret;
+}
+
+static int sp805_wdt_release(struct inode *inode, struct file *file)
+{
+	if (!test_bit(WDT_CAN_BE_CLOSED, &wdt->status)) {
+		clear_bit(WDT_BUSY, &wdt->status);
+		dev_warn(&wdt->adev->dev, "Device closed unexpectedly\n");
+		return 0;
+	}
+
+	wdt_disable();
+	clk_disable(wdt->clk);
+	clear_bit(WDT_BUSY, &wdt->status);
+
+	return 0;
+}
+
+static const struct file_operations sp805_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = sp805_wdt_write,
+	.unlocked_ioctl = sp805_wdt_ioctl,
+	.open = sp805_wdt_open,
+	.release = sp805_wdt_release,
+};
+
+static struct miscdevice sp805_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &sp805_wdt_fops,
+};
+
+static int __devinit
+sp805_wdt_probe(struct amba_device *adev, struct amba_id *id)
+{
+	int ret = 0;
+
+	if (!request_mem_region(adev->res.start, resource_size(&adev->res),
+				"sp805_wdt")) {
+		dev_warn(&adev->dev, "Failed to get memory region resource\n");
+		ret = -ENOENT;
+		goto err;
+	}
+
+	wdt = kzalloc(sizeof(*wdt), GFP_KERNEL);
+	if (!wdt) {
+		dev_warn(&adev->dev, "Kzalloc failed\n");
+		ret = -ENOMEM;
+		goto err_kzalloc;
+	}
+
+	wdt->clk = clk_get(&adev->dev, NULL);
+	if (IS_ERR(wdt->clk)) {
+		dev_warn(&adev->dev, "Clock not found\n");
+		ret = PTR_ERR(wdt->clk);
+		goto err_clk_get;
+	}
+
+	wdt->base = ioremap(adev->res.start, resource_size(&adev->res));
+	if (!wdt->base) {
+		ret = -ENOMEM;
+		dev_warn(&adev->dev, "ioremap fail\n");
+		goto err_ioremap;
+	}
+
+	wdt->adev = adev;
+	spin_lock_init(&wdt->lock);
+	wdt_setload(DEFAULT_TIMEOUT);
+
+	ret = misc_register(&sp805_wdt_miscdev);
+	if (ret < 0) {
+		dev_warn(&adev->dev, "cannot register misc device\n");
+		goto err_misc_register;
+	}
+
+	dev_info(&adev->dev, "registration successful\n");
+	return 0;
+
+err_misc_register:
+	iounmap(wdt->base);
+err_ioremap:
+	clk_put(wdt->clk);
+err_clk_get:
+	kfree(wdt);
+	wdt = NULL;
+err_kzalloc:
+	release_mem_region(adev->res.start, resource_size(&adev->res));
+err:
+	dev_err(&adev->dev, "Probe Failed!!!\n");
+	return ret;
+}
+
+static int __devexit sp805_wdt_remove(struct amba_device *adev)
+{
+	misc_deregister(&sp805_wdt_miscdev);
+	iounmap(wdt->base);
+	clk_put(wdt->clk);
+	kfree(wdt);
+	release_mem_region(adev->res.start, resource_size(&adev->res));
+
+	return 0;
+}
+
+static struct amba_id sp805_wdt_ids[] __initdata = {
+	{
+		.id	= 0x00141805,
+		.mask	= 0x00ffffff,
+	},
+	{ 0, 0 },
+};
+
+static struct amba_driver sp805_wdt_driver = {
+	.drv = {
+		.name	= MODULE_NAME,
+	},
+	.id_table	= sp805_wdt_ids,
+	.probe		= sp805_wdt_probe,
+	.remove = __devexit_p(sp805_wdt_remove),
+};
+
+static int __init sp805_wdt_init(void)
+{
+	return amba_driver_register(&sp805_wdt_driver);
+}
+module_init(sp805_wdt_init);
+
+static void __exit sp805_wdt_exit(void)
+{
+	amba_driver_unregister(&sp805_wdt_driver);
+}
+module_exit(sp805_wdt_exit);
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		"Set to 1 to keep watchdog running after device release");
+
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_DESCRIPTION("ARM SP805 Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 7b22e3c..6130c88 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -60,19 +60,6 @@
 
 #define PFX "wdt_pci: "
 
-/*
- * Until Access I/O gets their application for a PCI vendor ID approved,
- * I don't think that it's appropriate to move these constants into the
- * regular pci_ids.h file. -- JPN 2000/01/18
- */
-
-#ifndef PCI_VENDOR_ID_ACCESSIO
-#define PCI_VENDOR_ID_ACCESSIO 0x494f
-#endif
-#ifndef PCI_DEVICE_ID_WDG_CSM
-#define PCI_DEVICE_ID_WDG_CSM 0x22c0
-#endif
-
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int dev_count;
 
@@ -743,7 +730,7 @@ static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
 static struct pci_device_id wdtpci_pci_tbl[] = {
 	{
 		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
-		.device	   = PCI_DEVICE_ID_WDG_CSM,
+		.device	   = PCI_DEVICE_ID_ACCESSIO_WDG_CSM,
 		.subvendor = PCI_ANY_ID,
 		.subdevice = PCI_ANY_ID,
 	},
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c81eec4..f6a3b2d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2372,6 +2372,9 @@
 #define PCI_VENDOR_ID_AKS		0x416c
 #define PCI_DEVICE_ID_AKS_ALADDINCARD	0x0100
 
+#define PCI_VENDOR_ID_ACCESSIO		0x494f
+#define PCI_DEVICE_ID_ACCESSIO_WDG_CSM	0x22c0
+
 #define PCI_VENDOR_ID_S3		0x5333
 #define PCI_DEVICE_ID_S3_TRIO		0x8811
 #define PCI_DEVICE_ID_S3_868		0x8880
