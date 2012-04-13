Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2DMTRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:17:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:63211 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab2DMTRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:17:52 -0400
Date: Fri, 13 Apr 2012 15:17:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <dhowells@redhat.com>, <cmetcalf@tilera.com>, <tony.luck@intel.com>,
        <mattst88@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] system.h fixups for less common arch
Message-ID: <20120413191743.GA19415@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here is what is hopefully the last of the system.h related fixups.

The fixes for Alpha and ia64 are code relocations consistent with
what was done for the more mainstream architectures.  Note that the
diffstat lines removed vs lines added are not the same since I've
fixed some of the whitespace issues in the relocated code blocks.
However they are functionally the same.  Compile tested locally,
plus these two have been in linux-next for a while.

There is also a trivial one line system.h related fix for the Tilera
arch from Chris Metcalf to fix an implict include..

Thanks,
Paul.
---

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git systemh-fixes

for you to fetch changes up to ef1f0982540e5f79c8bbf3675bbc0a9734dba3fc:

  irq_work: fix compile failure on tile from missing include (2012-04-13 13:15:16 -0400)

----------------------------------------------------------------
Chris Metcalf (1):
      irq_work: fix compile failure on tile from missing include

Paul Gortmaker (2):
      alpha: fix build failures from system.h dismemberment
      ia64: populate the cmpxchg header with appropriate code

 arch/alpha/include/asm/atomic.h    |   68 +----------------
 arch/alpha/include/asm/cmpxchg.h   |   71 +++++++++++++++++
 arch/alpha/include/asm/xchg.h      |    4 +-
 arch/ia64/include/asm/cmpxchg.h    |  148 +++++++++++++++++++++++++++++++++++-
 arch/ia64/include/asm/intrinsics.h |  114 +---------------------------
 kernel/irq_work.c                  |    1 +
 6 files changed, 223 insertions(+), 183 deletions(-)
 create mode 100644 arch/alpha/include/asm/cmpxchg.h
