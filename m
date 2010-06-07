Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0FGRAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:00:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0FGRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:00:20 -0400
X-Authority-Analysis: v=1.1 cv=Ptnq/yUmAfEM+p2YGg/PtcDvGLwHOfBY9Lw52vkkfiU= c=1 sm=0 a=REpaqF04bTAA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=uY6puzNKNxKwnWNvYTGQSA==:17 a=yQdBAQUQAAAA:8 a=xuB5J63s0uSSaxGj2cEA:9 a=O9sMoFmkvnGvSvANnos6iIFRJMMA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=uY6puzNKNxKwnWNvYTGQSA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.93.65
Date: Mon, 07 Jun 2010 12:00:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8187se: Fix compile warnings in 2.6.35-rc2
Message-ID: <4c0d25bc.kKU10fWqlRtt6mUb%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit bbfb5652, the spacing in the definitions of eqMacAddr and cpMacAddr
in drivers/staging/rtl8187se/r8180_core.c were changed to conform to kernel
standards. These definitions were duplicates of lines found in
drivers/staging/rtl8187se/ieee80211/dot11d.h. Once the change was made, the
following warnings were emitted:

  CC [M]  drivers/staging/rtl8187se/r8180_core.o
drivers/staging/rtl8187se/r8180_core.c:69:0: warning: "eqMacAddr" redefined
drivers/staging/rtl8187se/ieee80211/dot11d.h:39:0: note: this is the location of the previous definition
drivers/staging/rtl8187se/r8180_core.c:70:0: warning: "cpMacAddr" redefined
drivers/staging/rtl8187se/ieee80211/dot11d.h:40:0: note: this is the location of the previous definition

The fix is to keep only the difinition in the header file.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Greg,

This one has very low priority.

Larry
---

Index: linux-2.6/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
+++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
@@ -66,8 +66,6 @@ static int hwseqnum = 0;
 static int hwwep = 0;
 static int channels = 0x3fff;
 
-#define eqMacAddr(a, b)		(((a)[0] == (b)[0] && (a)[1] == (b)[1] && (a)[2] == (b)[2] && (a)[3] == (b)[3] && (a)[4] == (b)[4] && (a)[5] == (b)[5]) ? 1 : 0)
-#define cpMacAddr(des, src)		((des)[0] = (src)[0], (des)[1] = (src)[1], (des)[2] = (src)[2], (des)[3] = (src)[3], (des)[4] = (src)[4], (des)[5] = (src)[5])
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, rtl8180_pci_id_tbl);
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
