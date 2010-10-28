Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab0J1UEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:04:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53485 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab0J1UCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SPA2usWTswHWWaPk99opblRVWtu0zAB7vuv8AcmI1g9YFKWa9+Q4+zRjBqX6IPmPdS
         oDHnw4mzFATZStwfcjaZ9NUNUcf/5i4sqB7MhKxuO7bu4xWzCSySaX/aWOAda6baQOn7
         9qRMIbRkeGUNF3VQJYWHVfgZg3eHwpCz9S5AA=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andres More <more.andres@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Shawn Bohrer <shawn.bohrer@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] staging: vt6656: implement missing brackets
Date: Fri, 29 Oct 2010 00:02:11 +0400
Message-Id: <1288296132-19302-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identation says that copy_to_user() should be called only iff
wrq->u.essid.pointer is not zero.  Also it is useless to call copy_to_user(0, ...).

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/vt6656/main_usb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e992d5d..7cc3d24 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1675,13 +1675,14 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 		{
 			char essid[IW_ESSID_MAX_SIZE+1];
-			if (wrq->u.essid.pointer)
+			if (wrq->u.essid.pointer) {
 				rc = iwctl_giwessid(dev, NULL,
 						    &(wrq->u.essid), essid);
 				if (copy_to_user(wrq->u.essid.pointer,
 						         essid,
 						         wrq->u.essid.length) )
 					rc = -EFAULT;
+			}
 		}
 		break;
 
-- 
1.7.0.4

