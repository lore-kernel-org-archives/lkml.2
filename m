Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2FZRJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:09:24 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:38763 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab2FZRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:09:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1340730546!23338905!34
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: comedi: cb_das16_cs: remove unneeded default case in analog in read
Date: Tue, 26 Jun 2012 10:08:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261008.52962.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default (return -EINVAL) case is not needed when working
out the correct value to set the analog input range. As pointed
out by Ian Abbott, the comedi core checks the range in
comedi_check_chanlist() before calling the insn_read() function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 95fa7e2..58d4529 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -136,8 +136,6 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 	case 3:
 		devpriv->status2 |= 0x200;
 		break;
-	default:
-		return -EINVAL;
 	}
 	outw(devpriv->status2, dev->iobase + DAS16CS_MISC2);
 
-- 
1.7.11

