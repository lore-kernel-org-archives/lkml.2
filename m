Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0KCKSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64555 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0KCKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BQlzWcqI4J+QSpQwNjqpm2UXSWhmBp+2mVQoGfr59oEzM5/FpFtzDjJfkhJgBM0xpF
         UH54R9bV5KIH6HesvU+uJakIFsDmWZbPYzyHzSlLd06qMaWW2lInZswkgVV5qSWgLz0Z
         WEkianrH7lJYTI3YbuAFYhLnItEsP4N7h/tPY=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 8/9] staging: ft1000: Get rid of PCHAR typedef usage.
Date: Wed,  3 Nov 2010 11:19:54 +0100
Message-Id: <1288779595-15793-8-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index a0ff140..d64ce45 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -726,7 +726,7 @@ static int ft1000_reset_card (struct net_device *dev)
 
     // Initialize DSP heartbeat area to ho
     ft1000_write_dpram16(ft1000dev, FT1000_MAG_HI_HO, ho_mag, FT1000_MAG_HI_HO_INDX);
-    ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (PCHAR)&tempword, FT1000_MAG_HI_HO_INDX);
+    ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (u8 *)&tempword, FT1000_MAG_HI_HO_INDX);
     DEBUG("ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n", tempword);
 
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index ad1eb9f..340e845 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -98,7 +98,6 @@ struct prov_record {
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
-#define PCHAR               u8 *
 #define UINT                u32
 
 #define FALSE           0
-- 
1.7.1

