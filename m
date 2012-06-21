Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab2FUCYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:24:03 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:44575 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2FUCYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:24:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1340245439!22817744!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/12] staging: comedi: s626: local functions should not be exposed globally
Date: Wed, 20 Jun 2012 19:23:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201923.54435.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'ResetADC' function is prototyped as a static but is missing
the static tag in it's definition. The function is only referenced
in this file so add the static tag to the definition.

This quiets a sparse warning about:

warning: symbol 'ResetADC' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d5edd9c..440060b 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1348,7 +1348,7 @@ static void s626_detach(struct comedi_device *dev)
 /*
  * this functions build the RPS program for hardware driven acquistion
  */
-void ResetADC(struct comedi_device *dev, uint8_t * ppl)
+static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 {
 	register uint32_t *pRPS;
 	uint32_t JmpAdrs;
-- 
1.7.11

