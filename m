Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1CJKwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34245 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1CJKwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rg83LVDH8ESQJflUHL7qet2li2hbSyh/EJdbkkz+nwrlbAmdZd38K7L6RuBf56NlsL
         YqnBYIJBki6/FdrDU9hF8yhDBj9YZmDAgMj0jek6Xb88hRtNEkkDBbOt/qYNXh57udzg
         JFsFNTyb00YMo4OjOGja/HQi2piC7JEk9akV0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 11/21] staging: ft1000: Fix coding style in ft1000_usb_transmit_complete function.
Date: Thu, 10 Mar 2011 11:51:25 +0100
Message-Id: <1299754295-8493-12-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style and also replace printk with proper pr_err
function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 4c5f443..958292e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -902,14 +902,14 @@ static int ft1000_reset(struct net_device *dev)
 static void ft1000_usb_transmit_complete(struct urb *urb)
 {
 
-    struct ft1000_device *ft1000dev = urb->context;
+	struct ft1000_device *ft1000dev = urb->context;
 
     //DEBUG("ft1000_usb_transmit_complete entered\n");
 
-    if (urb->status)
-        printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
+	if (urb->status)
+		pr_err("%s: TX status %d\n", ft1000dev->net->name, urb->status);
 
-    netif_wake_queue(ft1000dev->net);
+	netif_wake_queue(ft1000dev->net);
 
     //DEBUG("Return from ft1000_usb_transmit_complete\n");
 }
-- 
1.7.1

