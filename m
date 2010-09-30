Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0I3Dub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0I3Dua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t+icXW0ZQG/LlCqkN4xuOuTj+DcS4jR38gtFdivxBvQdXPKZR1LSuHfPLSq7qgEMbd
         /z6Wdixhs93DMLLoaCYZ0LJAPkS3YAQgHby2Kc7eRSI+QWFYMD7Mia8R9JMvvKH0ZZb8
         4CQCcBOTAOM8y4z3yq6149b0WJ7klDXFsSE7M=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] mm: fix sparse warnings
Date: Thu, 30 Sep 2010 12:50:09 +0900
Message-Id: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to remove various warnings from sparse. Each patch
contains the warnings it removes in changelog. I compile-tested with
all{yes,no}config on x86. Any comments would be welcomed.

Thanks.

---

Namhyung Kim (12):
  mm: remove temporary variable on generic_file_direct_write()
  mm: add casts to/from gfp_t in gfp_to_alloc_flags()
  mm: wrap get_locked_pte() using __cond_lock()
  mm: add lock release annotation on do_wp_page()
  mm: wrap follow_pte() using __cond_lock()
  rmap: annotate lock context change on page_[un]lock_anon_vma()
  rmap: wrap page_check_address() using __cond_lock()
  rmap: make anon_vma_[chain_]free() static
  vmalloc: rename temporary variable in __insert_vmap_area()
  vmalloc: annotate lock context change on s_start/stop()
  mm: declare some external symbols
  vmstat: include compaction.h when CONFIG_COMPACTION

 include/linux/backing-dev.h |    1 +
 include/linux/mm.h          |   10 +++++++++-
 include/linux/rmap.h        |   29 ++++++++++++++++++++++++++---
 include/linux/writeback.h   |    2 ++
 mm/filemap.c                |    8 ++++----
 mm/memory.c                 |   16 ++++++++++++++--
 mm/page_alloc.c             |    4 ++--
 mm/rmap.c                   |   10 ++++++----
 mm/vmalloc.c                |   10 ++++++----
 mm/vmstat.c                 |    2 ++
 10 files changed, 72 insertions(+), 20 deletions(-)

--
1.7.2.2

