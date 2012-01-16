Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2APUyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:54:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab2APUys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:54:48 -0500
Date: Mon, 16 Jan 2012 21:54:46 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gregory.Dietsche@cuw.edu, Julia.Lawall@lip6.fr, adobriyan@gmail.com,
        sboyd@codeaurora.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc updates for v3.3-rc1
Message-ID: <20120116205446.GA4794@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild:
* make coccicheck enhancements and new checks
* make tags improvements

Michal

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Alexey Dobriyan (1):
      ctags: remove struct forward declarations

Greg Dietsche (2):
      coccicheck: add M= option to control which dir is processed
      coccinelle.txt: update documentation to include M= option

Julia Lawall (3):
      coccinelle: semantic patches related to devm_ functions (part 1)
      coccinelle: semantic patches related to devm_ functions (part 2)
      scripts/coccinelle: improve the coverage of some semantic patches

Stephen Boyd (1):
      scripts/tags.sh: Add Page flag function magic

 Documentation/coccinelle.txt                       |   10 ++-
 scripts/coccicheck                                 |   19 +++-
 .../coccinelle/api/devm_request_and_ioremap.cocci  |  105 ++++++++++++++++++++
 scripts/coccinelle/api/kstrdup.cocci               |   75 +++++++++++++-
 scripts/coccinelle/api/memdup.cocci                |   34 ++++++-
 scripts/coccinelle/api/memdup_user.cocci           |   39 ++++++--
 scripts/coccinelle/free/devm_free.cocci            |   71 +++++++++++++
 scripts/coccinelle/free/kfree.cocci                |   14 ++-
 scripts/coccinelle/iterators/fen.cocci             |   73 ++++++++++++--
 scripts/coccinelle/iterators/itnull.cocci          |   54 +++++++++--
 scripts/coccinelle/locks/call_kern.cocci           |   67 +++++++++----
 scripts/coccinelle/locks/flags.cocci               |   12 +-
 scripts/coccinelle/locks/mini_lock.cocci           |   15 ++--
 scripts/coccinelle/misc/doubleinit.cocci           |    8 +-
 scripts/coccinelle/null/eno.cocci                  |   36 ++++++-
 scripts/tags.sh                                    |   48 +++++++++-
 16 files changed, 595 insertions(+), 85 deletions(-)
 create mode 100644 scripts/coccinelle/api/devm_request_and_ioremap.cocci
 create mode 100644 scripts/coccinelle/free/devm_free.cocci
