Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2JKWAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:00:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab2JKWAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:00:42 -0400
Date: Fri, 12 Oct 2012 00:00:40 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: adam8157@gmail.com, bpoirier@suse.de,
        gouders@et.bocholt.fh-gelsenkirchen.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for v3.7
Message-ID: <20121011220040.GA7568@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

kconfig in v3.7 is going to
* initialize ncurses only once in menuconfig
* be able to jump to a search result in menuconfig
* change the misnomer oldnoconfig to a more meaningful name
  olddefconfig, keeping the old name as alias

Please pull from the below branch.

Thanks,
Michal

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

for you to fetch changes up to fb16d8912db5268f29706010ecafff74b971c58d:

  kconfig: replace 'oldnoconfig' with 'olddefconfig', and keep the old name as an alias (2012-09-27 18:18:07 +0200)

----------------------------------------------------------------
Adam Lee (2):
      kconfig: document oldnoconfig to what it really does in conf.c
      kconfig: replace 'oldnoconfig' with 'olddefconfig', and keep the old name as an alias

Benjamin Poirier (6):
      menuconfig: Remove superfluous conditionnal
      menuconfig: Extend dialog_textbox so that it can exit on arbitrary keypresses
      menuconfig: Extend dialog_textbox so that it can return to a scrolled position
      menuconfig: Add jump keys to search results
      menuconfig: Do not open code textbox scroll up/down
      menuconfig: Assign jump keys per-page instead of globally

Dirk Gouders (1):
      kconfig/mconf.c: revision of curses initialization.

 scripts/kconfig/Makefile           |   12 ++-
 scripts/kconfig/conf.c             |   25 ++++--
 scripts/kconfig/expr.h             |   11 +++
 scripts/kconfig/lkc_proto.h        |    6 +-
 scripts/kconfig/lxdialog/dialog.h  |    9 +-
 scripts/kconfig/lxdialog/textbox.c |  171 ++++++++++++++++++++----------------
 scripts/kconfig/lxdialog/util.c    |    7 ++
 scripts/kconfig/mconf.c            |  123 ++++++++++++++++++++------
 scripts/kconfig/menu.c             |   53 +++++++++--
 scripts/kconfig/nconf.c            |    2 +-
 tools/testing/ktest/ktest.pl       |   15 ++--
 11 files changed, 296 insertions(+), 138 deletions(-)
