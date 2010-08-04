Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab0HDMpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:45:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:47990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab0HDMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:45:24 -0400
Date: Wed, 4 Aug 2010 14:43:53 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: amwang@redhat.com, andi@firstfloor.org, dzickus@redhat.com, mmarek@suse.cz,
        sam@ravnborg.org, u.kleine-koenig@pengutronix.de,
        vda.linux@googlemail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: core changes
Message-ID: <20100804124353.GA21328@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I decided to split the kbuild stuff into multiple branches:
* kbuild - changes to the Makefile and scripts used during build
* kconfig
* packaging - changes to scripts/package/
* misc - all other stuff, i.e. not build-critical scripts and .gitignore
  files

Please let me know if this is OK for you or if you would prefer a single
pull request with the four branches merged into one next time.

Anyway, here is the kbuild branch. Nothing particulary exciting this
time. Sam made passing of custom compiler / assembler and linker flags
more consistent, the following external variables are now supported (one
doesn't have to remember to add any kbuild-internal flags):

make AFLAGS_KERNEL=... CFLAGS_KERNEL=... \
     AFLAGS_MODULE=... CFLAGS_MODULE=... LDFLAGS_MODULE=...


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Amerigo Wang (1):
      Makefile: "make kernelrelease" should show the correct full kernel version

Andi Kleen (1):
      Kbuild: Add option to set -femit-struct-debug-baseonly

Denys Vlasenko (1):
      modpost: support objects with more than 64k sections

Don Zickus (1):
      Makefile.build: make KBUILD_SYMTYPES work again

Michal Marek (2):
      Merge branch 'setlocalversion-speedup' into kbuild/kbuild
      Merge commit 'v2.6.35' into kbuild/kbuild

Sam Ravnborg (3):
      kbuild: allow assignment to {A,C,LD}FLAGS_MODULE on the command line
      kbuild: allow assignment to {A,C}FLAGS_KERNEL on the command line
      frv: clean up arch/frv/Makefile

Uwe Kleine-König (1):
      trivial: fix a typo in a filename

 Documentation/kbuild/kbuild.txt    |   26 ++++++++-
 Documentation/kbuild/makefiles.txt |   27 ++++++++--
 Makefile                           |   29 +++++++---
 arch/avr32/Makefile                |    2 +-
 arch/blackfin/Makefile             |    4 +-
 arch/frv/Makefile                  |   22 +-------
 arch/ia64/Makefile                 |    6 +-
 arch/m32r/Makefile                 |    4 +-
 arch/m68k/Makefile                 |    2 +-
 arch/mips/Makefile                 |    6 ++-
 arch/powerpc/Makefile              |    2 +-
 arch/s390/Makefile                 |    3 +-
 arch/score/Makefile                |    3 +-
 lib/Kconfig.debug                  |   13 +++++
 scripts/Makefile.build             |   37 +++++++------
 scripts/Makefile.modpost           |    9 ++--
 scripts/mod/file2alias.c           |    6 +-
 scripts/mod/modpost.c              |  102 ++++++++++++++++++++++++++---------
 scripts/mod/modpost.h              |   43 +++++++++++++++
 19 files changed, 246 insertions(+), 100 deletions(-)
