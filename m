Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1GYXFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:05:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1GYXFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:05:31 -0400
Date: Tue, 26 Jul 2011 01:05:28 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: geert@linux-m68k.org, jj@chaosbits.net, lacombar@gmail.com,
        markus@trippelsdorf.de, mmarek@suse.cz, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild updates for 3.1-rc1
Message-ID: <20110725230528.GA32696@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the main part of kbuild for 3.1-rc1:
* Consolidation of Makefile rules for dealing with bison/flex/gperf
  generated files, which is why the diffstat looks bigger than usual.
* Fix for headers_install to not export the __packed convenience macro.
* 4 other minor fixes.


The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Arnaud Lacombe (14):
      kbuild: add `baseprereq'
      kbuild: add implicit rules for parser generation
      kbuild: simplify the %_shipped rule
      genksyms: pass hash and lookup functions name and target language though the input file
      genksyms: drop -Wno-uninitialized from HOSTCFLAGS_parse.tab.o
      genksyms: migrate parser to implicit rules
      genksym: regen parser
      kconfig: constify `kconf_id_lookup'
      kconfig: kill no longer needed reference to YYDEBUG
      kconfig/zconf.l: do not ask to generate backup
      kconfig: migrate parser to implicit rules
      kconfig: regen parser
      dtc: migrate parser to implicit rules
      dtc: regen parser

Geert Uytterhoeven (1):
      kbuild: Fix reference to vermagic.h

Jesper Juhl (1):
      genksyms: Use same type in loop comparison

Markus Trippelsdorf (1):
      headers_install: fix __packed in exported kernel headers

Michal Marek (2):
      Merge commit 'v3.0-rc1' into kbuild/kbuild
      Merge branch 'kbuild-implicit-parser-rule' of git://github.com/lacombar/linux-2.6 into kbuild/kbuild

Peter Foley (2):
      kernel: prevent unnecessary rebuilding due to config_data.gz
      kbuild: silence generated makefile message

 kernel/Makefile                                    |    5 +-
 scripts/Kbuild.include                             |    4 +
 scripts/Makefile.lib                               |   40 +++-
 scripts/Makefile.modpost                           |    2 +-
 scripts/dtc/Makefile                               |   28 +--
 scripts/dtc/dtc-lexer.lex.c_shipped                |   59 +---
 scripts/dtc/dtc-parser.tab.c_shipped               |  116 +------
 scripts/dtc/dtc-parser.tab.h_shipped               |   11 +-
 scripts/genksyms/.gitignore                        |    7 +-
 scripts/genksyms/Makefile                          |   48 +---
 scripts/genksyms/genksyms.c                        |    2 +-
 scripts/genksyms/keywords.gperf                    |    3 +
 ...{keywords.c_shipped => keywords.hash.c_shipped} |   96 +++---
 scripts/genksyms/lex.l                             |    4 +-
 .../genksyms/{lex.c_shipped => lex.lex.c_shipped}  |  359 +-------------------
 .../{parse.c_shipped => parse.tab.c_shipped}       |  198 +----------
 .../{parse.h_shipped => parse.tab.h_shipped}       |    7 +-
 scripts/headers_install.pl                         |    1 +
 scripts/kconfig/.gitignore                         |    2 +-
 scripts/kconfig/Makefile                           |   34 +--
 scripts/kconfig/lkc.h                              |    2 -
 scripts/kconfig/zconf.gperf                        |    2 +-
 scripts/kconfig/zconf.hash.c_shipped               |  273 +++++++++-------
 scripts/kconfig/zconf.l                            |    8 +-
 .../{lex.zconf.c_shipped => zconf.lex.c_shipped}   |   26 +--
 scripts/kconfig/zconf.tab.c_shipped                |   68 ++--
 scripts/kconfig/zconf.y                            |   18 +-
 scripts/mkmakefile                                 |    9 +-
 28 files changed, 383 insertions(+), 1049 deletions(-)
 rename scripts/genksyms/{keywords.c_shipped => keywords.hash.c_shipped} (94%)
 rename scripts/genksyms/{lex.c_shipped => lex.lex.c_shipped} (89%)
 rename scripts/genksyms/{parse.c_shipped => parse.tab.c_shipped} (92%)
 rename scripts/genksyms/{parse.h_shipped => parse.tab.h_shipped} (96%)
 rename scripts/kconfig/{lex.zconf.c_shipped => zconf.lex.c_shipped} (98%)
