Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2FHAb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:31:26 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:3045 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2FHAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:31:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1339115484!7820132!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci9118: if test should use logical AND not bitwise AND
Date: Thu, 7 Jun 2012 17:31:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206071731.19499.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets a couple sparse warnings about:

warning: dubious: !x & y

Also, remove the unnecessary parentheses around the variables.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 3670ebd..5a5c903 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1735,7 +1735,7 @@ static int check_channel_list(struct comedi_device *dev,
 							"can't be mixtured!");
 				return 0;
 			}
-			if ((!devpriv->usemux) & (differencial) &
+			if (!devpriv->usemux && differencial &&
 			    (CR_CHAN(chanlist[i]) >= this_board->n_aichand)) {
 				comedi_error(dev,
 					     "If AREF_DIFF is used then is "
