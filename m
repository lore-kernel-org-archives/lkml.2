Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab2EHQwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:52:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62442 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2EHQv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:51:59 -0400
Date: Tue, 8 May 2012 09:51:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: [GIT PULL] percpu fixes for 3.4-rc5
Message-ID: <20120508165154.GA10687@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to recieve two fixes for percpu
allocator.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.4-fixes

One adds missing KERN_CONT on split printk()s and the other makes
percpu allocator avoid using PMD_SIZE as atom_size on x86_32.  Using
PMD_SIZE led to vmalloc area exhaustion on certain configurations
(x86_32 android) and the only cost of using PAGE_SIZE instead is
static percpu area not being aligned to large page mapping.

Tejun Heo (2):
      percpu: use KERN_CONT in pcpu_dump_alloc_info()
      percpu, x86: don't use PMD_SIZE as embedded atom_size on 32bit

 arch/x86/kernel/setup_percpu.c |   14 +++++++++++++-
 mm/percpu.c                    |   10 +++++-----
 2 files changed, 18 insertions(+), 6 deletions(-)

Thanks.

--
tejun
