Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1EaAdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:33:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1EaAdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=OhA+ukl+ch4SaWWdxh1yDiY6FG+HumoizGVx87Q24Yw9y6h3tT7HBGu0C82yw/LfxF
         KxMRx2PNpeTzvxZtnkoA==
Date: Mon, 30 May 2011 17:33:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Wilson <chris@chris-wilson.co.uk>, Keith Packard <keithp@keithp.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/14] mm: tmpfs and trunc changes, affecting drm
Message-ID: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patchset for mmotm, based on 30-rc1.  Nothing exciting,
mostly cleanup, preparation for what will probably be two more
patchsets coming over the next few weeks, first simplifying tmpfs
by getting rid of its ->readpage (give it a splice instead), then
getting rid of its peculiar swap index (use radix_tree instead).

The ordering here is somewhat illogical, arranged in the hope that
at least the first four can get into 30-rc, which would simplify
the dependencies between linux-next and mmotm.

The first is just an independent fix (I think) noticed on the way.
2,3,4 affect the interface between tmpfs and drm very slightly.
Once they're in 30-rc, drm maintainers could take 5,6,7,8 out of
mmotm and into linux-next (or even 30-rc).

 1/14 mm: invalidate_mapping_pages flush cleancache
 2/14 mm: move vmtruncate_range to truncate.c
 3/14 tmpfs: take control of its truncate_range
 4/14 tmpfs: add shmem_read_mapping_page_gfp
 5/14 drm/ttm: use shmem_read_mapping_page
 6/14 drm/i915: use shmem_read_mapping_page
 7/14 drm/i915: adjust to new truncate_range
 8/14 drm/i915: more struct_mutex locking
 9/14 mm: cleanup descriptions of filler arg
10/14 mm: truncate functions are in truncate.c
11/14 mm: tidy vmtruncate_range and related functions
12/14 mm: consistent truncate and invalidate loops
13/14 mm: pincer in truncate_inode_pages_range
14/14 tmpfs: no need to use i_lock

 drivers/gpu/drm/i915/i915_dma.c      |    3 
 drivers/gpu/drm/i915/i915_gem.c      |   36 ++---
 drivers/gpu/drm/i915/intel_overlay.c |    5 
 drivers/gpu/drm/ttm/ttm_tt.c         |    4 
 include/linux/mm.h                   |    3 
 include/linux/pagemap.h              |   22 ++-
 mm/filemap.c                         |   14 +-
 mm/memory.c                          |   24 ---
 mm/shmem.c                           |   79 +++++++-----
 mm/truncate.c                        |  161 +++++++++++++------------
 10 files changed, 185 insertions(+), 166 deletions(-)

Hugh
