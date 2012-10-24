Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab2JXN70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:59:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25143 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934675Ab2JXN7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:59:25 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] common entry point for kmem_cache_free
Date: Wed, 24 Oct 2012 17:59:16 +0400
Message-Id: <1351087158-8524-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
CC: Joonsoo Kim <js1304@gmail.com>
CC: David Rientjes <rientjes@google.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this patchset is to provide a single entry point for
kmem_cache_free. Other functions, such as the allocation itself, and kmalloc
could easily follow.

The main problem here, is that if we keep the allocator-specific functions
in their .c file, we lose the ability to inline their fast paths. Being this
such a critical path, we would like to keep doing so.

During the last discussion around this (https://lkml.org/lkml/2012/10/22/639),
JoonSoo Kim suggested that we could achieve this by just including the
allocator-specific .c files in slab_common.c, a suggestion I considered but
quickly disregarding fearing a quite ugly end result.

Turns out it doesn't look so bad. So please let me know what you think.

Thanks

Glauber Costa (2):
  kmem_cache: include allocators code directly into slab_common
  slab: move kmem_cache_free to common code

 mm/Makefile      |  3 ---
 mm/slab.c        | 23 ++---------------------
 mm/slab_common.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/slob.c        | 11 ++++-------
 mm/slub.c        |  5 +----
 5 files changed, 57 insertions(+), 35 deletions(-)

-- 
1.7.11.7

