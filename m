Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2LCUd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:33:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2LCUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:33:58 -0500
Date: Mon, 03 Dec 2012 15:33:56 -0500 (EST)
Message-Id: <20121203.153356.1912477920174640312.davem@davemloft.net>
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


Two small fixes for Sparc, nobody uses sparc, so these are
low risk :-)

1) Piggyback is too picky about the symbol types that _start
   and _end have in the final kernel image, and it thus breaks
   with newer binutils.  Future proof by getting rid of the
   symbol type checks.

2) exit_group() should kill register windows on sparc64 the same
   way we do for plain exit().  Thanks to Al Viro for spotting
   this.

Please pull, thanks a lot!

The following changes since commit 7e5530af11be68f3109672aed59243f82e1272f0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-12-02 16:39:00 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 0032c857454581510de1ca12615de5e38e543c92:

  sparc: Fix piggyback with newer binutils. (2012-12-03 11:24:25 -0800)

----------------------------------------------------------------
David S. Miller (2):
      sparc64: exit_group should kill register windows just like plain exit.
      sparc: Fix piggyback with newer binutils.

 arch/sparc/boot/piggyback.c    | 12 ++++++------
 arch/sparc/kernel/sys32.S      |  2 +-
 arch/sparc/kernel/syscalls.S   | 14 ++++++++++++--
 arch/sparc/kernel/systbls_64.S |  2 +-
 4 files changed, 20 insertions(+), 10 deletions(-)

