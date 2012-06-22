Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2FVXjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:39:53 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51816 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2FVXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:39:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1340408385!6670915!3
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/31] staging: comedi: ni_daq_700: remove the pcmcia suspend/resume
Date: Fri, 22 Jun 2012 16:39:42 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221639.42443.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia suspend/resume callbacks don't do anything. Remove
them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index f8465a2..c57300f 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -226,16 +226,6 @@ static void dio700_cs_detach(struct pcmcia_device *link)
 	dio700_release(link);
 }
 
-static int dio700_cs_suspend(struct pcmcia_device *link)
-{
-	return 0;
-}
-
-static int dio700_cs_resume(struct pcmcia_device *link)
-{
-	return 0;
-}
-
 static const struct pcmcia_device_id dio700_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x4743),
 	PCMCIA_DEVICE_NULL
@@ -247,8 +237,6 @@ static struct pcmcia_driver dio700_cs_driver = {
 	.owner		= THIS_MODULE,
 	.probe		= dio700_cs_attach,
 	.remove		= dio700_cs_detach,
-	.suspend	= dio700_cs_suspend,
-	.resume		= dio700_cs_resume,
 	.id_table	= dio700_cs_ids,
 };
 
-- 
1.7.11

