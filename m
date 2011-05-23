Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1EWQ40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:56:26 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:55278 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab1EWQ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:56:25 -0400
Date: Mon, 23 May 2011 19:56:23 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com
Subject: [GIT PULL] SLAB updates for v2.6.40-rc0
Message-ID: <alpine.DEB.2.00.1105231955400.8359@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's bunch of fixes and cleanups to the SLUB allocator. Bulk of them are
related to the lockless fastpaths but there's also some preparational work on
lockless slowpaths that will hopefully appear in v2.6.41.

                         Pekka

The following changes since commit caebc160ce3f76761cc62ad96ef6d6f30f54e3dd:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../ryusuke/nilfs2

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Christoph Lameter (10):
       slub: Use NUMA_NO_NODE in get_partial
       slub: get_map() function to establish map of free objects in a slab
       slub: Eliminate repeated use of c->page through a new page variable
       slub: Move node determination out of hotpath
       slub: Move debug handlign in __slab_free
       slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery
       slub: Avoid warning for !CONFIG_SLUB_DEBUG
       slub: Make CONFIG_DEBUG_PAGE_ALLOC work with new fastpath
       slub: Remove node check in slab_free
       slub: Deal with hyperthetical case of PAGE_SIZE > 2M

David Rientjes (1):
       slub: avoid label inside conditional

Li Zefan (1):
       slub: Fix a typo in config name

Pekka Enberg (1):
       Merge branch 'slab/next' into for-linus

  include/linux/slub_def.h |    8 +-
  mm/slub.c                |  165 ++++++++++++++++++----------------------------
  2 files changed, 69 insertions(+), 104 deletions(-)
