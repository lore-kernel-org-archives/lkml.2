Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab2HWOKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:10:17 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50599 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932730Ab2HWOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:10:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH] driver core: Check if r->name is valid in platform_get_resource_byname()
Date: Thu, 23 Aug 2012 17:10:00 +0300
Message-Id: <1345731000-12768-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Safety check for the validity of the resource name before calling strcmp().
If the resource name is NULL do not compare it, just skip it.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hi Greg,

I have experienced with a kernel crash because the r->name was NULL when booting
OMAP4+ kernel with devicetree.
I have sent a separate patch for the OMAP specific root (with analysis of the
issue):
http://marc.info/?l=linux-omap&m=134573006327647&w=2

I agree that it is unlikely to have the name NULL, but I think it does not hurt
if we do a safety check before comparing the strings.

Best Regards,
Peter

 drivers/base/platform.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index a1a7225..d717c2b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -99,6 +99,9 @@ struct resource *platform_get_resource_byname(struct platform_device *dev,
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
 
+		if (unlikely(!r->name))
+			continue;
+
 		if (type == resource_type(r) && !strcmp(r->name, name))
 			return r;
 	}
-- 
1.7.8.6

