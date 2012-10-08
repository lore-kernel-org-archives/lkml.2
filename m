Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2JHUSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:18:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57711 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2JHUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:18:11 -0400
Date: Mon, 08 Oct 2012 16:18:06 -0400 (EDT)
Message-Id: <20121008.161806.2146082252793236167.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is an attempt to fix a bad interaction between syscall tracing
and force_successful_syscall() from Al Viro, but it needs to be redone
as it introduced regressions and thus had to be reverted for now.

Al is working on an updated version.

But what we do have here are some significant bzero/memset
improvements for Niagara-4.  An 8K page can be cleared in around 600
cycles, because we essentially have a store that behaves like
powerpc's dcbz that we can actually make real use of.

Please pull, thanks a lot.

The following changes since commit ecefbd94b834fa32559d854646d777c56749ef1c:

  Merge tag 'kvm-3.7-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2012-10-04 09:30:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 2863bc54ec03df7a6e2c48cff0477d7e2384efc9:

  Revert strace hiccups fix. (2012-10-05 20:39:04 -0700)

----------------------------------------------------------------
Al Viro (2):
      sparc64: Rearrange thread info to cheaply clear syscall noerror state.
      sparc64: Fix strace hiccups when force_successful_syscall() triggers.

David S. Miller (2):
      sparc64: Niagara-4 bzero/memset, plus use MRU stores in page copy.
      Revert strace hiccups fix.

 arch/sparc/include/asm/asi.h   |  19 +++++++++++++++++
 arch/sparc/kernel/head_64.S    |   2 +-
 arch/sparc/lib/Makefile        |   2 +-
 arch/sparc/lib/NG4clear_page.S |  29 ++++++++++++++++++++++++++
 arch/sparc/lib/NG4copy_page.S  |  16 +++++++--------
 arch/sparc/lib/NG4memset.S     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/sparc/lib/NG4patch.S      |  15 ++++++++++++--
 7 files changed, 176 insertions(+), 12 deletions(-)
 create mode 100644 arch/sparc/lib/NG4clear_page.S
 create mode 100644 arch/sparc/lib/NG4memset.S
