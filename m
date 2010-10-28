Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0J1WUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:20:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab0J1WT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:19:59 -0400
Date: Fri, 29 Oct 2010 00:19:56 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: alexander.stein@informatik.tu-chemnitz.de, andrea.gelmini@gelma.net,
        bebarino@gmail.com, gitster@pobox.com, justinmattock@gmail.com,
        kyle@redhat.com, lacombar@gmail.com, mmarek@suse.cz, naota@elisp.net,
        nir.tzachar@gmail.com, will.newton@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for 2.6.37-rc1
Message-ID: <20101028221956.GA30585@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the kconfig stuff for 2.6.37-rc1:
* kconfig portability fixes and generalization
* xconfig ported to Qt4
* nconfig search redesigned
* kconfig warnings enabled again, these were disabled late in the 2.6.36
  rc phase, which is why the shortlog is since 2.6.36-rc8 (I had to
  merge the rc-fixes branch)
* other small fixes

Note:  71d8066 (kbuild: fix oldnoconfig to do the right thing) made it
already into 2.6.36 as e9203c9, but it was originally meant for this
merge window and I did not want to rebase the branch. Please let me know
if that's a problem.

Michal

The following changes since commit cd07202cc8262e1669edff0d97715f3dd9260917:

  Linux 2.6.36-rc8 (2010-10-14 16:26:43 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kconfig

Alexander Stein (2):
      kconfig qconf: port to QT4
      Fix QT4 moc, cflags libs detection on dual QT3/Qt4 systems

Andrea Gelmini (1):
      README: cite nconfig

Arnaud Lacombe (22):
      kbuild: confdata.c explicitly reference errno, thus need <errno.h>
      kbuild: don't include `check-lxdialog' ldflags in global HOST_LOADLIBES
      kbuild: fix typo
      kbuild: don't overwrite HOST_EXTRACFLAGS
      kbuild: use getopt_long(), not its _only() variant
      kconfig: replace a `switch()' statement by a more flexible `if()' statement
      kconfig: rephrase help text not to mention the internal prefix
      kconfig: allow build-time definition of the internal config prefix
      kconfig: rephrase help texts/comments not to include the package name
      kconfig: allow PACKAGE to be defined on the compiler's command-line
      kconfig: implement the `mainmenu' directive
      kconfig: regen parser
      kconfig: add a symbol string expansion helper
      kconfig: expand by default the rootmenu's prompt
      kconfig: delay gconf window initialization
      kconfig: replace KERNELVERSION usage by the mainmenu's prompt
      kconfig: don't emit warning upon rootmenu's prompt redefinition
      kconfig: constify file name
      kconfig: use the file's name of sourced file
      kconfig: expand file names
      kbuild: migrate all arch to the kconfig mainmenu upgrade
      kbuild: convert `arch/tile' to the kconfig mainmenu upgrade

Junio C Hamano (1):
      kconfig: fix menuconfig on debian lenny

Justin P. Mattock (1):
      scripts/kconfig/gconf.glade Update broken web addresses.

Kyle McMartin (1):
      kbuild: fix oldnoconfig to do the right thing

Michal Marek (9):
      kconfig: Allow frontends to display messages themselves
      xconfig: Change the titlebar if using Qt3
      kconfig: Simplify Makefile for xconfig
      Merge branch 'kbuild/kconfig/kbuild-generic-v7' of http://github.com/lacombar/linux-2.6 into kbuild/kconfig
      kconfig: Propagate const
      kconfig: Fix realloc usage()
      Merge branch 'kbuild/rc-fixes' into kbuild/kconfig
      Revert "kconfig: Temporarily disable dependency warnings"
      Merge branch 'message-callback' into kbuild/kconfig

Naohiro Aota (1):
      kconfig: Don't go out from read config loop when you read new symbol

Nir Tzachar (1):
      nconfig: add search support

Stephen Boyd (1):
      nconfig: Fix help for choice menus

Will Newton (1):
      kconfig: Use PATH_MAX instead of 128 for path buffer sizes.

 Documentation/kbuild/kconfig-language.txt  |    3 +-
 Kconfig                                    |   11 +
 README                                     |    1 +
 arch/alpha/Kconfig                         |    4 -
 arch/arm/Kconfig                           |    7 -
 arch/avr32/Kconfig                         |    7 -
 arch/blackfin/Kconfig                      |    7 -
 arch/cris/Kconfig                          |    7 -
 arch/frv/Kconfig                           |    6 -
 arch/h8300/Kconfig                         |    7 -
 arch/ia64/Kconfig                          |    7 -
 arch/m32r/Kconfig                          |    7 -
 arch/m68k/Kconfig                          |    6 -
 arch/m68knommu/Kconfig                     |    7 -
 arch/microblaze/Kconfig                    |    5 -
 arch/mips/Kconfig                          |    2 -
 arch/mn10300/Kconfig                       |    9 -
 arch/parisc/Kconfig                        |    7 -
 arch/powerpc/Kconfig                       |    6 -
 arch/s390/Kconfig                          |    7 -
 arch/score/Kconfig                         |    5 -
 arch/sh/Kconfig                            |    7 -
 arch/sparc/Kconfig                         |    6 -
 arch/tile/Kconfig                          |    2 -
 arch/um/Kconfig.common                     |    2 -
 arch/x86/Kconfig                           |    3 -
 arch/xtensa/Kconfig                        |    5 -
 scripts/kconfig/Makefile                   |   87 +++--
 scripts/kconfig/conf.c                     |   15 +-
 scripts/kconfig/confdata.c                 |  126 ++++---
 scripts/kconfig/expr.h                     |    2 +-
 scripts/kconfig/gconf.c                    |   20 +-
 scripts/kconfig/gconf.glade                |    1 -
 scripts/kconfig/kxgettext.c                |   15 +-
 scripts/kconfig/lex.zconf.c_shipped        |    7 +-
 scripts/kconfig/lkc.h                      |    8 +-
 scripts/kconfig/lkc_proto.h                |    3 +
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +
 scripts/kconfig/mconf.c                    |   64 ++--
 scripts/kconfig/menu.c                     |    6 +-
 scripts/kconfig/nconf.c                    |  487 ++++++++++++-------------
 scripts/kconfig/nconf.gui.c                |   22 +-
 scripts/kconfig/nconf.h                    |    3 +-
 scripts/kconfig/qconf.cc                   |  174 +++++----
 scripts/kconfig/qconf.h                    |   76 ++--
 scripts/kconfig/symbol.c                   |   51 +++-
 scripts/kconfig/util.c                     |    7 +-
 scripts/kconfig/zconf.l                    |    7 +-
 scripts/kconfig/zconf.tab.c_shipped        |  547 ++++++++++++++--------------
 scripts/kconfig/zconf.y                    |   18 +-
 50 files changed, 946 insertions(+), 955 deletions(-)
 create mode 100644 Kconfig
