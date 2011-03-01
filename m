Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab1CAUc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:32:28 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:37057 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab1CAUc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:32:26 -0500
Date: Tue, 1 Mar 2011 12:32:20 -0800
From: Andres Salomon <dilinger@queued.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] tmio: silence warnings introduced by mfd changes
Message-ID: <20110301123220.705d3368@debxo>
In-Reply-To: <20110301105322.48754094@debxo>
References: <20110301154230.df32be17.sfr@canb.auug.org.au>
	<20110301105322.48754094@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 10:53:22 -0800
Andres Salomon <dilinger@queued.net> wrote:

> On Tue, 1 Mar 2011 15:42:30 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Samuel,
> > 
> > After merging the mfd tree, today's linux-next build (x86_64
> > allmodconfig) produced these warnings:
> > 
> > drivers/video/tmiofb.c: In function 'tmiofb_hw_init':
> > drivers/video/tmiofb.c:270: warning: initialization discards
> > qualifiers from pointer target type drivers/video/tmiofb.c: In
> > function 'tmiofb_hw_mode': drivers/video/tmiofb.c:314: warning:
> > initialization discards qualifiers from pointer target type
> > drivers/video/tmiofb.c:314: warning: unused variable 'cell'
> > drivers/video/tmiofb.c: In function 'tmiofb_probe':
> > drivers/video/tmiofb.c:683: warning: initialization discards
> > qualifiers from pointer target type drivers/video/tmiofb.c: In
> > function 'tmiofb_remove': drivers/video/tmiofb.c:811: warning:
> > initialization discards qualifiers from pointer target type
> > drivers/video/tmiofb.c: In function 'tmiofb_suspend':
> > drivers/video/tmiofb.c:941: warning: initialization discards
> > qualifiers from pointer target type drivers/video/tmiofb.c: In
> > function 'tmiofb_resume': drivers/video/tmiofb.c:973: warning:
> > initialization discards qualifiers from pointer target type
> > 
> > Introduced by commits 2a79bb1d72f5ac22dff96de340d90d512f852ecb
> > ("mfd: mfd_cell is now implicitly available to tc6393xb drivers")
> > and b6361637190e6cb7acb84509499942ada69e7136 ("fb: Use mfd_data
> > instead of driver_data for tmio-fb").
> > 
> 
> Oops, this should fix that.
> 
> 
> 


Actually, I noticed that I screwed this up for the other tmio drivers
as well.  Here's a patch that addresses them all (you can
ignore the previous patch).


From: Andres Salomon <dilinger@queued.net>

This silences warnings such as

drivers/video/tmiofb.c: In function 'tmiofb_hw_init':
drivers/video/tmiofb.c:270: warning: initialization discards qualifiers from pointer target type

These were added by me in commit 2a79bb1d.

Signed-off-by: Andres Salomon <dilinger@queued.net>

moo
Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mmc/host/tmio_mmc.c  |    8 ++++----
 drivers/mtd/nand/tmio_nand.c |    8 ++++----
 drivers/usb/host/ohci-tmio.c |    8 ++++----
 drivers/video/tmiofb.c       |   11 +++++------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 4d34fbd..39918cc 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -1191,7 +1191,7 @@ static const struct mmc_host_ops tmio_mmc_ops = {
 #ifdef CONFIG_PM
 static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct mfd_cell	*cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret;
 
@@ -1206,7 +1206,7 @@ static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tmio_mmc_resume(struct platform_device *dev)
 {
-	struct mfd_cell	*cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret = 0;
 
@@ -1229,7 +1229,7 @@ out:
 
 static int __devinit tmio_mmc_probe(struct platform_device *dev)
 {
-	struct mfd_cell	*cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_mmc_data *pdata;
 	struct resource *res_ctl;
 	struct tmio_mmc_host *host;
@@ -1344,7 +1344,7 @@ out:
 
 static int __devexit tmio_mmc_remove(struct platform_device *dev)
 {
-	struct mfd_cell	*cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 
 	platform_set_drvdata(dev, NULL);
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 2383b8f..38fb167 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -319,7 +319,7 @@ static int tmio_nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
 
 static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	int ret;
 
 	if (cell->enable) {
@@ -363,7 +363,7 @@ static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 
 static void tmio_hw_stop(struct platform_device *dev, struct tmio_nand *tmio)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 
 	tmio_iowrite8(FCR_MODE_POWER_OFF, tmio->fcr + FCR_MODE);
 	if (cell->disable)
@@ -515,7 +515,7 @@ static int tmio_remove(struct platform_device *dev)
 #ifdef CONFIG_PM
 static int tmio_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 
 	if (cell->suspend)
 		cell->suspend(dev);
@@ -526,7 +526,7 @@ static int tmio_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tmio_resume(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 
 	/* FIXME - is this required or merely another attack of the broken
 	 * SHARP platform? Looks suspicious.
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index eeed164..3558491 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -185,7 +185,7 @@ static struct platform_driver ohci_hcd_tmio_driver;
 
 static int __devinit ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct resource *regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	struct resource *config = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *sram = platform_get_resource(dev, IORESOURCE_MEM, 2);
@@ -274,7 +274,7 @@ static int __devexit ohci_hcd_tmio_drv_remove(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 
 	usb_remove_hcd(hcd);
 	tmio_stop_hc(dev);
@@ -293,7 +293,7 @@ static int __devexit ohci_hcd_tmio_drv_remove(struct platform_device *dev)
 #ifdef CONFIG_PM
 static int ohci_hcd_tmio_drv_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
@@ -326,7 +326,7 @@ static int ohci_hcd_tmio_drv_suspend(struct platform_device *dev, pm_message_t s
 
 static int ohci_hcd_tmio_drv_resume(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index 7e57d3b..9710bf8 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -267,7 +267,7 @@ static int tmiofb_hw_stop(struct platform_device *dev)
  */
 static int tmiofb_hw_init(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct tmiofb_par *par = info->par;
 	const struct resource *nlcr = &cell->resources[0];
@@ -311,7 +311,6 @@ static int tmiofb_hw_init(struct platform_device *dev)
  */
 static void tmiofb_hw_mode(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct fb_videomode *mode = info->mode;
@@ -680,7 +679,7 @@ static struct fb_ops tmiofb_ops = {
 
 static int __devinit tmiofb_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct resource *ccr = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *lcr = platform_get_resource(dev, IORESOURCE_MEM, 0);
@@ -808,7 +807,7 @@ err_ioremap_ccr:
 
 static int __devexit tmiofb_remove(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	int irq = platform_get_irq(dev, 0);
 	struct tmiofb_par *par;
@@ -938,7 +937,7 @@ static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 #ifdef CONFIG_FB_TMIO_ACCELL
 	struct tmiofb_par *par = info->par;
 #endif
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	int retval = 0;
 
 	console_lock();
@@ -970,7 +969,7 @@ static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 static int tmiofb_resume(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	int retval = 0;
 
 	console_lock();
-- 
1.7.2.3

