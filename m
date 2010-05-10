Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0EJDKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 23:10:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0EJDKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 23:10:04 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=OSa6LGZCsqQA:10 a=kj9zAlcOel0A:10 a=WxJesoNaWm532U2cE8BZSA==:17 a=1nSz6Ew-AAAA:8 a=yQdBAQUQAAAA:8 a=mK_AVkanAAAA:8 a=VwQbUJbxAAAA:8 a=ekY9S3S0x0E7flzpaLgA:9 a=HLs1mA-S-8JQwpb_yw6NrlrJYxgA:4 a=CjuIK1q_8ugA:10 a=A71SCvCayfUA:10 a=IcxpeKGZWnEA:10 a=9xyTavCNlvEA:10 a=LI9Vle30uBYA:10 a=WxJesoNaWm532U2cE8BZSA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.235
Date: Sun, 09 May 2010 22:10:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: Fix kernel BUG on driver wpa
 initialization
Message-ID: <4be7790a.wZDbQM7BmE3rtf35%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In http://bugzilla.novell.com/show_bug.cgi?id=597299, the vt6655 driver
generates a kernel BUG on a NULL pointer dereference at NULL. This problem
has been traced to a failure in the wpa_set_wpadev() routine. As the vt6656
driver does not call this routine, the vt6655 code is similarly set to skip
the call.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Richard Meek <osl2008@googlemail.com>
Cc: Stable <stable@kernel.org>
---

Greg,

The OP for the  Novelle Bugzilla report has only reported that this patch
cures the kernel oops/panic, thus I don't know if the driver works. It seems
likely that no one actually tested the driver as it could never have worked
with the original code.

Larry
---

Index: wireless-testing/drivers/staging/vt6655/device_main.c
===================================================================
--- wireless-testing.orig/drivers/staging/vt6655/device_main.c
+++ wireless-testing/drivers/staging/vt6655/device_main.c
@@ -1090,11 +1089,13 @@ device_found1(struct pci_dev *pcid, cons
     }
 //2008-07-21-01<Add>by MikeLiu
 //register wpadev
+#if 0
    if(wpa_set_wpadev(pDevice, 1)!=0) {
      printk("Fail to Register WPADEV?\n");
         unregister_netdev(pDevice->dev);
         free_netdev(dev);
    }
+#endif
     device_print_info(pDevice);
     pci_set_drvdata(pcid, pDevice);
     return 0;
