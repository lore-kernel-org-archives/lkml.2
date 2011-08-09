Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1HIJsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:48:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50597 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1HIJsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:48:11 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Chris Ball <cjb@laptop.org>
Cc: linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-mm@kvack.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH --mmotm v6 1/3] fault-inject: export fault injection functions
Date: Tue,  9 Aug 2011 11:47:46 +0200
Message-Id: <1312883268-4342-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312883268-4342-1-git-send-email-per.forlin@linaro.org>
References: <1312883268-4342-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.4.1

