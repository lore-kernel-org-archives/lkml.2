Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1INIrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:47:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32799 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1INIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:47:16 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 1/3] fault-inject: export setup_fault_attr()
Date: Wed, 14 Sep 2011 10:46:55 +0200
Message-Id: <1315990017-16912-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
References: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_core module needs to use setup_fault_attr() in order
to set fault injection attributes during module load time.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 lib/fault-inject.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 328d433..4f75540 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -14,7 +14,7 @@
  * setup_fault_attr() is a helper function for various __setup handlers, so it
  * returns 0 on error, because that is what __setup handlers do.
  */
-int __init setup_fault_attr(struct fault_attr *attr, char *str)
+int setup_fault_attr(struct fault_attr *attr, char *str)
 {
 	unsigned long probability;
 	unsigned long interval;
@@ -36,6 +36,7 @@ int __init setup_fault_attr(struct fault_attr *attr, char *str)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-- 
1.7.4.1

