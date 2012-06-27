Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2F0BGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:06:37 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:46174 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2F0BGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:06:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1340759194!7915647!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/36] staging: comedi: cb_pcidas: fix comments in *_cmdtest functions
Date: Tue, 26 Jun 2012 18:06:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261806.09092.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some cut-and-paste comments from the skel driver in the
*_cmdtest functions. Shorten some others to fix the checkpatch.pl
complaints about WARNING: line over 80 characters.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 12fb087..95ce546 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -809,14 +809,7 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 	int tmp;
 	int i, gain, start_chan;
 
-	/* cmdtest tests a particular command to see if it is valid.
-	 * Using the cmdtest ioctl, a user can create a valid cmd
-	 * and then have it executes by the cmd ioctl.
-	 *
-	 * cmdtest returns 1,2,3,4 or 0, depending on which tests
-	 * the command passes. */
-
-	/* step 1: make sure trigger sources are trivially valid */
+	/* step 1: trigger sources are trivially valid */
 
 	tmp = cmd->start_src;
 	cmd->start_src &= TRIG_NOW | TRIG_EXT;
@@ -846,7 +839,7 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: trigger sources are unique and mutually compatible */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -872,7 +865,7 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 2;
 
-	/* step 3: make sure arguments are trivially compatible */
+	/* step 3: arguments are trivially compatible */
 
 	switch (cmd->start_src) {
 	case TRIG_EXT:
@@ -1092,14 +1085,7 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 	int err = 0;
 	int tmp;
 
-	/* cmdtest tests a particular command to see if it is valid.
-	 * Using the cmdtest ioctl, a user can create a valid cmd
-	 * and then have it executes by the cmd ioctl.
-	 *
-	 * cmdtest returns 1,2,3,4 or 0, depending on which tests
-	 * the command passes. */
-
-	/* step 1: make sure trigger sources are trivially valid */
+	/* step 1: trigger sources are trivially valid */
 
 	tmp = cmd->start_src;
 	cmd->start_src &= TRIG_INT;
@@ -1129,7 +1115,7 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: trigger sources are unique and mutually compatible */
 
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT)
@@ -1140,7 +1126,7 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 2;
 
-	/* step 3: make sure arguments are trivially compatible */
+	/* step 3: arguments are trivially compatible */
 
 	if (cmd->start_arg != 0) {
 		cmd->start_arg = 0;
-- 
1.7.11

