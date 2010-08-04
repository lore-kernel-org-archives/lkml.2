Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab0HDMxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:53:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab0HDMxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:53:22 -0400
Date: Wed, 4 Aug 2010 14:51:56 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: JBeulich@novell.com, aris@redhat.com, catalin.marinas@arm.com,
        jacmet@sunsite.dk, justinmattock@gmail.com, lizf@cn.fujitsu.com,
        mmarek@suse.cz, sam@ravnborg.org, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: kconfig changes
Message-ID: <20100804125156.GA23464@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the kconfig part of kbuild. We have four new *config targets:
* oldnoconfig: set all new options to 'n'
* listnewconfig: list all unset config options
* alldefconfig: set all options to their defaults specified in Kconfig
  files
* savedefconfig: write a defconfig file with only the differences from
  an alldefconfig (aka minimal defconfig)

Kconfig also warns when a select statement selects a symbol with unmet
dependencies (which typically results in a broken config). Li Zefan did
quite some usability fixes to the visual config interfaces.

Michal

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kconfig

Aristeu Rozanski (1):
      kconfig: introduce nonint_oldconfig and loose_nonint_oldconfig

Catalin Marinas (1):
      kbuild: Warn on selecting symbols with unmet direct dependencies

Jan Beulich (1):
      kconfig: Don't write invisible choice values

Justin P. Mattock (1):
      scripts:conf.c Fix warning: variable 'type' set but not used

Li Zefan (11):
      kconfig: print symbol type in help text
      kconfig: print the range of integer/hex symbol in help text
      kconfig: fix to tag NEW symbols correctly
      menuconfig: improive help text a bit
      gconfig: fix to tag NEW symbols correctly
      gconfig: fix null pointer warning
      xconfig: clean up
      xconfig: remove unused function
      xconfig: add support to show hidden options which have prompts
      menuconfig: fix to center checklist correctly in a corner case
      menuconfig: truncate list items

Michal Marek (1):
      Merge commit 'v2.6.35' into kbuild/kconfig

Peter Korsgaard (1):
      kconfig: make randconfig fair for booleans

Roman Zippel (1):
      kconfig: print more info when we see a recursive dependency

Sam Ravnborg (8):
      kconfig: use long options in conf
      kconfig: rename loose_nonint_oldconfig => oldnoconfig
      kconfig: change nonint_oldconfig to listnewconfig
      kconfig: save location of config symbols
      kconfig: add alldefconfig
      kconfig: refactor code in symbol.c
      kconfig: code refactoring in confdata.c
      kconfig: add savedefconfig

Ulf Magnusson (1):
      kconfig: fix MODULES-related bug in case of no .config

 Documentation/kbuild/kconfig.txt     |    2 +-
 scripts/kconfig/Makefile             |   77 +++++-----
 scripts/kconfig/conf.c               |  181 ++++++++++++---------
 scripts/kconfig/confdata.c           |  221 ++++++++++++++++++--------
 scripts/kconfig/expr.c               |    2 +-
 scripts/kconfig/expr.h               |    3 +
 scripts/kconfig/gconf.c              |    7 +-
 scripts/kconfig/lkc.h                |    2 +
 scripts/kconfig/lkc_proto.h          |    1 +
 scripts/kconfig/lxdialog/checklist.c |   10 +-
 scripts/kconfig/mconf.c              |    2 +-
 scripts/kconfig/menu.c               |   27 +++-
 scripts/kconfig/qconf.cc             |  106 +++++++------
 scripts/kconfig/qconf.h              |   17 ++-
 scripts/kconfig/symbol.c             |  292 ++++++++++++++++++++++++++++++----
 15 files changed, 667 insertions(+), 283 deletions(-)
