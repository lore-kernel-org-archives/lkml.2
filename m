Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0LDN5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 08:57:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab0LDN5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 08:57:35 -0500
Date: Sat, 4 Dec 2010 14:57:32 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: brueckner@linux.vnet.ibm.com, lacombar@gmail.com, mchehab@redhat.com,
        mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
Message-ID: <20101204135732.GA12774@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild/kconfig fixes for the next -rc. The largest
part are fixes for the annoying kconfig warnings, contributed by Arnaud
Lacombe and Mauro Carvalho Chehab. The solution adds a new 'visible if'
keyword to the Kconfig language, so it's not exactly something that one
would expect in the rc phase, but the kconfig change is not huge (the
large diff is due to generated files) and it is deployed only in those
five Kconfig files that had the warnings and were hard to fix by other
means.  The second part is a forgotten patch by Hendrik Brueckner to
usr/initramfs, that fixes build for Blackfin and h8300.

Michal

The following changes since commit e8a7e48bb248a1196484d3f8afa53bded2b24e71:

  Linux 2.6.37-rc4 (2010-11-29 20:42:04 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Arnaud Lacombe (5):
      kconfig: add an option to determine a menu's visibility
      kconfig: regen parser
      Revert "i2c: Fix Kconfig dependencies"
      media/video: convert Kconfig to use the menu's `visible' keyword
      i2c/algos: convert Kconfig to use the menu's `visible' keyword

Hendrik Brueckner (1):
      initramfs: Really fix build break on symbol-prefixed archs

Mauro Carvalho Chehab (1):
      [media] Fix Kconfig errors due to two visible menus

Michal Marek (1):
      Merge branch 'kconfig_fixes' of git://git.kernel.org/.../mchehab/linux-next into kbuild/rc-fixes

 drivers/i2c/Kconfig                  |    3 +-
 drivers/i2c/algos/Kconfig            |   14 +-
 drivers/media/common/tuners/Kconfig  |    8 +-
 drivers/media/dvb/frontends/Kconfig  |    5 +-
 drivers/media/video/Kconfig          |    2 +-
 scripts/kconfig/expr.h               |    1 +
 scripts/kconfig/lkc.h                |    1 +
 scripts/kconfig/menu.c               |   11 +
 scripts/kconfig/zconf.gperf          |    1 +
 scripts/kconfig/zconf.hash.c_shipped |  122 ++++----
 scripts/kconfig/zconf.tab.c_shipped  |  570 +++++++++++++++++----------------
 scripts/kconfig/zconf.y              |   21 +-
 usr/initramfs_data.S                 |    5 +-
 13 files changed, 401 insertions(+), 363 deletions(-)
