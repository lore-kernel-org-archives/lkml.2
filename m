Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2I0KmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:42:06 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:61076 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2I0Kgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAxVwYTiAm3b5E1A5VpiTyJWA
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447814"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 08/17] staging: ipack/devices/ipoctal: fix ipoctal_inst_slot error path.
Date: Thu, 27 Sep 2012 12:37:32 +0200
Message-Id: <1348742261-28145-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

The ordering was wrong.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 14a0aed..d9dbb3f 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -460,13 +460,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	return 0;
 
 out_unregister_slot_unmap:
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
 out_unregister_int_space:
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
 out_unregister_io_space:
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
 out_unregister_id_space:
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
 	return res;
 }
 
-- 
1.7.10.4

