Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1GTWCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:02:22 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46171 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1GTWCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:02:19 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3 1/3] fault-inject: make fault injection available for modules
Date: Thu, 21 Jul 2011 00:01:59 +0200
Message-Id: <1311199321-4618-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311199321-4618-1-git-send-email-per.forlin@linaro.org>
References: <1311199321-4618-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export symbols should_fail() and init_fault_attr_dentries() in order
to make modules use the fault injection functionality

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 lib/fault-inject.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 7e65af7..27783da 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -131,6 +131,7 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(should_fail);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
@@ -311,5 +312,6 @@ fail:
 	cleanup_fault_attr_dentries(attr);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(init_fault_attr_dentries);
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-- 
1.7.4.1

