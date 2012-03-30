Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936501Ab2C3W2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:28:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935778Ab2C3W1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:27:54 -0400
Date: Sat, 31 Mar 2012 00:27:31 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gregory.Dietsche@cuw.edu, Julia.Lawall@lip6.fr, hamo.by@gmail.com,
        joerg.roedel@amd.com, kjbmail@gmail.com, mmarek@suse.cz,
        shawnlandden@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.4-rc1
Message-ID: <20120330222730.GA28545@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild for 3.4-rc1:

* New semantic patches, make coccicheck M= fix
* make gtags speedup
* make tags/TAGS always removes struct forward declarations
* make deb-pkg fixes (some patches are still pending, I know)
* scripts/patch-kernel fix from the last user of this script ;)

Note that the branch is based on 3.3-rc1, but I merged the rc-fixes
branch to avoid conflicts. Hence the diffstat and shortlog below is
against 3.3-rc5.

Thanks,
Michal


The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Greg Dietsche (1):
      coccicheck: change handling of C={1,2} when M= is set

Jianbin Kang (1):
      kbuild: incremental tags update for GNU Global

Joerg Roedel (3):
      kbuild: Fix link to headers in 'make deb-pkg'
      kbuild: Only build linux-image package for UML
      kbuild: Fix out-of-tree build for 'make deb-pkg'

Julia Lawall (6):
      coccinelle: semantic patch for missing clk_put
      coccinelle: semantic patch for missing iounmap
      coccinelle: semantic patch converting 0 test to null test
      coccinelle: semantic patch to check for PTR_ERR after reassignment
      coccinelle: semantic patch for bool issues
      scripts/coccinelle/api/ptr_ret.cocci: semantic patch for ptr_err

Michal Marek (1):
      Merge branch 'kbuild/rc-fixes' into kbuild/misc

Shawn Landden (1):
      scripts/patch-kernel: digest kernel.org hosted .xz patches

Yang Bai (1):
      scripts: refactor remove structure forward declarations

 scripts/coccinelle/api/ptr_ret.cocci   |   70 ++++++++++
 scripts/coccinelle/free/clk_put.cocci  |   67 +++++++++
 scripts/coccinelle/free/iounmap.cocci  |   67 +++++++++
 scripts/coccinelle/misc/boolinit.cocci |  178 ++++++++++++++++++++++++
 scripts/coccinelle/misc/cstptr.cocci   |   41 ++++++
 scripts/coccinelle/null/badzero.cocci  |  237 ++++++++++++++++++++++++++++++++
 scripts/package/builddeb               |   20 ++-
 scripts/patch-kernel                   |    4 +
 scripts/tags.sh                        |   13 ++-
 9 files changed, 687 insertions(+), 10 deletions(-)
 create mode 100644 scripts/coccinelle/api/ptr_ret.cocci
 create mode 100644 scripts/coccinelle/free/clk_put.cocci
 create mode 100644 scripts/coccinelle/free/iounmap.cocci
 create mode 100644 scripts/coccinelle/misc/boolinit.cocci
 create mode 100644 scripts/coccinelle/misc/cstptr.cocci
 create mode 100644 scripts/coccinelle/null/badzero.cocci
