Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1BFUuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:50:19 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22297 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1BFUuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:50:18 -0500
Date: Sun, 6 Feb 2011 21:49:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Holger Waechtler <holger@convergence.de>,
        Felix Domke <tmbinc@elitedvb.net>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] TTUSB DVB: ttusb_boot_dsp() needs to release_firmware() or
 it leaks memory.
Message-ID: <alpine.LNX.2.00.1102062145160.13593@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c:ttusb_boot_dsp() we 
need to call release_firmware(fw) before returning or we'll leak - no 
matter if we succeed or fail.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dvb-ttusb-budget.c |    1 +
 1 file changed, 1 insertion(+)

 compile tested only.

diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 40625b2..cbe2f0d 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -334,6 +334,7 @@ static int ttusb_boot_dsp(struct ttusb *ttusb)
 	err = ttusb_cmd(ttusb, b, 4, 0);
 
       done:
+	release_firmware(fw);
 	if (err) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
 			__func__, err);

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

