Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1EHM4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:56:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46573 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1EHM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JCM4axIq6LfYS4iyyq9Flrk6aMn6wOA9FSVxvYXWB8S1atKjiemIh+nbC14OsJPZbs
         Ovul9HZU2BaINrzC+ppNbnl27PdqLogDhlF/vPVWDE6Vl6DJE9FMczstE0rPftca6JU/
         59JC25jUHldIvllS+r51H4izvjWpkVl1OBwgE=
Date: Sun, 8 May 2011 15:56:17 +0300
From: Maxin B John <maxin.john@gmail.com>
To: greg@kroah.com
Cc: mina86@mina86.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] usb: gadget: Remove the LUN checks which are
 always true
Message-ID: <20110508125616.GA7153@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing an unsigned integer with greater than or equal to zero is
always true.  So, it is safe to remove similar checks from 
'f_mass_storage.c' and 'file_storage.c'


Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6d8e533..cade79e 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -1910,7 +1910,7 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 		    common->lun, lun);
 
 	/* Check the LUN */
-	if (common->lun >= 0 && common->lun < common->nluns) {
+	if (common->lun < common->nluns) {
 		curlun = &common->luns[common->lun];
 		common->curlun = curlun;
 		if (common->cmnd[0] != REQUEST_SENSE) {
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index a6eacb5..a9c5177 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2314,7 +2314,7 @@ static int check_command(struct fsg_dev *fsg, int cmnd_size,
 		fsg->lun = lun;		// Use LUN from the command
 
 	/* Check the LUN */
-	if (fsg->lun >= 0 && fsg->lun < fsg->nluns) {
+	if (fsg->lun < fsg->nluns) {
 		fsg->curlun = curlun = &fsg->luns[fsg->lun];
 		if (fsg->cmnd[0] != REQUEST_SENSE) {
 			curlun->sense_data = SS_NO_SENSE;
