Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0KCNL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:11:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38139 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0KCNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nnpH5nSoMOj6gpHICUejMRwTcQYC8ZqBwX5+Md8+60hkLc+yS7+6jlhm2ChhSdxdyJ
         62kmZPWcLFBPYoETQrY7tpeACIy+cvw6chE4kntucReq3DE3t6JsnQ9jwh/C273ldZrx
         acTxG3Cwvxmp/rgXEXrhcLwiLSiFVegNarN9U=
Message-ID: <4CD15F60.8090305@gmail.com>
Date: Wed, 03 Nov 2010 18:40:56 +0530
From: Atul Sowani <sowani@gmail.com>
Reply-To: sowani@gmail.com
Organization: Digital Reality Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: arnaud.patard@rtp-net.org
CC: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH 2.6.36 1/1] xgifb: change obsolete pci_find_device() with
 pci_get_device().
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced obsolete pci_find_device() calls with pci_get_device() calls. This is
recommended in pci.txt filei in PCI Documentation.

Signed-off-by: Atul Sowani <sowani@gmail.com>
---
--- a/drivers/staging/xgifb/XGI_main_26.c	2010-10-21 02:00:22.000000000 +0530
+++ b/drivers/staging/xgifb/XGI_main_26.c	2010-11-03 18:35:18.000000000 +0530
@@ -483,9 +483,11 @@ XGIfb_query_VGA_config_space(struct xgi_
 			break;
 		}

-		pdev = pci_find_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
-		if (pdev)
+		pdev = pci_get_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
+		if (pdev) {
 			valid_pdev = 1;
+			pci_dev_put(pdev);
+		}
 	}

 	if (!valid_pdev) {

