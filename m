Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1EXMDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:03:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1EXMDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:03:40 -0400
Date: Tue, 24 May 2011 14:03:37 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem.Bityutskiy@nokia.com, cernekee@gmail.com, davej@redhat.com,
        jamey@minilop.net, marcin.nowakowski.000@gmail.com, mmarek@suse.cz,
        pefoley2@verizon.net, sam@ravnborg.org, wangxiaochen0@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild core updates
Message-ID: <20110524120337.GA29839@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild bits for 2.6.40 or whatever it is going to be
called. Highlights:

* make W=[123] to enable warnings that are normally disabled due to low
  signal/noise ratio (Borislav Petkov and Sam Ravnborg).
* Support for using headers from include/asm-generic without adding
  one-line wrappers (Sam Ravnborg).
* Ability to build identical kernels from identical sources. This branch
  contains just the kbuild part, the rest, eliminating all the __TIME__
  and __DATE__ uses will come though other trees and my 'trivial' branch
  that I'll send you later (me).
* KALLSYMS_EXTRA_PASS is now a make variable and not a config option
  (Artem Bityutskiy)

The remaining branches will come later.

Michal

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Artem Bityutskiy (2):
      Kconfig: improve KALLSYMS_ALL documentation
      kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to Makefile

Dave Jones (1):
      kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0

Jamey Sharp (1):
      scripts/gen_initramfs_list.sh: Convert to a /bin/sh script

Kevin Cernekee (1):
      kbuild: Fix GNU make v3.80 compatibility

Marcin Nowakowski (1):
      Fix handling of backlash character in LINUX_COMPILE_BY name

Michal Marek (10):
      kbuild: Call gzip with -n
      kbuild: Use the deterministic mode of ar
      kbuild: Drop unused LINUX_COMPILE_TIME and LINUX_COMPILE_DOMAIN macros
      kbuild: Allow to override LINUX_COMPILE_BY and LINUX_COMPILE_HOST macros
      initramfs: Use KBUILD_BUILD_TIMESTAMP for generated entries
      kbuild: Fix build with binutils <= 2.19
      kbuild: Allow to combine multiple W= levels
      kbuild: Fix Makefile.asm-generic for um
      kbuild: Fix passing -Wno-* options to gcc 4.4+
      kbuild: make KBUILD_NOCMDDEP=1 handle empty built-in.o

Peter Foley (1):
      kbuild: move scripts/basic/docproc.c to scripts/docproc.c

Sam Ravnborg (2):
      kbuild: implement several W= levels
      kbuild: asm-generic support

Xiaochen Wang (1):
      scripts/kallsyms.c: fix potential segfault

 .gitignore                         |    1 +
 Documentation/DocBook/Makefile     |    2 +-
 Documentation/kbuild/kbuild.txt    |   13 ++++++
 Documentation/kbuild/makefiles.txt |   53 +++++++++++++++++++++++++
 Makefile                           |   50 ++++++++++++++++++------
 init/Kconfig                       |   30 ++++++---------
 scripts/.gitignore                 |    1 +
 scripts/Kbuild.include             |   12 ++++++
 scripts/Makefile                   |    7 ++-
 scripts/Makefile.asm-generic       |   23 +++++++++++
 scripts/Makefile.build             |   74 ++++++++++++++++++++++--------------
 scripts/Makefile.headersinst       |   10 ++++-
 scripts/Makefile.lib               |    2 +-
 scripts/basic/.gitignore           |    2 -
 scripts/basic/Makefile             |    3 +-
 scripts/{basic => }/docproc.c      |    0
 scripts/gen_initramfs_list.sh      |   27 ++++++++-----
 scripts/kallsyms.c                 |    2 +
 scripts/mkcompile_h                |   30 +++++++--------
 usr/gen_init_cpio.c                |   53 +++++++++++++++++++------
 20 files changed, 287 insertions(+), 108 deletions(-)
 create mode 100644 scripts/Makefile.asm-generic
 rename scripts/{basic => }/docproc.c (100%)
