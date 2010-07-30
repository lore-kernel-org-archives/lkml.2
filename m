Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab0G3LJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:09:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59830 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab0G3LJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kiTrQ9MS001Pm6swUPjJgx5NvpnoEL/J1CoBQat27ah1aV8dDntbzRME/0zJgeI3D6
         YfvqvEFmxhy2HLp8FvT+N/7rWisMOcLyWryxdlIwU8dprp9kC215r2Nhos/Jto/Uns8S
         LrSZ2WXKKS84AQlnkzlXx3OSORxFqEe0LxwTI=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] staging: rtl8192su: check whether requests succeeded
Date: Fri, 30 Jul 2010 15:09:02 +0400
Message-Id: <1280488143-20899-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8192_usb_probe() does not check alloc_ieee80211() and
register_netdev() return values for errors.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rtl8192su/r8192U_core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index b69e198..8acfaaf 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -7385,6 +7385,8 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
         RT_TRACE(COMP_INIT, "Oops: i'm coming\n");
 
 	dev = alloc_ieee80211(sizeof(struct r8192_priv));
+	if (dev == NULL)
+		return -ENOMEM;
 
 	usb_set_intfdata(intf, dev);
 	SET_NETDEV_DEV(dev, &intf->dev);
@@ -7422,7 +7424,8 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 	netif_carrier_off(dev);
 	netif_stop_queue(dev);
 
-	register_netdev(dev);
+	if (register_netdev(dev))
+		goto fail;
 	RT_TRACE(COMP_INIT, "dev name=======> %s\n",dev->name);
 	rtl8192_proc_init_one(dev);
 
-- 
1.7.0.4

