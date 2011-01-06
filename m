Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1AFPsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:48:09 -0500
Received: from rs22.lvs.iif.hu ([193.225.14.172]:51321 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1AFPsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:48:03 -0500
X-Greylist: delayed 1415 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 10:48:03 EST
From: Ferenc Wagner <wferi@niif.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 2/2] Replace the dangerous to_root_device macro with an inline function
Date: Thu,  6 Jan 2011 16:24:24 +0100
Message-Id: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original macro worked only when applied to variables named 'dev'.
While this could have been fixed by simply renaming the macro argument,
a more type-safe replacement is preferred.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/base/core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..742a78a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1283,7 +1283,10 @@ struct root_device
 	struct module *owner;
 };
 
-#define to_root_device(dev) container_of(dev, struct root_device, dev)
+inline struct root_device *to_root_device(struct device *d)
+{
+	return container_of(d, struct root_device, dev);
+}
 
 static void root_device_release(struct device *dev)
 {
-- 
1.6.5

