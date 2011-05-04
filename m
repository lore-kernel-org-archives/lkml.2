Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1EDPEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:04:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64575 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1EDPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=maza3d0xIlpUMTf/LmzKIkAsyhDYxTrThdekvYZhIqQ7s8urnyY07I6FADMM4tSimJ
         YcPYDpCTalWtI07HNzQLhKCSRdZdUSADhztTPq8e6FTQwQmgkfNHs6Qhzq6B/ljN2Hgw
         eQfq6gtQ5Uk4wdcoLdRlShjUJGcVS9zznPotg=
MIME-Version: 1.0
In-Reply-To: <op.vuynsdh13l0zgt@mnazarewicz-glaptop>
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
	<op.vuynsdh13l0zgt@mnazarewicz-glaptop>
Date: Wed, 4 May 2011 16:04:03 +0100
Message-ID: <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
From: Maxin John <maxin.john@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thank you very much for reviewing the patch.

> file_storage.c has the same check, could you remove it as well.

Please find the patch for "file_storage.c" below. Should I merge these
two patches and re-submit as a single one?

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/usb/gadget/file_storage.c
b/drivers/usb/gadget/file_storage.c
index a6eacb5..a9c5177 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2314,7 +2314,7 @@ static int check_command(struct fsg_dev *fsg,
int cmnd_size,
                fsg->lun = lun;         // Use LUN from the command

        /* Check the LUN */
-       if (fsg->lun >= 0 && fsg->lun < fsg->nluns) {
+       if (fsg->lun < fsg->nluns) {
                fsg->curlun = curlun = &fsg->luns[fsg->lun];
                if (fsg->cmnd[0] != REQUEST_SENSE) {
                        curlun->sense_data = SS_NO_SENSE;
