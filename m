Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2JVOFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:05:45 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25004 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab2JVOFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:05:43 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] move kmem_cache_free to common code.
Date: Mon, 22 Oct 2012 18:05:35 +0400
Message-Id: <1350914737-4097-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: David Rientjes <rientjes@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is some initial work to make kmem_cache_free at least callable from
a common entry point. This will be useful in future work, like kmemcg-slab,
that needs to further change those callers in both slab and slub.

Patch1 is not really a dependency for 2, but it will be for the work I am doing
in kmemcg-slab, so I'm sending both patches for your appreciation.

Glauber Costa (2):
  slab: commonize slab_cache field in struct page
  slab: move kmem_cache_free to common code

 include/linux/mm_types.h |  7 ++-----
 mm/slab.c                | 13 +------------
 mm/slab.h                |  1 +
 mm/slab_common.c         | 17 +++++++++++++++++
 mm/slob.c                | 11 ++++-------
 mm/slub.c                | 29 +++++++++++++----------------
 6 files changed, 38 insertions(+), 40 deletions(-)

-- 
1.7.11.7

