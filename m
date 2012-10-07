Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2JGPxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:53:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2JGPxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:53:17 -0400
Date: Sun, 7 Oct 2012 17:53:10 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdelvare@suse.de, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixes
Message-ID: <20121007155310.GA25356@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are two fixes I intended to send after v3.6-rc7, but failed to do
so. So please pull them for v3.7-rc1 and they will be picked up by
stable. The first one fixes gcc -x <language> syntax in various
build-time tests, which icecream and possible other gcc wrappers did not
understand (and yes, icecream is going to be fixed as well). The second
one fixes make tar-pkg so that unpacking the tarball does not replace
the /lib -> /usr/lib symlink on recent Fedora releases.

Thanks,
Michal

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

Jean Delvare (1):
      kbuild: Fix gcc -x syntax

Michal Marek (1):
      kbuild: Do not package /boot and /lib in make tar-pkg

 arch/mips/Makefile                         |    2 +-
 arch/mips/kernel/Makefile                  |    2 +-
 arch/x86/Makefile                          |    4 ++--
 scripts/Kbuild.include                     |   12 ++++++------
 scripts/Makefile.fwinst                    |    4 ++--
 scripts/gcc-version.sh                     |    6 +++---
 scripts/gcc-x86_32-has-stack-protector.sh  |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh  |    2 +-
 scripts/kconfig/check.sh                   |    2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 scripts/package/buildtar                   |    2 +-
 tools/perf/Makefile                        |    2 +-
 tools/power/cpupower/Makefile              |    2 +-
 13 files changed, 22 insertions(+), 22 deletions(-)
