Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2FYX5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:57:50 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:22644 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2FYX5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:57:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1340668668!12191795!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/33] staging: comedi: cb_das16_cs: remove n_boards define
Date: Mon, 25 Jun 2012 16:57:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251657.36998.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'n_boards' define is only used one place in the driver.
Just put the ARRAY_SIZE() where used and remove the define.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 496c331..e1e3ff0 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -84,8 +84,6 @@ static const struct das16cs_board das16cs_boards[] = {
 	 },
 };
 
-#define n_boards ARRAY_SIZE(das16cs_boards)
-
 struct das16cs_private {
 	struct pcmcia_device *link;
 
@@ -467,7 +465,7 @@ static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
 {
 	int i;
 
-	for (i = 0; i < n_boards; i++) {
+	for (i = 0; i < ARRAY_SIZE(das16cs_boards); i++) {
 		if (das16cs_boards[i].device_id == link->card_id)
 			return das16cs_boards + i;
 	}
-- 
1.7.11

