Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1CSI6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 04:58:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab1CSI6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 04:58:07 -0400
Date: Sat, 19 Mar 2011 09:58:02 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bp@alien8.de, dot@dotat.at, mikew@google.com, mmarek@suse.cz,
        randy.dunlap@oracle.com, u.kleine-koenig@pengutronix.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild core updates for 2.6.39-rc1
Message-ID: <20110319085802.GA18336@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild updates for 2.6.39-rc1:

* Section mismatch analysis enabled by default
  - there are only a few warnings for defconfig builds,
    all{yes,mod}config still has a lot of them. Depending on the general
    perception of this change, we might disable it later in the rc phase
    again.
* Update of unifdef. This is a noop for kbuild, but being in sync
  with upstream is good.
* make W=1 mode that enables a lot of non-default gcc warnings.
* genksyms detects changes in enum constant values.
* two minor fixes.


The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Borislav Petkov (1):
      kbuild: Add extra gcc checks

Michal Marek (8):
      genksyms: Do not paste the bison header file to lex.c
      genksyms: Simplify lexer
      genksyms: Simplify printing of symbol types
      genksyms: Add helpers for building string lists
      genksyms: simplify usage of find_symbol()
      genksyms: Track changes to enum constants
      genksyms: Regenerate lexer and parser
      Merge branch 'genksyms-enum' into kbuild/kbuild

Mike Waychison (1):
      KBuild: silence "'scripts/unifdef' is up to date."

Randy Dunlap (1):
      modpost: fix trailing comma

Tony Finch (1):
      unifdef: update to upstream version 2.5

Uwe Kleine-König (1):
      kbuild: reenable section mismatch analysis

 Documentation/kbuild/kbuild.txt  |    5 +
 Makefile                         |    7 +-
 lib/Kconfig.debug                |    4 -
 scripts/Makefile                 |    5 +
 scripts/Makefile.build           |   35 ++-
 scripts/genksyms/Makefile        |    4 +-
 scripts/genksyms/genksyms.c      |  192 +++++--
 scripts/genksyms/genksyms.h      |    7 +-
 scripts/genksyms/lex.c_shipped   |  427 ++++++----------
 scripts/genksyms/lex.l           |   44 ++-
 scripts/genksyms/parse.c_shipped | 1071 ++++++++++++++++++++++----------------
 scripts/genksyms/parse.h_shipped |   72 +--
 scripts/genksyms/parse.y         |   34 ++-
 scripts/mod/modpost.c            |   23 +-
 scripts/unifdef.c                |  247 +++++++---
 15 files changed, 1237 insertions(+), 940 deletions(-)
