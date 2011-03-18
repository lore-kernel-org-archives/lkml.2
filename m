Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1CRMyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:54:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37288 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1CRMyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RryBzxwEmQJgczR+Fc3bXVzYVGVlqYSiyd6y0lE/+jQhxF0CRpIbAKQcMQep8M6sDv
         LdR9BK4/unFCXyI/kBflDYudZgc0KaZzHuK6a+2s8JQjfCh6lErwN28tjIPgK9X8j2Eu
         F/f1viuta5kjPyGUJ2pbo67Y4pgZR5iKK3Fyw=
From: Namhyung Kim <namhyung@gmail.com>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/3] memcg: mark init_section_page_cgroup() properly
Date: Fri, 18 Mar 2011 21:54:13 +0900
Message-Id: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ca371c0d7e23 ("memcg: fix page_cgroup fatal error
in FLATMEM") removes call to alloc_bootmem() in the function
so that it can be marked as __meminit to reduce memory usage
when MEMORY_HOTPLUG=n.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada7cde1..2d1a0fa01d7b 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -105,8 +105,7 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
 	return section->page_cgroup + pfn;
 }
 
-/* __alloc_bootmem...() is protected by !slab_available() */
-static int __init_refok init_section_page_cgroup(unsigned long pfn)
+static int __meminit init_section_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *section = __pfn_to_section(pfn);
 	struct page_cgroup *base, *pc;
-- 
1.7.4

