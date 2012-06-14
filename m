Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2FNA6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:58:15 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:59972 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2FNA6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:58:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1339635493!1182923!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: pcl812: remove unneeded tests in pcl812_ai_cmdtest
Date: Wed, 13 Jun 2012 17:58:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131758.07899.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The step 2 tests to make sure that the triggers are unique is not
needed for single source triggers. These were already trivially
validated in step 1.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl812.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 0a4074a..511c901 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -612,33 +612,6 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 	 * unique and mutually compatible
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
-	if (devpriv->use_ext_trg) {
-		if (cmd->convert_src != TRIG_EXT) {
-			cmd->convert_src = TRIG_EXT;
-			err++;
-		}
-	} else {
-		if (cmd->convert_src != TRIG_TIMER) {
-			cmd->convert_src = TRIG_TIMER;
-			err++;
-		}
-	}
-
-	if (cmd->scan_end_src != TRIG_COUNT) {
-		cmd->scan_end_src = TRIG_COUNT;
-		err++;
-	}
-
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-- 
1.7.7

