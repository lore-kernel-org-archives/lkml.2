Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861Ab2FVXgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:36:04 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:47422 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab2FVXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:36:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1340408161!12239532!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/31] staging: comedi: ni_daq_700: fix return for insn_config function
Date: Fri, 22 Jun 2012 16:35:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221635.58138.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi insn_config functions should return < 0 for errors or
the number of data elements used to perform the command, this value
is available as 'insn->n'. Return that instead of the open coded
number to better indicate what the return means.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 2ea3c8d..cc46948 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -89,13 +89,12 @@ static int subdev_700_insn_config(struct comedi_device *dev,
 		break;
 	case INSN_CONFIG_DIO_QUERY:
 		data[1] = (s->io_bits & chan) ? COMEDI_OUTPUT : COMEDI_INPUT;
-		return insn->n;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	return 1;
+	return insn->n;
 }
 
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-- 
1.7.11

