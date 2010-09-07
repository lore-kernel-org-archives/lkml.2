Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0IGFci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:32:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64494 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab0IGFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=msD+WE5hl66SrTKbOLUNUTh9rU9LmRB6awNKIbp/PxxT+VSiAEcFrkVCwaJ53Srlqh
         IC4nTB/ZSyp87dCPmrTGck/F+o3D6/qNtKzu5F5x+7MZ88Pp52yEHEYZEweruC79mtOg
         ikxIDsNxS+RkjFgfHe0HKFWADDNhZM7WxEqc0=
Subject: [PATCH 2/3] staging: xgifb: Removes compilation conditionals
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 01:32:23 -0400
Message-ID: <1283837543.6302.8.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compilation warning in today linux-next. 

The first version of this patch introduced a compilation conditional but Greg pointed me that instead of adding more compilation conditional, 
the code needs to be fixed to not need more of them.

So this patch removes some compilation conditionals to eliminate the compilation warning.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 46e7088..9722b33 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2744,7 +2744,6 @@ static void XGIfb_post_setmode(void)
 
 }
 
-#ifndef MODULE
 XGIINITSTATIC int __init XGIfb_setup(char *options)
 {
 	char *this_opt;
@@ -2827,7 +2826,6 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 	printk("\nxgifb: outa xgifb_setup 3450");
 	return 0;
 }
-#endif
 
 static unsigned char VBIOS_BUF[65535];
 
@@ -3454,13 +3452,12 @@ static struct pci_driver xgifb_driver = {
 
 XGIINITSTATIC int __init xgifb_init(void)
 {
-#ifndef MODULE
 	char *option = NULL;
 
 	if (fb_get_options("xgifb", &option))
 		return -ENODEV;
 	XGIfb_setup(option);
-#endif
+
 	return(pci_register_driver(&xgifb_driver));
 }
 
-- 
1.7.0.4



