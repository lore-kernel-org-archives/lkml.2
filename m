Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0KBMmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:42:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57398 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0KBMmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V74Fr/5NNi0Rw0V+Fw6zQ97E/Vxi4nAiRzvgvSsnww6bg7JWZYbeEmzLRDQLtcTIEb
         vv4/yKKwRda19LVyRuLgnV2hHs/KXXIqp9f46wLAAonWOv7Gu3c5Hdy0wnOvwfnJPfff
         wMxlZb4gXIkN9fRbqJTlBMB5vJJNDKY8qWrZQ=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/3] staging: ft1000: Use memset instead looping with for.
Date: Tue,  2 Nov 2010 13:44:08 +0100
Message-Id: <1288701850-29123-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 5b89ee2..bc6aaf4 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -874,10 +874,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     pInfo->fCondResetPend = 0;
 	pInfo->usbboot = 0;
 	pInfo->dspalive = 0;
-	for (i=0;i<32 ;i++ )
-	{
-		pInfo->tempbuf[i] = 0;
-	}
+	memset(&pInfo->tempbuf[0], 0, sizeof(pInfo->tempbuf));
 
     INIT_LIST_HEAD(&pInfo->prov_list);
 
-- 
1.7.1

