Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0CWRHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:07:20 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38297 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab0CWRHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:07:18 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Replace the dangerous to_root_device macro with an inline function
Date: Tue, 23 Mar 2010 18:07:17 +0100
Message-ID: <87mxxz0xx6.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
index b56a0ba..5f231df 100644
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
1.5.6.5

