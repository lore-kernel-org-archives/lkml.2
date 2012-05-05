Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2EEIGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:06:48 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:63636 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2EEIGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:06:42 -0400
Date: Sat, 5 May 2012 10:06:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 0/8] kbuild: use script for final link, move definitions
	out of top-level Makefile 
Message-ID: <20120505080640.GA13773@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, all.

o Move the link of vmlinux from top-level Makefile to a script.
  This increased the readability a lot.
  They have had a few rounds of reviews and are ready.

o Move a lot of definitions from top-level Makefile to
  two new files located in scripts/

o Fix so we do not call CC too often when using W=...

o Fix so KCFLAGS (and friends) are added last to the
  command lines.

Patches 1-4 are ready to be applied.
Patches 5-8 are new and may raise a few comments.

All patches are on top of 3.4-rc5.

	Sam

 Documentation/kbuild/kbuild.txt |   19 ++
 Makefile                        |  389 ++------------------------------------
 arch/sparc/Makefile             |   11 -
 arch/sparc/boot/Makefile        |   14 +-
 arch/um/Makefile                |   11 +-
 scripts/Kbuild.arch             |  148 +++++++++++++++
 scripts/Kbuild.config           |   68 +++++++
 scripts/Makefile.build          |   51 -----
 scripts/link-vmlinux.sh         |  211 +++++++++++++++++++++
 9 files changed, 478 insertions(+), 444 deletions(-)

Artem Bityutskiy (1):
      kbuild: remove useless warning

Sam Ravnborg (7):
      kbuild: drop unused KBUILD_VMLINUX_OBJS from top-level Makefile
      kbuild: refactor final link of sparc32
      kbuild: link of vmlinux moved to a script
      kbuild: document KBUILD_LDS, KBUILD_VMLINUX_{INIT,MAIN} and LDFLAGS_vmlinux
      kbuild: move definitions from top-level Makefile to scripts/Kbuild.config
      kbuild: move arch definitions from top-level Makefile to scripts/Kbuild.arch
      kbuild: move W=... stuff to Kbuild.arch

