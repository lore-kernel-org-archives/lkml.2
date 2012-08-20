Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2HTTwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:52:54 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:38627 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2HTTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:52:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1345492365!8975597!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] staging: comedi: comedi_bond: remove boardinfo
Date: Mon, 20 Aug 2012 12:52:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201252.41996.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only field in the boardinfo for this driver is a pointer to the
board 'name'. This field is used by the comedi core to match against
the driver when doing a legacy attach. If a driver does not have any
boardinfo, the comedi core matches against the driver name.

Since the boardinfo name and driver name are identical we can simplify
this driver a bit bu just removing the boardinfo completely.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 5ed324c..6918439 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -79,20 +79,6 @@ MODULE_PARM_DESC(debug, "If true, print extra cryptic debugging output useful"
 #define WARNING(x...)  printk(KERN_WARNING MODULE_NAME ": WARNING: "x)
 #define ERROR(x...)  printk(KERN_ERR MODULE_NAME ": INTERNAL ERROR: "x)
 
-/*
- * Board descriptions for two imaginary boards.  Describing the
- * boards in this way is optional, and completely driver-dependent.
- * Some drivers use arrays such as this, other do not.
- */
-struct BondingBoard {
-	const char *name;
-};
-
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct BondingBoard *)dev->board_ptr)
-
 struct BondedDevice {
 	struct comedi_device *dev;
 	unsigned minor;
@@ -351,10 +337,6 @@ static int bonding_attach(struct comedi_device *dev,
 	if (!doDevConfig(dev, it))
 		return -EINVAL;
 
-	/*
-	 * Initialize dev->board_name.  Note that we can use the "thisboard"
-	 * macro now, since we just initialized it in the last line.
-	 */
 	dev->board_name = devpriv->name;
 
 	ret = comedi_alloc_subdevices(dev, 1);
@@ -402,20 +384,11 @@ static void bonding_detach(struct comedi_device *dev)
 	}
 }
 
-static const struct BondingBoard bondingBoards[] = {
-	{
-		.name		= "comedi_bond",
-	},
-};
-
 static struct comedi_driver bonding_driver = {
 	.driver_name	= "comedi_bond",
 	.module		= THIS_MODULE,
 	.attach		= bonding_attach,
 	.detach		= bonding_detach,
-	.board_name	= &bondingBoards[0].name,
-	.offset		= sizeof(struct BondingBoard),
-	.num_names	= ARRAY_SIZE(bondingBoards),
 };
 module_comedi_driver(bonding_driver);
 
-- 
1.7.11

