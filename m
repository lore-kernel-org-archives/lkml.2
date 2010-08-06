Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab0HFS0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:26:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53989 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761758Ab0HFS0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pLPzi0WNj7fUBWgf0KbsfxZp7R8MCKB2HrF8aHt8Kck2zhlGcGN13xpQG+ylKUDgjq
         ngCqbC++FZLAzYINQ6vW4MCgfqBm/vf65VsxTMus6LmnKp8+7xjDmafcT9Kb8lu4mjlc
         oaDyrbPmtWfg5GGtBncMOppUxpdx0qudOHAcg=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] percpu: fix dynamic percpu allocators on UP
Date: Sat,  7 Aug 2010 03:26:24 +0900
Message-Id: <1281119187-12640-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle __percpu address space correctly in dynamic allocators of UP

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/percpu_up.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/percpu_up.c b/mm/percpu_up.c
index c4351c7..d599db4 100644
--- a/mm/percpu_up.c
+++ b/mm/percpu_up.c
@@ -14,13 +14,13 @@ void __percpu *__alloc_percpu(size_t size, size_t align)
 	 * percpu sections on SMP for which this path isn't used.
 	 */
 	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
+	return (void __percpu __force *) kzalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(__alloc_percpu);
 
 void free_percpu(void __percpu *p)
 {
-	kfree(p);
+	kfree(this_cpu_ptr(p));
 }
 EXPORT_SYMBOL_GPL(free_percpu);
 
-- 
1.7.0.4

