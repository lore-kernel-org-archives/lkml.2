Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1EDOQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:16:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39580 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1EDOQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=DDtfgUyNzh2Hv25u7Nas/1+ckpJ8tDYv/pv1a370vOOI2OUQzpdIfUjomUKX6PRN04
         r20EDzjyPAg+mlRrIr1NKOUgfxp5quSTg68Bxg4JeSt7BCzRSU3/Zo/k7lC3TAbBnfJw
         Uz+QE5K01dOb1aliHynrDv5IvBLtGl2/i7wAI=
MIME-Version: 1.0
Date: Wed, 4 May 2011 15:16:05 +0100
Message-ID: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
Subject: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which is
 always true
From: Maxin John <maxin.john@gmail.com>
To: m.nazarewicz@samsung.com
Cc: gregkh@suse.de, stern@rowland.harvard.edu, mina86@mina86.com,
        m-sonasath@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, roger.quadros@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since comparing an unsigned int (common->lun)  greater than or equal
to zero is always true, I think it is safe to remove this check.
Please let me know your comments.

Thanks to Coverity for pointing this out.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/usb/gadget/f_mass_storage.c
b/drivers/usb/gadget/f_mass_storage.c
index 6d8e533..cade79e 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -1910,7 +1910,7 @@ static int check_command(struct fsg_common
*common, int cmnd_size,
                    common->lun, lun);

        /* Check the LUN */
-       if (common->lun >= 0 && common->lun < common->nluns) {
+       if (common->lun < common->nluns) {
                curlun = &common->luns[common->lun];
                common->curlun = curlun;
                if (common->cmnd[0] != REQUEST_SENSE) {
