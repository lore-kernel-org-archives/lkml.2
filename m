Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1GVIKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:10:43 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56597 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1GVIKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:10:41 -0400
Date: Fri, 22 Jul 2011 11:08:44 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB changes for v3.1-rc0
Message-ID: <alpine.DEB.2.00.1107221108190.2996@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's batch of slab/slub/slob changes accumulated over the past few months.
The biggest changes are alignment unification from Christoph Lameter and SLUB
debugging improvements from Ben Greear. Also notable is SLAB 'struct
kmem_cache' shrinkage from Eric Dumazet that helps large SMP systems.

Please note that the SLUB lockless slowpath patches will be sent in a separate
pull request.

                         Pekka

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:
   Linus Torvalds (1):
         Linux 3.0

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab-for-linus

Ben Greear (2):
       slub: Enable backtrace for create/delete points
       slub: Add method to verify memory is not freed

Christoph Lameter (2):
       slab, slub, slob: Unify alignment definition
       slab allocators: Provide generic description of alignment defines

Eric Dumazet (1):
       slab: shrink sizeof(struct kmem_cache)

Hugh Dickins (1):
       slab: fix DEBUG_SLAB build

Marcin Slusarz (1):
       slub: reduce overhead of slub_debug

Pekka Enberg (1):
       SLUB: Fix missing <linux/stacktrace.h> include

Steven Rostedt (1):
       slob/lockdep: Fix gfp flags passed to lockdep

Tetsuo Handa (1):
       slab: fix DEBUG_SLAB warning

  include/linux/slab.h     |   20 +++++++++
  include/linux/slab_def.h |   52 ++++++-----------------
  include/linux/slob_def.h |   10 ----
  include/linux/slub_def.h |   23 ++++++----
  mm/slab.c                |   17 ++++----
  mm/slob.c                |    6 +++
  mm/slub.c                |  105 +++++++++++++++++++++++++++++++++++++++++++++-
  7 files changed, 164 insertions(+), 69 deletions(-)
