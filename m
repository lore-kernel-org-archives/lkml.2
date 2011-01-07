Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1AGOR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:17:57 -0500
Received: from rs22.lvs.iif.hu ([193.225.14.172]:54076 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1AGOR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:17:56 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] Replace the dangerous to_root_device macro with an inline function
Date: Fri,  7 Jan 2011 15:17:47 +0100
Message-Id: <287c00f65aca8ea09ec868b0a006600f8eeb5c1c.1294409671.git.wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
References: <20110106205259.GA28326@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original macro worked only when applied to variables named 'dev'.
While this could have been fixed by simply renaming the macro argument,
a more type-safe replacement by an inline function is preferred.

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

