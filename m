Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab1KCP6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:58:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689Ab1KCP6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:58:11 -0400
Date: Thu, 3 Nov 2011 16:58:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: amwang@redhat.com, lacombar@gmail.com, mmarek@suse.cz,
        pefoley2@verizon.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild updates for 3.2
Message-ID: <20111103155809.GA7532@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the main part of kbuild for 3.2. It's rather boring this time:
- Fix to keep _shipped files if the user removes them to force a rebuild
- make distclean does not remove empty files, should someone create one
  again :)
- Save one make invocation in make prepare
- genksyms won't checksum structs defined inside the current C file
- a couple of minor fixes

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Amerigo Wang (1):
      Makefile: remove a duplicated line

Arnaud Lacombe (2):
      scripts/Makefile.build: do not reference EXTRA_CFLAGS as CFLAGS replacement
      Kbuild: append missing-syscalls to the default target list

Michal Marek (4):
      kbuild: Do not delete empty files in make distclean
      genksyms: Minor parser cleanup
      genksyms: Do not expand internal types
      genksyms: Regenerate lexer and parser

Peter Foley (2):
      kbuild: prevent make from deleting _shipped files
      fixdep: fix extraneous dependencies

 Kbuild                               |    6 +-
 Makefile                             |    4 +-
 scripts/Makefile.build               |    2 +-
 scripts/Makefile.lib                 |    4 +
 scripts/basic/fixdep.c               |    1 +
 scripts/genksyms/genksyms.c          |    3 +-
 scripts/genksyms/genksyms.h          |    4 +-
 scripts/genksyms/lex.l               |    8 +
 scripts/genksyms/lex.lex.c_shipped   |   12 +-
 scripts/genksyms/parse.tab.c_shipped |  645 ++++++++++++++++++----------------
 scripts/genksyms/parse.tab.h_shipped |    7 +-
 scripts/genksyms/parse.y             |   40 ++-
 12 files changed, 404 insertions(+), 332 deletions(-)
