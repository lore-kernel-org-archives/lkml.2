Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab2FYWQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:16:05 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:59021 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab2FYWQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:16:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1340662561!21352973!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/33] staging: comedi: cb_das16_cs: remove CONFIG_PCMCIA check
Date: Mon, 25 Jun 2012 15:15:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251515.58622.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig ensures that this driver can only be build it PCMCIA is
enabled. Remove the unneeded '#if defined (CONFIG_PCMCIA) ,,,' and
the '#else' code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 6866e25..1fd4460 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -629,8 +629,6 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 
 ======================================================================*/
 
-#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
-
 static void das16cs_pcmcia_config(struct pcmcia_device *link);
 static void das16cs_pcmcia_release(struct pcmcia_device *link);
 static int das16cs_pcmcia_suspend(struct pcmcia_device *p_dev);
@@ -813,18 +811,3 @@ void __exit cleanup_module(void)
 	exit_das16cs_pcmcia_cs();
 	comedi_driver_unregister(&driver_das16cs);
 }
-
-#else
-static int __init driver_das16cs_init_module(void)
-{
-	return comedi_driver_register(&driver_das16cs);
-}
-
-static void __exit driver_das16cs_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_das16cs);
-}
-
-module_init(driver_das16cs_init_module);
-module_exit(driver_das16cs_cleanup_module);
-#endif /* CONFIG_PCMCIA */
-- 
1.7.11

