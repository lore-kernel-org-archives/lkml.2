Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2K0MYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:24:31 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:53626 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab2K0MYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:24:30 -0500
X-Greylist: delayed 2173 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 07:24:30 EST
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Date: Tue, 27 Nov 2012 13:48:14 +0200
User-Agent: KMail/1.9.10
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211271348.14603.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning: 'ret' might be used uninitialized

Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
---
 drivers/uio/uio.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..c33fd18 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -280,12 +280,16 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 			map_found = 1;
 			idev->map_dir = kobject_create_and_add("maps",
 							&idev->dev->kobj);
-			if (!idev->map_dir)
+			if (!idev->map_dir) {
+				ret = -ENOMEM;
 				goto err_map;
+			}
 		}
 		map = kzalloc(sizeof(*map), GFP_KERNEL);
-		if (!map)
+		if (!map) {
+			ret = -ENOMEM;
 			goto err_map;
+		}
 		kobject_init(&map->kobj, &map_attr_type);
 		map->mem = mem;
 		mem->map = map;
@@ -305,12 +309,16 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 			portio_found = 1;
 			idev->portio_dir = kobject_create_and_add("portio",
 							&idev->dev->kobj);
-			if (!idev->portio_dir)
+			if (!idev->portio_dir) {
+				ret = -ENOMEM;
 				goto err_portio;
+			}
 		}
 		portio = kzalloc(sizeof(*portio), GFP_KERNEL);
-		if (!portio)
+		if (!portio) {
+			ret = -ENOMEM;
 			goto err_portio;
+		}
 		kobject_init(&portio->kobj, &portio_attr_type);
 		portio->port = port;
 		port->portio = portio;
-- 
1.7.8.6
