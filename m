Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2LLSW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:22:26 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33650 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:22:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 18/26] drivers: base: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:07 -0800
Message-Id: <6ea0098c5d3a28dbe9c6bcb97c7de1f7b0796bee.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/base/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..95159e1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -97,8 +97,8 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
 	if (dev_attr->show)
 		ret = dev_attr->show(dev, dev_attr, buf);
 	if (ret >= (ssize_t)PAGE_SIZE) {
-		print_symbol("dev_attr_show: %s returned bad count\n",
-				(unsigned long)dev_attr->show);
+		printk("dev_attr_show: %pSR returned bad count\n",
+		       dev_attr->show);
 	}
 	return ret;
 }
-- 
1.7.8.112.g3fd21

