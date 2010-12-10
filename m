Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0LJD3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:31 -0500
Received: from mail.perches.com ([173.55.12.10]:2465 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab0LJD3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] hid: Use vzalloc for vmalloc/memset(,0...)
Date: Thu,  9 Dec 2010 19:29:04 -0800
Message-Id: <049252dc8476fd9bad62ab7788b534ee5d1e6b18.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
In-Reply-To: <cover.1291951482.git.joe@perches.com>
References: <cover.1291951482.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2f410ae..ff43b4a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -654,13 +654,12 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 		return -ENOMEM;
 	device->rsize = size;
 
-	parser = vmalloc(sizeof(struct hid_parser));
+	parser = vzalloc(sizeof(struct hid_parser));
 	if (!parser) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	memset(parser, 0, sizeof(struct hid_parser));
 	parser->device = device;
 
 	end = start + size;
-- 
1.7.3.3.464.gf80b6

