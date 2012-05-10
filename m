Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281Ab2EJVWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:22:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956Ab2EJVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:22:05 -0400
Date: Thu, 10 May 2012 14:21:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        "Pavel V. Panteleev" <pp_84@mail.ru>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [GIT PULL] percpu fixes for 3.4-rc6
Message-ID: <20120510212158.GH24636@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains two patches.  One is kmemleak annotation
fix which isn't critical.  The other is kinda serious.  Depending on
NUMA topology, percpu allocator may end up assigning overlapping
regions for the static percpu areas for different CPUs.  While
critical, the bug has been there for a very long time and only few
configurations seem to be affected (NUMA configurations w/ no memory
nodes for example) - so, while it's critical, it isn't exactly urgent.

If there isn't gonna be another rcX, I think it would be better to
pull the fix as part of the next merge window and backport through
-stable.

So, depending on release schedule, please consider pulling from the
following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.4-fixes

Catalin Marinas (1):
      kmemleak: Fix the kmemleak tracking of the percpu areas with !SMP

Tejun Heo (1):
      percpu: pcpu_embed_first_chunk() should free unused parts after all allocs are complete

 mm/percpu.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

Thanks.

--
tejun
