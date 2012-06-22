Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2FVXiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:38:54 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:15412 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2FVXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:38:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1340408331!7497150!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/31] staging: comedi: ni_daq_700: remove unneeded pcmcia private data
Date: Fri, 22 Jun 2012 16:38:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221638.46382.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia device-specific data is not longer needed by this
driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index b02ed37..f8465a2 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -210,24 +210,10 @@ failed:
 
 }
 
-struct local_info_t {
-	struct pcmcia_device *link;
-	struct bus_operations *bus;
-};
-
 static int dio700_cs_attach(struct pcmcia_device *link)
 {
-	struct local_info_t *local;
-
 	dev_dbg(&link->dev, "%s\n", __func__);
 
-	/* Allocate space for private device-specific data */
-	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
-	if (!local)
-		return -ENOMEM;
-	local->link = link;
-	link->priv = local;
-
 	pcmcia_cur_dev = link;
 
 	dio700_config(link);
@@ -238,9 +224,6 @@ static int dio700_cs_attach(struct pcmcia_device *link)
 static void dio700_cs_detach(struct pcmcia_device *link)
 {
 	dio700_release(link);
-
-	/* This points to the parent struct local_info_t struct */
-	kfree(link->priv);
 }
 
 static int dio700_cs_suspend(struct pcmcia_device *link)
-- 
1.7.11

