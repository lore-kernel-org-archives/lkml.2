Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2IHUtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:49:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54649 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2IHUts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:49:48 -0400
MIME-Version: 1.0
Date: Sat, 8 Sep 2012 17:49:47 -0300
Message-ID: <CALF0-+VMtUPuLHg3CwDxFm-TjbN1=YavGO79Oo3GuymOLvikeA@mail.gmail.com>
Subject: [PATCH v2 0/10] mm: SLxB cleaning and trace accuracy improvement
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: JoonSoo Kim <js1304@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Glauber Costa <glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is the second spin of my patchset to clean SLxB and improve kmem
trace events accuracy.

For this v2, the most relevant stuff is:

I've dropped two patches that were not very well received:
Namely this two are now gone:
  mm, slob: Use only 'ret' variable for both slob object and returned pointer
  mm, slob: Trace allocation failures consistently
I believe consistency is important but perhaps this is just me being paranoid.

There's a lot of dumb movement and renaming. This might seem stupid
(and maybe it is) but it's necessary to create some common code between SLAB
and SLUB, and then factor it out.

Also, there's a patch to add a new option to disable gcc auto-inlining.
I know we hate to add new options, but this is necessary to get
accurate call site
traces. Plus, the option is in "Kernel Hacking", so it's for kernel
developers only.

This work is part of CELF Workgroup Project:
"Kernel_dynamic_memory_allocation_tracking_and_reduction" [1]

Feedback, comments, suggestions are very welcome.

Ezequiel Garcia (10):
 mm: Factor SLAB and SLUB common code
 mm, slub: Rename slab_alloc() -> slab_alloc_node() to match SLAB
 mm, slab: Rename __cache_alloc() -> slab_alloc()
 mm, slab: Match SLAB and SLUB kmem_cache_alloc_xxx_trace() prototype
 mm, slab: Replace 'caller' type, void* -> unsigned long
 mm, util: Use dup_user to duplicate user memory
 mm, slob: Add support for kmalloc_track_caller()
 mm, slab: Remove silly function slab_buffer_size()
 mm, slob: Use NUMA_NO_NODE instead of -1
 Makefile: Add option CONFIG_DISABLE_GCC_AUTOMATIC_INLINING

 Makefile                 |    4 ++
 include/linux/slab.h     |    6 ++-
 include/linux/slab_def.h |   14 ++---
 include/linux/slob_def.h |    6 ++-
 include/linux/slub_def.h |    2 +
 lib/Kconfig.debug        |   11 ++++
 mm/slab.c                |  122 +++++++++-------------------------------------
 mm/slab_common.c         |   57 +++++++++++++++++++++
 mm/slob.c                |   33 ++++++++++--
 mm/slub.c                |   55 +++------------------
 mm/util.c                |   11 +++-
 11 files changed, 154 insertions(+), 167 deletions(-)

Thanks!
Ezequiel.
