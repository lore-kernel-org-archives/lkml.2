Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab0KEDRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:17:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4035 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0KEDIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:41 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/49] drivers/hid: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:35 -0700
Message-Id: <bf51887d851a022bb54de2c363630266b0222f5c.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 515345b..3fd8e5a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -652,13 +652,12 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
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
1.7.3.1.g432b3.dirty

