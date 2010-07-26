Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0GZUiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:38:23 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50214 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0GZUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:38:19 -0400
Date: Mon, 26 Jul 2010 22:38:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 0/3] update of various kbuild flags to allow user settings 
Message-ID: <20100726203814.GA18828@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko complained that he could not set
a moduel specific linker flags on the command line.

It turned out that the cause of this was kbuild
that assigned a value to a variables that
may be modified by the user.
So any user supplied value would overwrite
the kbuild assigned value.

Fix this so we use internal variables for kbuild
feering up the official variables for use by
the user.

To do so some trivial modifications was done
in various arch Makefile.

Respective arch maintainers are copied
on the patches.

[Patches are on top of for-next of kbuild.git]

	Sam

Sam Ravnborg (3):
      kbuild: allow user to assign {A,C}FLAGS_MODULE
      frv: remove useless ARCHMODFLAGS assignment
      kbuild: allow user to assign LDFLAGS_MODULE

 Makefile                 |   12 +++++++-----
 arch/blackfin/Makefile   |    2 +-
 arch/frv/Makefile        |    2 --
 arch/ia64/Makefile       |    2 +-
 arch/m68k/Makefile       |    2 +-
 arch/mips/Makefile       |    4 ++--
 arch/powerpc/Makefile    |    2 +-
 arch/s390/Makefile       |    2 +-
 arch/score/Makefile      |    2 +-
 scripts/Makefile.build   |    9 ++++++---
 scripts/Makefile.modpost |    5 +++--
 11 files changed, 24 insertions(+), 20 deletions(-)

