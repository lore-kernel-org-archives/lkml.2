Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0JOIyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:54:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0JOIxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=feJwujleSfQCO6qSipX2VTgItxdEO2QOa3kmugDtM39eLcMDpuqtl5mMqy1fTZOo+p
         JjwZPHuHiumyznw/Uy2EoVBLcY3ynPnEJxsjzMLzuGrnVu36k1+Iya9Z6B4TdXeOI/76
         h26wWiuvuf0lAIjRDmx6AkOPaQyH0xF7uzEao=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/2] staging:ft1000: Check return value when init net device.
Date: Fri, 15 Oct 2010 08:57:24 +0200
Message-Id: <1287125845-12825-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 44c475b..a2c415e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -159,7 +159,11 @@ static int ft1000_probe(struct usb_interface *interface,
 	release_firmware(dsp_fw);
 
 	DEBUG("ft1000_probe: start downloading dsp image...\n");
-	init_ft1000_netdev(ft1000dev);
+
+	ret = init_ft1000_netdev(ft1000dev);
+	if (ret)
+		goto err_load;
+
 	pft1000info = (FT1000_INFO *) netdev_priv(ft1000dev->net);
 
 	DEBUG("In probe: pft1000info=%p\n", pft1000info);
-- 
1.7.1

