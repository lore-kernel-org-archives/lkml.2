Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935656Ab2C3W2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:28:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935798Ab2C3W15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:27:57 -0400
Date: Sat, 31 Mar 2012 00:13:34 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: JBeulich@suse.com, balbi@ti.com, bernhard@bwalle.de, bobbypowers@gmail.com,
        dev@snitselaar.org, kirill.shutemov@linux.intel.com,
        roland@purestorage.com, swarren@wwwdotorg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild for 3.4
Message-ID: <20120330221334.GA27849@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following kbuild change for 3.4-rc1. Nothing really
exciting this time:

* Unification of cmd_uimage among archs that use it
* make headers_check tries harder before reporting a missing
  <linux/types.h> include
* kbuild portability fix for shells that do not support echo -e
* make clean descends into samples/
* setlocalversion grep fix
* modpost typo fix
* dtc warnings fix

Thanks,
Michal

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Bernhard Walle (1):
      scripts/Kbuild.include: Fix portability problem of "echo -e"

Bobby Powers (1):
      headers_check: recursively search for linux/types.h inclusion

Felipe Balbi (1):
      scripts: dtc: fix compile warnings

Gerard Snitselaar (1):
      kbuild: clean up samples directory

Jan Beulich (1):
      modpost: fix ALL_INIT_DATA_SECTIONS

Kirill A. Shutemov (1):
      kbuild: disable -Wmissing-field-initializers for W=1

Roland Dreier (1):
      setlocalversion: Use "grep -q" instead of piping output to "read dummy"

Stephen Warren (1):
      Kbuild: centralize MKIMAGE and cmd_uimage definitions

 Makefile                        |    2 +-
 arch/arm/boot/Makefile          |   23 +++++++++--------------
 arch/avr32/boot/images/Makefile |    9 +++------
 arch/blackfin/boot/Makefile     |   19 ++++++++-----------
 arch/microblaze/boot/Makefile   |   10 +++-------
 arch/sh/boot/Makefile           |    8 ++------
 arch/sparc/boot/Makefile        |    9 +++------
 arch/unicore32/boot/Makefile    |   12 ++----------
 scripts/Kbuild.include          |    2 +-
 scripts/Makefile.build          |    2 ++
 scripts/Makefile.lib            |   24 ++++++++++++++++++++++++
 scripts/dtc/dtc.c               |    5 +----
 scripts/dtc/flattree.c          |    2 --
 scripts/headers_check.pl        |   38 +++++++++++++++++++++++++++++++++++++-
 scripts/mod/modpost.c           |    2 +-
 scripts/setlocalversion         |    3 +--
 16 files changed, 98 insertions(+), 72 deletions(-)
