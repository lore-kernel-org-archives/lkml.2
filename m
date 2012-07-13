Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2GMXMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 19:12:12 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:9536 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2GMXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 19:12:09 -0400
Message-ID: <1342221125.17464.8.camel@lorien2>
Subject: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: cl@linux.com, penberg@kernel.org, glommer@parallels.com, js1304@gmail.com
Cc: shuahkhan@gmail.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jul 2012 17:12:05 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The label oops is used in CONFIG_DEBUG_VM ifdef block and is defined
outside ifdef CONFIG_DEBUG_VM block. This results in the following
build warning when built with CONFIG_DEBUG_VM disabled. Fix to move 
label oops definition to inside a CONFIG_DEBUG_VM block.

mm/slab_common.c: In function ‘kmem_cache_create’:
mm/slab_common.c:101:1: warning: label ‘oops’ defined but not used
[-Wunused-label]

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 mm/slab_common.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 12637ce..aa3ca5b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -98,7 +98,9 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
 
 	s = __kmem_cache_create(name, size, align, flags, ctor);
 
+#ifdef CONFIG_DEBUG_VM
 oops:
+#endif
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-- 
1.7.9.5



