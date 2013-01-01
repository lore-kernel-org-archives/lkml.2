Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3AAC6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 21:58:22 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:44677 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3AAC6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 21:58:20 -0500
Message-ID: <50E250C8.2070101@nigelcunningham.com.au>
Date: Tue, 01 Jan 2013 13:58:16 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2] Re: New Defect(s) reported by Coverity Scan
References: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
In-Reply-To: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 68e866b8eac534405ae16b79b7ffd9de05c11c67 Mon Sep 17 00:00:00 2001
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
Date: Tue, 1 Jan 2013 13:50:22 +1100
Subject: [PATCH] Fix uninitialised variable in rbd_dev_probe_update_spec.

The local variable ret can be used uninitialised in the error path
if the kstrdup at line 2631 fails. Set ret to -ENOMEM in that case.

This patch addresses Coverity #753111.

Signed-off-by: Nigel Cunningham <nigel@nigelcunningham.com.au>
---
  drivers/block/rbd.c |    4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index dfb7ef8..ba4dd66 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2629,8 +2629,10 @@ static int rbd_dev_probe_update_spec(struct 
rbd_device *rbd_dev)
          goto out_err;
      }
      rbd_dev->spec->snap_name = kstrdup(name, GFP_KERNEL);
-    if(!rbd_dev->spec->snap_name)
+    if(!rbd_dev->spec->snap_name) {
+        ret = -ENOMEM;
          goto out_err;
+    }

      return 0;
  out_err:
-- 
1.7.10.4

