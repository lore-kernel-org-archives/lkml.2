Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2ILM4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:03 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab2ILMz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUDACCFUFBbdWObgWdsb2JhbABFhUC2ACIBARYmJ4IgAQEFJ1IQIDFXBhOIEbxikVIDlV+TBw
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511812"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 23/24] Staging: ipack/devices/ipoctal: Unmap memory on device removal.
Date: Wed, 12 Sep 2012 14:55:45 +0200
Message-Id: <1347454546-23236-23-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 4f79fad..0292364 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -734,6 +734,9 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	tty_unregister_driver(ipoctal->tty_drv);
 	put_tty_driver(ipoctal->tty_drv);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
 	kfree(ipoctal);
 }
 
-- 
1.7.10.4

