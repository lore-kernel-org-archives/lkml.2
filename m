Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0FBFc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:32:27 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45212 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0FBFcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=de62mku20STYHnFnRqBl6Izjt782P39fOz/mCBBCEJqw1IgC9cBh92uJxYyYmC1O+M
         Bm3CLnsmplknAEVCTfSg9jDMJNsiSYYG3ZsoMTDU2Uetjqf4uVQFjyXvsVqXSG7LUVbT
         K5DaDi7FVwKC+Dy+J5TLVwXdT9CZf/XjRIdys=
Subject: [PATCH] module: module_unload_init() cleanup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 07:32:20 +0200
Message-ID: <1275456740.2638.143.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to clear mod->refptr in module_unload_init(), since
alloc_percpu() already clears allocated chunks.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 kernel/module.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0129769..15acb25 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -524,10 +524,6 @@ static void module_unload_init(struct module *mod)
 	int cpu;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for_each_possible_cpu(cpu) {
-		per_cpu_ptr(mod->refptr, cpu)->incs = 0;
-		per_cpu_ptr(mod->refptr, cpu)->decs = 0;
-	}
 
 	/* Hold reference count during initialization. */
 	__this_cpu_write(mod->refptr->incs, 1);


