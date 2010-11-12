Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab0KLVjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:39:00 -0500
Received: from mail.perches.com ([173.55.12.10]:1028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174Ab0KLViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:18 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] drivers/video: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:38:03 -0800
Message-Id: <b0257de80d350609c24a686acee9117be0257da4.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/platinumfb.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index a50e197..cfe3c79 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -557,12 +557,8 @@ static int __devinit platinumfb_probe(struct platform_device* odev,
 		framebuffer_release(info);
 		return -ENXIO;
 	}
-	dev_dbg(&odev->dev, " registers  : 0x%llx...0x%llx\n",
-		(unsigned long long)pinfo->rsrc_reg.start,
-		(unsigned long long)pinfo->rsrc_reg.end);
-	dev_dbg(&odev->dev, " framebuffer: 0x%llx...0x%llx\n",
-		(unsigned long long)pinfo->rsrc_fb.start,
-		(unsigned long long)pinfo->rsrc_fb.end);
+	dev_dbg(&odev->dev, " registers  : %pR\n", &pinfo->rsrc_reg);
+	dev_dbg(&odev->dev, " framebuffer: %pR\n", &pinfo->rsrc_fb);
 
 	/* Do not try to request register space, they overlap with the
 	 * northbridge and that can fail. Only request framebuffer
-- 
1.7.3.1.g432b3.dirty

