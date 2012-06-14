Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2FNCNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:13:55 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:27193 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2FNCNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:13:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1339640032!11370686!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] staging: comedi: me4000: remove PDEBUG macro
Date: Wed, 13 Jun 2012 19:13:42 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131913.42441.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PDEBUG macro is used to output a bunch of debug messages in the
driver. These messages might be useful when first creating the driver
but they shouldn't be in mainline. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/me4000.c |   35 -------------------------------
 drivers/staging/comedi/drivers/me4000.h |   13 -----------
 2 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 657d2fa..72466bf 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -860,11 +860,6 @@ static int ai_round_cmd_args(struct comedi_device *dev,
 	*scan_ticks = 0;
 	*chan_ticks = 0;
 
-	PDEBUG("ai_round_cmd_arg(): start_arg = %d\n", cmd->start_arg);
-	PDEBUG("ai_round_cmd_arg(): scan_begin_arg = %d\n",
-	       cmd->scan_begin_arg);
-	PDEBUG("ai_round_cmd_arg(): convert_arg = %d\n", cmd->convert_arg);
-
 	if (cmd->start_arg) {
 		*init_ticks = (cmd->start_arg * 33) / 1000;
 		rest = (cmd->start_arg * 33) % 1000;
@@ -904,10 +899,6 @@ static int ai_round_cmd_args(struct comedi_device *dev,
 		}
 	}
 
-	PDEBUG("ai_round_cmd_args(): init_ticks = %d\n", *init_ticks);
-	PDEBUG("ai_round_cmd_args(): scan_ticks = %d\n", *scan_ticks);
-	PDEBUG("ai_round_cmd_args(): chan_ticks = %d\n", *chan_ticks);
-
 	return 0;
 }
 
@@ -1083,32 +1074,6 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	unsigned int scan_ticks;
 	int err = 0;
 
-	PDEBUG("me4000_ai_do_cmd_test(): subdev         = %d\n", cmd->subdev);
-	PDEBUG("me4000_ai_do_cmd_test(): flags          = %08X\n", cmd->flags);
-	PDEBUG("me4000_ai_do_cmd_test(): start_src      = %08X\n",
-	       cmd->start_src);
-	PDEBUG("me4000_ai_do_cmd_test(): start_arg      = %d\n",
-	       cmd->start_arg);
-	PDEBUG("me4000_ai_do_cmd_test(): scan_begin_src = %08X\n",
-	       cmd->scan_begin_src);
-	PDEBUG("me4000_ai_do_cmd_test(): scan_begin_arg = %d\n",
-	       cmd->scan_begin_arg);
-	PDEBUG("me4000_ai_do_cmd_test(): convert_src    = %08X\n",
-	       cmd->convert_src);
-	PDEBUG("me4000_ai_do_cmd_test(): convert_arg    = %d\n",
-	       cmd->convert_arg);
-	PDEBUG("me4000_ai_do_cmd_test(): scan_end_src   = %08X\n",
-	       cmd->scan_end_src);
-	PDEBUG("me4000_ai_do_cmd_test(): scan_end_arg   = %d\n",
-	       cmd->scan_end_arg);
-	PDEBUG("me4000_ai_do_cmd_test(): stop_src       = %08X\n",
-	       cmd->stop_src);
-	PDEBUG("me4000_ai_do_cmd_test(): stop_arg       = %d\n", cmd->stop_arg);
-	PDEBUG("me4000_ai_do_cmd_test(): chanlist       = %d\n",
-	       (unsigned int)cmd->chanlist);
-	PDEBUG("me4000_ai_do_cmd_test(): chanlist_len   = %d\n",
-	       cmd->chanlist_len);
-
 	/* Only rounding flags are implemented */
 	cmd->flags &= TRIG_ROUND_NEAREST | TRIG_ROUND_UP | TRIG_ROUND_DOWN;
 
diff --git a/drivers/staging/comedi/drivers/me4000.h b/drivers/staging/comedi/drivers/me4000.h
index f87dd19..5a4df4e 100644
--- a/drivers/staging/comedi/drivers/me4000.h
+++ b/drivers/staging/comedi/drivers/me4000.h
@@ -25,19 +25,6 @@
 #define _ME4000_H_
 
 /*=============================================================================
-  Debug section
-  ===========================================================================*/
-
-#undef ME4000_DEBUG		/*  General purpose debug masseges */
-
-#ifdef ME4000_DEBUG
-#undef PDEBUG
-#define PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor,  ##args)
-#else
-#define PDEBUG(fmt, args...)	/*  no debugging, do nothing */
-#endif
-
-/*=============================================================================
   PCI vendor and device IDs
   ===========================================================================*/
 
-- 
1.7.7

