Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2F3Ahb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:37:31 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:47107 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2F3Aha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:37:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1341016649!12979292!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/10] staging: comedi: ni_670x: remove n_ni_670x_boards macro
Date: Fri, 29 Jun 2012 17:37:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291737.26090.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is simply the ARRAY_SIZE() of the boardinfo. Just use
the ARRAY_SIZE and remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index b75eed4..d53d20c 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -96,8 +96,6 @@ struct ni_670x_private {
 	unsigned int ao_readback[32];
 };
 
-#define n_ni_670x_boards ARRAY_SIZE(ni_670x_boards)
-
 static struct comedi_lrange range_0_20mA = { 1, {RANGE_mA(0, 20)} };
 
 static int ni_670x_ao_winsn(struct comedi_device *dev,
@@ -210,7 +208,7 @@ static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot)
 				continue;
 		}
 
-		for (i = 0; i < n_ni_670x_boards; i++) {
+		for (i = 0; i < ARRAY_SIZE(ni_670x_boards); i++) {
 			if (mite_device_id(mite) == ni_670x_boards[i].dev_id) {
 				dev->board_ptr = ni_670x_boards + i;
 				devpriv->mite = mite;
-- 
1.7.11

