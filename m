Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762Ab2FVXWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:22:08 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:24803 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2FVXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:22:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1340407326!6655632!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/31] staging: comedi: ni_daq_700: Remove unneeded variables from the boardinfo
Date: Fri, 22 Jun 2012 16:21:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221621.55938.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'device_id' and 'have_dio' variables in the boardinfo struct are
initialized but not referenced in the driver. Just remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 749bc5a..47e8cf4 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -59,25 +59,17 @@ enum dio700_bustype { pcmcia_bustype };
 
 struct dio700_board {
 	const char *name;
-	int device_id;		/*  device id for pcmcia board */
 	enum dio700_bustype bustype;	/*  PCMCIA */
-	int have_dio;		/*  have daqcard-700 dio */
 };
 
 static const struct dio700_board dio700_boards[] = {
 	{
 	 .name = "daqcard-700",
-	  /*  0x10b is manufacturer id, 0x4743 is device id */
-	 .device_id = 0x4743,
 	 .bustype = pcmcia_bustype,
-	 .have_dio = 1,
 	 },
 	{
 	 .name = "ni_daq_700",
-	  /*  0x10b is manufacturer id, 0x4743 is device id */
-	 .device_id = 0x4743,
 	 .bustype = pcmcia_bustype,
-	 .have_dio = 1,
 	 },
 };
 
-- 
1.7.11

