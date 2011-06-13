Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1FMLvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:51:20 -0400
Received: from relay.parallels.com ([195.214.232.42]:40151 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1FMLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:51:18 -0400
Subject: [PATCH] efifb: fix device unregister on error path
To: Peter Jones <pjones@redhat.com>, <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 13 Jun 2011 15:51:16 +0400
Message-ID: <20110613115116.7843.49566.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument of platform_device_unregister() should be efifb_device, not efifb_driver.
bug in v3.0-rc1-57-gbb8b266

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
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
 

