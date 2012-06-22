Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753Ab2FVXVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:21:09 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:15382 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2FVXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:21:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1340407267!21104015!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/31] staging: comedi: ni_daq_700: Remove unused variables from the boardinfo
Date: Fri, 22 Jun 2012 16:20:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221620.57063.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'read_byte' and 'write_byte' function pointers in the boardinfo
struct are not referenced in the driver. Just remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 99ce234d..749bc5a 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -62,10 +62,6 @@ struct dio700_board {
 	int device_id;		/*  device id for pcmcia board */
 	enum dio700_bustype bustype;	/*  PCMCIA */
 	int have_dio;		/*  have daqcard-700 dio */
-	/*  function pointers so we can use inb/outb or readb/writeb */
-	/*  as appropriate */
-	unsigned int (*read_byte) (unsigned int address);
-	void (*write_byte) (unsigned int byte, unsigned int address);
 };
 
 static const struct dio700_board dio700_boards[] = {
-- 
1.7.11

