Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783Ab2FVXZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:25:42 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:10009 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab2FVXZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:25:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1340407538!7544540!4
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/31] staging: comedi: ni_daq_700: remove thisboard macro
Date: Fri, 22 Jun 2012 16:25:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221625.26675.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro relies on a local variable having a specific
name and yields a pointer derived from that local variable.
Replace the macro with local variables and use the comedi_board()
helper to get the pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 864bef7..2f84934 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -59,11 +59,6 @@ struct dio700_board {
 	const char *name;
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct dio700_board *)dev->board_ptr)
-
 #define _700_SIZE 8
 
 #define _700_DATA 0
@@ -178,6 +173,7 @@ static void subdev_700_cleanup(struct comedi_device *dev,
 
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct dio700_board *thisboard = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase = 0;
 #ifdef incomplete
-- 
1.7.11

