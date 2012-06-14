Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2FNAlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:41:47 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:26569 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2FNAlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:41:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1339634505!5735391!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: pcl818: remove unneeded tests in ai_cmdtest
Date: Wed, 13 Jun 2012 17:41:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131741.36227.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/pcl818.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 66b2570..786c3b6 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1299,22 +1299,9 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	if (cmd->start_src != TRIG_NOW) {
-		cmd->start_src = TRIG_NOW;
-		err++;
-	}
-	if (cmd->scan_begin_src != TRIG_FOLLOW) {
-		cmd->scan_begin_src = TRIG_FOLLOW;
-		err++;
-	}
 	if (cmd->convert_src != TRIG_TIMER && cmd->convert_src != TRIG_EXT)
 		err++;
 
-	if (cmd->scan_end_src != TRIG_COUNT) {
-		cmd->scan_end_src = TRIG_COUNT;
-		err++;
-	}
-
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-- 
1.7.7

