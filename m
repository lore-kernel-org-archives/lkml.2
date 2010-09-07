Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0IGF2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:28:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43196 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0IGF2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=s4gSi4oid/mxk04rBDqVA95ridx8Kq5/IwBzrh/92PWg2ibGAvmQwCe0yzvttokIos
         zJFzJu1pOpGgxRj9VPAzgFLz3T1igLFGG0c14gzy5/PD5LO1bMbnvoRV1EHG3864tujZ
         fTz3CWRX42foZT6Ti9M2ERe0RfAS3ZlFTStpI=
Subject: [PATCH 1/1] staging: xgifb: Removes unnecessary log
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 01:28:29 -0400
Message-ID: <1283837309.6302.4.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compile warning in today linux-next.

The first version of this patch casted XGIFB_GET_INFO to unsigned long, but Greg suggest that I should use %p instead and that the whole message is just looney.

So this patch removes the unnecessary log.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 7cd3e95..46e7088 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3417,13 +3417,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		XGIfb_registered = 1;
 
-		printk(KERN_INFO "XGIfb: Installed XGIFB_GET_INFO ioctl (%lx)\n",
-		       XGIFB_GET_INFO);
-
-/*		printk(KERN_INFO "XGIfb: 2D acceleration is %s, scrolling mode %s\n",
-		     XGIfb_accel ? "enabled" : "disabled",
-		     XGIfb_ypan  ? "ypan" : "redraw");
-*/
 		printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
 	       		fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
 
-- 
1.7.0.4



