Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1EYUSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:18:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:37912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab1EYUSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:18:39 -0400
Date: Wed, 25 May 2011 22:18:32 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ben@decadent.org.uk, edsiper@gmail.com, lacombar@gmail.com, mmarek@suse.cz,
        pefoley2@verizon.net, randy.dunlap@oracle.com, sboyd@codeaurora.org,
        yann.morin.1998@anciens.enib.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/kconfig
Message-ID: <20110525201831.GA29210@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the kconfig par of kbuild. Nothing really exciting this time.
* No more timestamps in .config and friends
* kconfig Makefile clanup and fixes
* Misc other fixes

In the next cycle will come a generic way to convert some

  #ifdef CONFIG_FOO

statements to

  if (<something>)

to improve build coverage. But it's not ready yet.

Michal

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kconfig-for-40

Arnaud Lacombe (2):
      kconfig: do not record timestamp in .config
      xconfig: merge code path to conf_write()

Ben Hutchings (1):
      kconfig: Avoid buffer underrun in choice input

Eduardo Silva (2):
      gconfig: enable rules hint for main treeviews
      gconfig: Hide unused left treeview when start up the interface

Michal Marek (3):
      kconfig: Do not record timestamp in auto.conf and autoconf.h
      kconfig: Document the new "visible if" syntax
      MAINTAINERS: Update KCONFIG entry

Peter Foley (7):
      kconfig: only build kxgettext when needed
      kconfig: change qconf to modify hostprogs-y like nconf and mconf
      kconfig: change gconf to modify hostprogs-y like nconf and mconf
      kconfig: rearrange clean-files
      kconfig: make update-po-config work in KBUILD_OUTPUT
      kconfig: change update-po-config to reflect new layout of arch/um
      kconfig: quiet commands when V=0

Randy Dunlap (1):
      kconfig-language: add to hints

Stephen Boyd (1):
      nconfig: Silence unused return values from wattrset

Yann E. MORIN (2):
      kconfig: allow multiple inclusion of the same file
      kconfig: get rid of unused flags

 CREDITS                                   |    4 +++
 Documentation/kbuild/kconfig-language.txt |   32 +++++++++++++++++++++++-
 Documentation/kbuild/kconfig.txt          |    5 ----
 MAINTAINERS                               |    5 +--
 scripts/kconfig/Makefile                  |   38 +++++++++++++++++-----------
 scripts/kconfig/conf.c                    |    2 +-
 scripts/kconfig/confdata.c                |   20 ++-------------
 scripts/kconfig/expr.h                    |    4 ---
 scripts/kconfig/gconf.c                   |   12 ++++++---
 scripts/kconfig/lex.zconf.c_shipped       |   33 ++++++++++++++----------
 scripts/kconfig/nconf.c                   |   14 +++++-----
 scripts/kconfig/qconf.cc                  |    5 +--
 scripts/kconfig/zconf.l                   |   33 ++++++++++++++----------
 13 files changed, 119 insertions(+), 88 deletions(-)
