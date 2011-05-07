Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1EGJ2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 05:28:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55440 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1EGJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 05:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IAwpU8j6O1hJ++H3U51vSPjx5IqpXBGGKVXIx6GYnXb5LjVRwmtXTXsx0TBEHzt0F8
         ulKH9e6zHmEjRUNa9oJHPD0LT41Xb1DvnvXaoyyYU9HHD2jj8bv2YXnP81LA0tAd7Mdj
         mvdcdz1ji0Mq4El41Mij25VAYv7whcXezmMTM=
MIME-Version: 1.0
In-Reply-To: <20110507010927.GA32142@kroah.com>
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
	<op.vuynsdh13l0zgt@mnazarewicz-glaptop>
	<BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
	<20110507010927.GA32142@kroah.com>
Date: Sat, 7 May 2011 12:27:58 +0300
Message-ID: <BANLkTikPgm7kpaoofVSkJCBXYyea4HeB8A@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
From: Maxin John <maxin.john@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, gregkh@suse.de,
        stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>> Please find the patch for "file_storage.c" below. Should I merge these
>> two patches and re-submit as a single one?
>
> Yes please.

As per your suggestion, please find the merged patch below:

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
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
