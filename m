Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LUUoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:44:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2LUUoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:44:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        lars@metafoo.de, will.deacon@arm.com, james.hogan@imgtec.com
Subject: [GIT PULL] asm-generic cleanups
Date: Fri, 21 Dec 2012 20:43:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212212043.57929.arnd@arndb.de>
X-Provags-ID: V02:K0:VEDY8IJIWKH2CUdc+yQhXnH51iG8M45bG8go5piqX3X
 KVSJ0Ue0WBzanGig11ap4y3ymiuPU334OGsulBB330nO7xnLRK
 dH6qWtOruS93g92IxQl17FDKtuwoIH34oD4stvcHlN7qytynDN
 drl1gfJlxHRBDGPM/Vq1a02SvOZF5MfHwUaDXUK6RyqzL8Xeeq
 wB+3BlCHn1XVnDovUqiUmFwwXCJaIq4XGF3RYsDJ9kbqbD9fkO
 23HAF9aCuixOTqfqmrSsON/PUz9TjBbb8MO9CrbscmVpF/3NKK
 3XR+hlfYh4IR+RNYtnhtkg+f1r232jt+DfGTnDNCt4C4rNheda
 ocKnbR/qKYhjhcOA0sPw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git tags/asm-generic

for you to fetch changes up to fb9de7ebc3a2eb7ddb83c92e288447a0c313bced:

  xtensa: Use generic asm/mmu.h for nommu (2012-12-09 23:14:19 +0100)

----------------------------------------------------------------
warning: refname 'asm-generic' is ambiguous.
These are a few cleanups for asm-generic:

* a set of patches from Lars-Peter Clausen to generalize asm/mmu.h
  and use it in the architectures that don't need any special handling.
* A patch from Will Deacon to remove the {read,write}s{b,w,l} as
  discussed during the arm64 review
* A patch from James Hogan that helps with the meta architecture
  series.

----------------------------------------------------------------
James Hogan (1):
      asm-generic/io.h: remove asm/cacheflush.h include

Lars-Peter Clausen (5):
      asm-generic/mmu.h: Remove unused vmlist field from mm_context_t
      asm-generic/mmu.h: Add support for FDPIC
      c6x: Use generic asm/mmu.h
      h8300: Use generic asm/mmu.h
      xtensa: Use generic asm/mmu.h for nommu

Will Deacon (1):
      asm-generic: io: remove {read,write} string functions

 arch/c6x/include/asm/Kbuild     |  1 +
 arch/c6x/include/asm/mmu.h      | 22 ----------------------
 arch/h8300/include/asm/Kbuild   |  1 +
 arch/h8300/include/asm/mmu.h    | 10 ----------
 arch/openrisc/include/asm/io.h  |  1 +
 arch/xtensa/include/asm/mmu.h   |  2 +-
 arch/xtensa/include/asm/nommu.h |  3 ---
 include/asm-generic/io.h        | 31 -------------------------------
 include/asm-generic/mmu.h       |  6 +++++-
 9 files changed, 9 insertions(+), 68 deletions(-)
 delete mode 100644 arch/c6x/include/asm/mmu.h
 delete mode 100644 arch/h8300/include/asm/mmu.h
 delete mode 100644 arch/xtensa/include/asm/nommu.h
