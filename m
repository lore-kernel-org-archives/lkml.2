Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2BEB6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 20:58:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:43461 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab2BEB6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 20:58:22 -0500
Date: Sat, 4 Feb 2012 20:57:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: <devel@driverdev.osuosl.org>, <trivial@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Staging: Don't double-include linux/module.h in
 drivers/staging/iio/gyro/adis16060_core.c
Message-ID: <20120205015713.GA22055@windriver.com>
References: <alpine.LNX.2.00.1202050140430.30244@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202050140430.30244@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] Staging: Don't double-include linux/module.h in drivers/staging/iio/gyro/adis16060_core.c] On 05/02/2012 (Sun 01:42) Jesper Juhl wrote:

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

I've actually got all of the duplicates fixed at once in my module-3.4
branch, so if you see overlaps with the below, you can ignore them.

Thanks,
Paul.

---

>From 6ed1f5a897a3e94016af3173f16d00ad66c9b5c8 Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 29 Jan 2012 15:44:45 -0500
Subject: [PATCH] includecheck: delete any duplicate instances of module.h

Different tree maintainers picked up independently generated
trivial compile fixes based on linux-next testing, resulting
in some cases where a file would have got more than one addition
of module.h once everything was all merged together.

Delete any duplicates so includecheck isn't complaining about
anything related to module.h/export.h changes.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 6fd8470..7d15a30 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -101,7 +101,6 @@ static struct platform_device smc91x_device = {
 
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 #include <linux/bfin_mac.h>
-#include <linux/export.h>
 static const unsigned short bfin_mac_peripherals[] = P_RMII0;
 
 static struct bfin_phydev_platform_data bfin_phydev_data[] = {
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index e4383ee..38586ba 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -14,7 +14,6 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index a8af379..2b5b4b2 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -35,7 +35,6 @@
 #include <linux/dmaengine.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <mach/sdma.h>
diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 12eedf4..6e7d094 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -33,7 +33,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/version.h>
 #include <media/adp1653.h>
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 78a36eb..cb34856 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -23,7 +23,6 @@
 #include <linux/gpio.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
-#include <linux/module.h>
 
 #include <asm/gpio.h>
 
diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
index 9b3f2bf..6dc01c2 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -19,7 +19,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/iio/dac/ad5686.c b/drivers/staging/iio/dac/ad5686.c
index ce2d619..2415a6e 100644
--- a/drivers/staging/iio/dac/ad5686.c
+++ b/drivers/staging/iio/dac/ad5686.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/regulator/consumer.h>
-#include <linux/module.h>
 
 #include "../iio.h"
 #include "../sysfs.h"
diff --git a/drivers/staging/iio/gyro/adis16060_core.c b/drivers/staging/iio/gyro/adis16060_core.c
index c0ca709..02cc234 100644
--- a/drivers/staging/iio/gyro/adis16060_core.c
+++ b/drivers/staging/iio/gyro/adis16060_core.c
@@ -14,7 +14,6 @@
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
-#include <linux/module.h>
 
 #include "../iio.h"
 #include "../sysfs.h"
diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index ae0035f..1b3e2d0 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -41,7 +41,6 @@
 
 #ifdef CONFIG_PM
 #include <linux/pm.h>
-#include <linux/module.h>
 #endif
 
 #include "smtcfb.h"
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 7c9df63..eed4a5b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -51,7 +51,6 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
-#include <linux/module.h>
 
 #include "core.h"
 #include "gadget.h"
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 3274ac8..92cc7b8 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -46,7 +46,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
-#include <linux/module.h>
 
 #include "core.h"
 #include "io.h"
diff --git a/kernel/params.c b/kernel/params.c
index 32ee043..8aac9d0 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -15,7 +15,6 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff --git a/sound/isa/sb/emu8000_patch.c b/sound/isa/sb/emu8000_patch.c
index e09f144..c99c607 100644
--- a/sound/isa/sb/emu8000_patch.c
+++ b/sound/isa/sb/emu8000_patch.c
@@ -22,7 +22,6 @@
 #include "emu8000_local.h"
 #include <asm/uaccess.h>
 #include <linux/moduleparam.h>
-#include <linux/moduleparam.h>
 
 static int emu8000_reset_addr;
 module_param(emu8000_reset_addr, int, 0444);
-- 
1.7.7.2

