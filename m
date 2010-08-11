Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0HKICz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:02:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab0HKICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CEs9lHRN6+Fr69dOVGevzsGecQBc5AmDCGJPrMaLFdjnMjMtc0qDpMjQHbmSqw17vu
         FodbisFX4qlXE1W2LhFpnFJ/y6nMmgp/uQUo5A/dcmHjSF7i1D2wHx6gpFLoedz9hqTm
         zaWTBFbzDi567Xf1UabQ+JAStDrj0Tm36InG8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kulikov Vasiliy <segooon@gmail.com>,
        Endre Kollar <taxy443@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Brian G. Merrell" <bgmerrell@novell.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: fix memory leak
Date: Wed, 11 Aug 2010 12:02:10 +0400
Message-Id: <1281513732-5441-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If stub_probe() failed then do not increase interf_count. In original
code sdev was leaked as its interf_count never reaches 0.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/usbip/stub_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index b6b753a..b186b5f 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -427,11 +427,11 @@ static int stub_probe(struct usb_interface *interface,
 
 
 	if (busid_priv->status == STUB_BUSID_ALLOC) {
-		busid_priv->interf_count++;
 		sdev = busid_priv->sdev;
 		if (!sdev)
 			return -ENODEV;
 
+		busid_priv->interf_count++;
 		dev_info(&interface->dev,
 		 "USB/IP Stub: register a new interface "
 		 "(bus %u dev %u ifn %u)\n", udev->bus->busnum, udev->devnum,
-- 
1.7.0.4

