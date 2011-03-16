Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1CPVNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:13:06 -0400
Received: from kroah.org ([198.145.64.141]:42613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab1CPVLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/50] driver core: Replace the dangerous to_root_device macro with an inline function
Date: Wed, 16 Mar 2011 14:10:56 -0700
Message-Id: <1300309888-5028-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ferenc Wagner <wferi@niif.hu>

The original macro worked only when applied to variables named 'dev'.
While this could have been fixed by simply renaming the macro argument,
a more type-safe replacement by an inline function is preferred.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9cd3b5c..81b78ed 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1320,7 +1320,10 @@ struct root_device
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
1.7.4.1

