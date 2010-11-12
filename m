Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab0KLViZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:38:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1060 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948Ab0KLViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:18 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] drivers/uwb: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:38:02 -0800
Message-Id: <86aa2d9b8fbd8c775f9c6f41d336b689ba5f2ff6.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/uwb/umc-dev.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/uwb/umc-dev.c b/drivers/uwb/umc-dev.c
index 43ea998..ccd2184 100644
--- a/drivers/uwb/umc-dev.c
+++ b/drivers/uwb/umc-dev.c
@@ -54,11 +54,8 @@ int umc_device_register(struct umc_dev *umc)
 
 	err = request_resource(umc->resource.parent, &umc->resource);
 	if (err < 0) {
-		dev_err(&umc->dev, "can't allocate resource range "
-			"%016Lx to %016Lx: %d\n",
-			(unsigned long long)umc->resource.start,
-			(unsigned long long)umc->resource.end,
-			err);
+		dev_err(&umc->dev, "can't allocate resource range %pR: %d\n",
+			&umc->resource, err);
 		goto error_request_resource;
 	}
 
-- 
1.7.3.1.g432b3.dirty

