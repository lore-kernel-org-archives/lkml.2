Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889Ab2FVXhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:37:07 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:62186 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2FVXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:37:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1340408223!6573448!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/31] staging: comedi: ni_daq_700: cleanup pcmcia debug output messages
Date: Fri, 22 Jun 2012 16:36:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221636.58475.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These messages should probably just be removed. For now just clean
then up.

Remove a couple redundant KERN_INFO messages in the pcmcia support
code and leave the dev_dbg() ones.

Change the dev_dgb() messages to use __func__ instead of the open
coded string.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index cc46948..bb857ac4 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -166,7 +166,7 @@ static struct comedi_driver driver_dio700 = {
 
 static void dio700_release(struct pcmcia_device *link)
 {
-	dev_dbg(&link->dev, "dio700_release\n");
+	dev_dbg(&link->dev, "%s\n", __func__);
 
 	pcmcia_disable_device(link);
 }
@@ -184,9 +184,7 @@ static void dio700_config(struct pcmcia_device *link)
 {
 	int ret;
 
-	printk(KERN_INFO "ni_daq_700:  cs-config\n");
-
-	dev_dbg(&link->dev, "dio700_config\n");
+	dev_dbg(&link->dev, "%s\n", __func__);
 
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_AUDIO |
 		CONF_AUTO_SET_IO;
@@ -207,7 +205,7 @@ static void dio700_config(struct pcmcia_device *link)
 	return;
 
 failed:
-	printk(KERN_INFO "ni_daq_700 cs failed");
+	dev_dbg(&link->dev, "%s failed\n", __func__);
 	dio700_release(link);
 
 }
@@ -222,9 +220,7 @@ static int dio700_cs_attach(struct pcmcia_device *link)
 {
 	struct local_info_t *local;
 
-	printk(KERN_INFO "ni_daq_700:  cs-attach\n");
-
-	dev_dbg(&link->dev, "dio700_cs_attach()\n");
+	dev_dbg(&link->dev, "%s\n", __func__);
 
 	/* Allocate space for private device-specific data */
 	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
-- 
1.7.11

