Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1AYLav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:30:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1AYLau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:30:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aHZUVlMSuAeD7/QJ1Ii92epHOSQkJC0Z9SOgS2U068U57O20vXyB9Mr2x9k6HT+1ad
         ZH0r+K0u4d1zZTJq5GuqXcaYC8tg0K7p7S/rNMwErRT+nRRZmN7Kr4g77hb3zpNBPN+P
         qCMzW3EZ5zaPHpbYAPislw0oemPGiFaqIdHJ8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 01/12] staging: ft1000: Use common return point.
Date: Tue, 25 Jan 2011 12:31:12 +0100
Message-Id: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 17546d8..696e319 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -127,7 +127,7 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
 {
    int               loopcnt;
    u16            temp;
-   u32             status;
+   u32             status, ret_val = HANDSHAKE_MAG_TIMEOUT_VALUE;
 
    loopcnt = 0;
    while (loopcnt < 10)
@@ -166,7 +166,8 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
       else
       {
          DEBUG("check_usb_db: door bell is cleared, return 0\n");
-         return 0;
+	ret_val = 0;
+	break;
       }
 #if 0
       // Check if Card is present
@@ -182,7 +183,7 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
 #endif
    }
 
-   return HANDSHAKE_MAG_TIMEOUT_VALUE;
+	return ret_val;
 
 }
 
-- 
1.7.1

