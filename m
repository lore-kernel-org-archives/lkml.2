Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2E1MfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:35:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2E1MfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:35:04 -0400
Date: Mon, 28 May 2012 14:35:01 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: laface.tw@gmail.com, mmarek@suse.cz, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild core changes for v3.5-rc1
Message-ID: <20120528123501.GA13847@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the main part of kbuild this time is a series by Sam to clean up the
Makefile and move the vmlinux linking step to a separate script. There
are two conflicts unfortunately. Parts of arch/sparc/boot/Makefile were
removed in the sparc tree, so just do

git checkout HEAD -- arch/sparc/boot/Makefile

to resolve this. The other conflict is between commit 1dbdc6f
("kbuild/extable: Hook up sortextable into the build system.") from the
tip tree and commit 1f2bfbd ("kbuild: link of vmlinux moved to a
script") from the kbuild tree. The fix is to do the sortextable in the
link-vmlinux.sh script. Stephen did this in linux-next, see

http://lkml.indiana.edu/hypermail/linux/kernel/1205.0/02567.html

Or simply checkout scripts/link-vmlinux.sh from linux-next.

Michal

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to f7fc237e330deaaea4ba6726b603d4058d1e6b38:

  mips: Fix KBUILD_CPPFLAGS definition (2012-05-16 00:35:06 +0200)

----------------------------------------------------------------
Edward Shao (1):
      kbuild: Makefile: remove unnecessary check for m68knommu ARCH

Michal Marek (1):
      mips: Fix KBUILD_CPPFLAGS definition

Sam Ravnborg (5):
      kbuild: drop unused KBUILD_VMLINUX_OBJS from top-level Makefile
      kbuild: refactor final link of sparc32
      kbuild: link of vmlinux moved to a script
      kbuild: document KBUILD_LDS, KBUILD_VMLINUX_{INIT,MAIN} and LDFLAGS_vmlinux
      kbuild: fix ia64 link

 Documentation/kbuild/kbuild.txt |   19 ++++
 Makefile                        |  221 +++------------------------------------
 arch/mips/Makefile              |    4 +-
 arch/sparc/Makefile             |   11 --
 arch/sparc/boot/Makefile        |   14 ++-
 arch/um/Makefile                |   11 +-
 scripts/link-vmlinux.sh         |  211 +++++++++++++++++++++++++++++++++++++
 7 files changed, 258 insertions(+), 233 deletions(-)
 create mode 100644 scripts/link-vmlinux.sh
