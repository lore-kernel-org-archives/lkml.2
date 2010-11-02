Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0KBNty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:49:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53736 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab0KBNtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DRWtqdt7eM9lPP/OdC0qg79m0J8dVEXo8bHXQY1h9cmWGzkp2HdvCl2sHOUSb/rHq5
         NGyE+K52wg0sjkiKu/wKwp9KQXte7AfHqcgfrlmrIG7HNlB7J4rwGCJtETDdBVENLRZW
         qjxVDMxZ+Ov/m/LN/SETGOrUsURtAN11Omv4I=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/4] staging: ft1000: Correct return error values.
Date: Tue,  2 Nov 2010 14:51:46 +0100
Message-Id: <1288705907-30725-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
References: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 0de4a2e..30a8475 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1306,7 +1306,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
     {
         DEBUG("network driver is closed, return\n");
         //usb_kill_urb(pFt1000Dev->rx_urb); //mbelian
-        return STATUS_SUCCESS;
+	return -ENODEV;
     }
 
     usb_fill_bulk_urb(pFt1000Dev->rx_urb,
@@ -1321,12 +1321,12 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
     if((result = usb_submit_urb(pFt1000Dev->rx_urb, GFP_ATOMIC)))
     {
         printk("ft1000_submit_rx_urb: submitting rx_urb %d failed\n", result);
-        return STATUS_FAILURE;
+	return result;
     }
 
     //DEBUG("ft1000_submit_rx_urb exit: result=%d\n", result);
 
-    return STATUS_SUCCESS;
+	return 0;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

