Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1HSMzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:55:42 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:48223 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab1HSMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:55:35 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, <linux-doc@vger.kernel.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v9 1/3] fault-inject: export fault injection functions
Date: Fri, 19 Aug 2011 14:52:36 +0200
Message-ID: <1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

export symbols should_fail() and fault_create_debugfs_attr() in order
to let modules utilize the fault injection

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/fault-inject.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index f193b77..328d433 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -130,6 +130,7 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(should_fail);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
@@ -243,5 +244,6 @@ fail:
 
 	return ERR_PTR(-ENOMEM);
 }
+EXPORT_SYMBOL_GPL(fault_create_debugfs_attr);
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-- 
1.6.3.3

