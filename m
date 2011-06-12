Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1FLKxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 06:53:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57568 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1FLKxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 06:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=n7d2uDGXq9tor4YUftChksqlrX2kgTFClMrdrSWwt9O7jSi1Nf2x2tq4BBauBz8v0J
         R/K00zgGgnEJYMcMeREBK2tyxv++rJn7Q57T2xYAR8/ELio1iT7qLRxOhU2IVwWFHNKE
         Z6PmWppMB4ccRZscLa5e/l/jIPnS3If4fgWIg=
Subject: re:[PATCH] efifb: Fix call to wrong unregister function
From: "wanlong.gao" <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Jun 2011 18:52:33 +0800
Message-ID: <1307875953.1859.6.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

Hi Maarten:
It registered efifb_device but try to unregistered efifb_driver,
so I think you should fix it like this?

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/video/efifb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 69c49df..784139a 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -541,7 +541,7 @@ static int __init efifb_init(void)
 	 */
 	ret = platform_driver_probe(&efifb_driver, efifb_probe);
 	if (ret) {
-		platform_device_unregister(&efifb_driver);
+		platform_device_unregister(&efifb_device);
 		return ret;
 	}
 
-- 
1.7.4.1


