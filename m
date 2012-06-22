Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818Ab2FVXYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:24:14 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:12504 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2FVXYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:24:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1340407451!12238966!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/31] staging: comedi: ni_daq_700: move the boardinfo variable
Date: Fri, 22 Jun 2012 16:24:06 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221624.06859.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, move the boardinfo declaration down so it's
next to the comedi_driver. That's the only place in the driver
where it's referenced directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 106da08..864bef7 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -59,15 +59,6 @@ struct dio700_board {
 	const char *name;
 };
 
-static const struct dio700_board dio700_boards[] = {
-	{
-	 .name = "daqcard-700",
-	 },
-	{
-	 .name = "ni_daq_700",
-	 },
-};
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -246,6 +237,14 @@ static void dio700_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 };
 
+static const struct dio700_board dio700_boards[] = {
+	{
+		.name		= "daqcard-700",
+	}, {
+		.name		= "ni_daq_700",
+	},
+};
+
 static struct comedi_driver driver_dio700 = {
 	.driver_name	= "ni_daq_700",
 	.module		= THIS_MODULE,
-- 
1.7.11

