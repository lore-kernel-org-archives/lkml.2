Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab0EVIVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:21:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48364 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0EVIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:21:39 -0400
Date: Sat, 22 May 2010 11:21:36 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for 2.6.35-rc0
Message-ID: <alpine.DEB.2.00.1005221119020.4737@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It's been a rather quiet cycle this time for slab. The most interesting 
bits here are SLAB memory hotplug support from David Rientjes and slab 
minimum alignment cleanups from David Woodhouse. There are also some slab 
debugging code fixes from Shiyong Li and Eric Dumazet.

                         Pekka

The following changes since commit f4b87dee923342505e1ddba8d34ce9de33e75050:
   Randy Dunlap (1):
         fbmem: avoid printk format warning with 32-bit resources

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab-for-linus

David Rientjes (1):
       slab: add memory hotplug support

David Woodhouse (4):
       mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN to <linux/slab_def.h>
       mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN to <linux/slob_def.h>
       mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN to <linux/slub_def.h>
       crypto: Use ARCH_KMALLOC_MINALIGN for CRYPTO_MINALIGN now that it's exposed

Eric Dumazet (1):
       slub: Potential stack overflow

Joe Perches (1):
       slab: Fix continuation lines

Minchan Kim (1):
       slub: Use alloc_pages_exact_node() for page allocation

Pekka Enberg (1):
       Merge branches 'slab/align', 'slab/cleanups', 'slab/fixes', 'slab/memhotadd' and 'slub/fixes' into slab-for-linus

Shiyong Li (1):
       slab: Fix missing DEBUG_SLAB last user

Xiaotian Feng (1):
       slub: __kmalloc_node_track_caller should trace kmalloc_large_node case

  include/linux/crypto.h   |    6 --
  include/linux/slab_def.h |   24 ++++++
  include/linux/slob_def.h |    8 ++
  include/linux/slub_def.h |    8 ++
  mm/slab.c                |  198 +++++++++++++++++++++++++++++++---------------
  mm/slob.c                |    8 --
  mm/slub.c                |   46 ++++++-----
  7 files changed, 200 insertions(+), 98 deletions(-)
