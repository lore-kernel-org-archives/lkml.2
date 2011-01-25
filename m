Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1AYLHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:07:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1AYLHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=AeY9yZrjCEx6gedkHzuYS9xSsz6KyOLaS/Ayip82U2K+jIrNaLMrsrVbpgTnp3Rlor
         n3zyw+so08ySeufB/lMfejet1rbvvkK/CIV7zk+/XyGmvYDVzOJUD/vu7wh2kMT0DR6H
         H7zDs9SV0t1sItg1rwIvGpTcL98tWJQkoD7lQ=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 01/12] staging: ft1000: Use common return point.
Date: Tue, 25 Jan 2011 12:08:06 +0100
Message-Id: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
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

