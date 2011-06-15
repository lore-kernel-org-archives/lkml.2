Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1FOAjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1FOAjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:39:37 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] EFIFB: Fix error handling
To: pjones@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Peter Jones <pjones@redhat.com>,
        linux-fbdev@vger.kernel.org, stable@kernel.org
Date: Wed, 15 Jun 2011 01:38:17 +0100
Message-ID: <20110615003817.18883.41030.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error handling in the EFIFB driver if platform_driver_probe() fails.
In that case, the code will pass the driver struct to the _device_
unregistration function.  It presumably should pass a pointer to the device
struct instead.

The compiler gives the following warning to indicate this:

drivers/video/efifb.c: In function 'efifb_init':
drivers/video/efifb.c:544:3: warning: passing argument 1 of 'platform_device_unregister' from incompatible pointer type
include/linux/platform_device.h:40:13: note: expected 'struct platform_device *' but argument is of type 'struct platform_driver *'

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Peter Jones <pjones@redhat.com>
cc: linux-fbdev@vger.kernel.org
cc: stable@kernel.org
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
 

