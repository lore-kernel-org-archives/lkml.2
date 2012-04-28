Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2D1U4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 16:56:55 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17130 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2D1U4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 16:56:53 -0400
Date: Sat, 28 Apr 2012 22:56:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 0/4] kbuild: Move vmlinux link out of top-level Makefile
Message-ID: <20120428205651.GA7426@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset moves all the magic used
to deal with the final link of vmlinux from the
top-level Makefile to a shell script.

The main motivation was to convert the almost
unreadable mess in the top-level Makefile to
an easy to read/maintain shell script.

The final link stages are serialized
anyway - so there where nothing gained by using
the Makefile logic to handle this.

What we gain:
- A readable final link of vmlinux
- Less junk in the top-level Makefile

What we loose by the conversion:
- We no logner rebuild if one of the .tmp_kallsyms
  files are deleted.
- We no longer rebuild if vmlinux.o is deleted

None of the above cases are hit by a typical
kernel developer so the drawbacks are acceptable.

I had to implement special handling of um in the
link-vmlinux script. It is not pretty by any means,
but I could not come up with something better.
My previous attempts to use ld for um linking has failed,
so this kludge was introduced.

There is no outstanding issues to my knowledge,
and the patchset is ready to be applied.
I assume this should go in via the kbuild#misc tree.

v2:
- rebuild if options to ld changes (Andi Kleen)
- shell script improvements from Nick Bowler
- clean target calls script to clean up after link
- include documentation of LDFLAGS_vmlinux

	Sam

 Documentation/kbuild/kbuild.txt |   19 +++++
 Makefile                        |  217 ++++----------------------------------------------
 arch/sparc/Makefile             |   11 ---
 arch/sparc/boot/Makefile        |   14 ++--
 arch/um/Makefile                |   11 +--
 scripts/link-vmlinux.sh         |  211 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 256 insertions(+), 227 deletions(-)

Sam Ravnborg (4):
      kbuild: drop unused KBUILD_VMLINUX_OBJS from top-level Makefile
      kbuild: refactor final link of sparc32
      kbuild: link of vmlinux moved to a script
      kbuild: document KBUILD_LDS, KBUILD_VMLINUX_{INIT,MAIN} and LDFLAGS_vmlinux

