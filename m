Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874Ab2FVXiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:38:05 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:41828 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2FVXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:38:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1340408281!22984513!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/31] staging: comedi: ni_daq_700: remove unused pcmcia 'stop' logic
Date: Fri, 22 Jun 2012 16:37:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221637.56385.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia support code in this driver appears to be cut-and-
paste from some other driver. It has code in it to stop the
device during suspend but nothing in the main comedi_driver
uses it.

Remove the 'stop' variable from the pcmcia private data and
all the logic that deals with it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index bb857ac4..b02ed37 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -212,7 +212,6 @@ failed:
 
 struct local_info_t {
 	struct pcmcia_device *link;
-	int stop;
 	struct bus_operations *bus;
 };
 
@@ -238,7 +237,6 @@ static int dio700_cs_attach(struct pcmcia_device *link)
 
 static void dio700_cs_detach(struct pcmcia_device *link)
 {
-	((struct local_info_t *)link->priv)->stop = 1;
 	dio700_release(link);
 
 	/* This points to the parent struct local_info_t struct */
@@ -247,18 +245,11 @@ static void dio700_cs_detach(struct pcmcia_device *link)
 
 static int dio700_cs_suspend(struct pcmcia_device *link)
 {
-	struct local_info_t *local = link->priv;
-
-	/* Mark the device as stopped, to block IO until later */
-	local->stop = 1;
 	return 0;
 }
 
 static int dio700_cs_resume(struct pcmcia_device *link)
 {
-	struct local_info_t *local = link->priv;
-
-	local->stop = 0;
 	return 0;
 }
 
-- 
1.7.11

