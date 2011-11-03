Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab1KCQFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:05:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933777Ab1KCQFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:05:05 -0400
Date: Thu, 3 Nov 2011 17:05:03 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: crquan@gmail.com, dave@gnu.org, lacombar@gmail.com,
        lucas.demarchi@profusion.mobi, mmarek@suse.cz,
        srinivas.kandagatla@st.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig for 3.2
Message-ID: <20111103160503.GA8008@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kconfig bits for 3.2-rc1:
- a couple of fixes for make nconfig
- help text is displayed for choice menus if there is one
- make localmodconfig/localyesconfig cleanups
- make menuconfig handles sigint nicely
- fix for the generated __enabled_* macros so that the IS_ENABLED macro
  is actually usable

Michal

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

Arnaud Lacombe (6):
      kconfig/streamline_config.pl: directly access LSMOD from the environment
      kconfig/streamline_config.pl: use options to determine operating mode
      kconfig/streamline_config.pl: merge local{mod,yes}config
      kconfig/nconf: nuke unreferenced `nohelp_text'
      kconfig: factor code in menu_get_ext_help()
      kconfig: fix __enabled_ macros definition for invisible and un-selected symbols

Cheng Renquan (5):
      scripts/kconfig/nconf: fix typo: unknow => unknown
      scripts/kconfig/nconf: fix memmove's length arg
      scripts/kconfig/nconf: dynamically alloc dialog_input_result
      scripts/kconfig/nconf: fix editing long strings
      scripts/kconfig/nconf: add KEY_HOME / KEY_END for dialog_inputbox

Davidlohr Bueso (1):
      kconfig: handle SIGINT in menuconfig

Lucas De Marchi (1):
      kconfig: fix set but not used variables

Michal Marek (2):
      Merge branch 'master/kconfig-localmodconfig' of git://github.com/lacombar/linux-2.6 into kbuild/kconfig
      Merge branch 'kconfig/for-next' of git://github.com/lacombar/linux-2.6 into kbuild/kconfig

Srinivas Kandagatla (1):
      kbuild: Fix help text not displayed in choice option.

 scripts/kconfig/Makefile             |   28 +----------
 scripts/kconfig/confdata.c           |   49 ++++++++++++++-----
 scripts/kconfig/lxdialog/textbox.c   |    3 +-
 scripts/kconfig/mconf.c              |   86 ++++++++++++++++++++-------------
 scripts/kconfig/menu.c               |   13 ++---
 scripts/kconfig/nconf.c              |   23 ++++-----
 scripts/kconfig/nconf.gui.c          |   59 ++++++++++++++++++-----
 scripts/kconfig/nconf.h              |    2 +-
 scripts/kconfig/streamline_config.pl |   22 +++++++-
 9 files changed, 173 insertions(+), 112 deletions(-)
