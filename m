Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2CSM6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:58:54 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:46862 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2CSM6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:58:53 -0400
Message-ID: <4F672D84.2080504@t-online.de>
Date: Mon, 19 Mar 2012 13:58:44 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-media@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>
Subject: [REGRESSION][PATCH] Fix kernel 3.3 DVB-S support
Content-Type: multipart/mixed;
 boundary="------------040009030709080501070204"
X-ID: SsXfcGZa8ha+4aXW0dMruMoO6qbuJAIdxd6isqcZhl8Lmw8i-ayp9npFNiywBO+Zso
X-TOI-MSGID: d8e20483-c3a5-445b-b5a6-0bf86bc7fa13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040009030709080501070204
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Kernel 3.3 breaks DVB-S reception on the
Hauppauge WinTV Nova HD-S2 and similar
cards.

The attached patch fixes this problem.

cu,
  knut

--------------040009030709080501070204
Content-Type: text/x-patch;
 name="0001-Fix-DVB-S-regression-caused-by-a-missing-initializat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-DVB-S-regression-caused-by-a-missing-initializat.pa";
 filename*1="tch"

>From 10934b412eb30fa815bad392b120eb9b83fe4ab5 Mon Sep 17 00:00:00 2001
From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Mon, 19 Mar 2012 13:31:24 +0100
Subject: [PATCH] Fix DVB-S regression caused by a missing initialization

commit 7e0722215a510921cbb73ab4c37477d4dcb91bf8 killed
struct dvb_frontend_parameters and introduced bool re_tune
instead, but the patch missed that re_tune needs an
initialization here (previously the same effect was
reached by the params = NULL).

This patch fixes broken DVB-S support for the Hauppauge
WinTV Nova HD-S2 and similar hardware in kernel 3.3.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index fbbe545..a9602e0 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -650,6 +650,7 @@ restart:
 			switch (algo) {
 			case DVBFE_ALGO_HW:
 				dprintk("%s: Frontend ALGO = DVBFE_ALGO_HW\n", __func__);
+				re_tune = false;
 
 				if (fepriv->state & FESTATE_RETUNE) {
 					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
-- 
1.7.9.2


--------------040009030709080501070204--
