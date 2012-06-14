Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2FNAvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:51:06 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:61388 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2FNAvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:51:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1339635062!8443771!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: pcl816: remove unneeded tests in pcl816_ai_cmdtest
Date: Wed, 13 Jun 2012 17:50:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131750.54167.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The step 2 tests of the start_src, scan_begin_src, and scan_end_src
triggers to make sure they are unique are not needed.  These triggers
all only have one source and it was trivially validated in step 1.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl816.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index c3ee6d6..ba6911f 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -493,26 +493,11 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 	 * are unique and mutually compatible
 	 */
 
-	if (cmd->start_src != TRIG_NOW) {
-		cmd->start_src = TRIG_NOW;
-		err++;
-	}
-
-	if (cmd->scan_begin_src != TRIG_FOLLOW) {
-		cmd->scan_begin_src = TRIG_FOLLOW;
-		err++;
-	}
-
 	if (cmd->convert_src != TRIG_EXT && cmd->convert_src != TRIG_TIMER) {
 		cmd->convert_src = TRIG_TIMER;
 		err++;
 	}
 
-	if (cmd->scan_end_src != TRIG_COUNT) {
-		cmd->scan_end_src = TRIG_COUNT;
-		err++;
-	}
-
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-- 
1.7.7

