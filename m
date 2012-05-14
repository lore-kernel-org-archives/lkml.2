Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2ENKxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:07 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56977 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755303Ab2ENKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:06 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 06:52:58 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB3hsE9bdWOb/2dsb2JhbABEs3CBB4IWAQUnUhBGC1cGE4gSujaRIgSVfYlYhmiCaw
X-IronPort-AV: E=Sophos;i="4.75,585,1330902000"; 
   d="scan'208";a="990372082"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Staging: ipack/devices/ipoctal: check for availability of helper functions in ipoctal_match()
Date: Mon, 14 May 2012 12:41:29 +0200
Message-Id: <1336992089-2733-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When installing the module, there could be a kernel oops due to a dereference of
a NULL pointer.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 7e370d3..df42b9b 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -799,6 +799,9 @@ static int ipoctal_match(struct ipack_device *dev)
 	int res;
 	unsigned char board_id;
 
+	if ((!dev->ops) || (!dev->ops->map_space) || (!dev->ops->unmap_space))
+		return -ENODEV;
+
 	res = dev->ops->map_space(dev, 0, IPACK_ID_SPACE);
 	if (res)
 		return res;
-- 
1.7.10

