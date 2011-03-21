Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1CUBre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 21:47:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:55134 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1CUBrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 21:47:31 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 12:46:41 +1100
Message-ID: <1300672001.2402.203.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Here's a fix for the regression introduced by
b5d937de0367d26f65b9af1aef5f2c34c1939be0 along with a bug fix from Mike
Wolf for a nasty BUG_ON() that shoudn't be there for some odd case of
threaded core dumps, and 3 patches from Meador Inge that I plain forgot
to include before.

Cheers,
Ben.

The following changes since commit a952baa034ae7c2e4a66932005cbc7ebbccfe28d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2011-03-19 22:27:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      powerpc/pci: Fix crash in PCI code on ppc64 when matching device nodes

Meador Inge (3):
      powerpc: Document the Open PIC device tree binding
      powerpc: Make MPIC honor the "pic-no-reset" device tree property
      powerpc: Factoring mpic cpu id fetching into a function

Mike Wolf (1):
      powerpc/ptrace: Remove BUG_ON when full register set not available

 Documentation/devicetree/bindings/open-pic.txt |   98 ++++++++++++++++++++++++
 arch/powerpc/include/asm/mpic.h                |    4 +
 arch/powerpc/include/asm/ptrace.h              |    2 +
 arch/powerpc/kernel/pci_dn.c                   |    7 +-
 arch/powerpc/kernel/ptrace.c                   |   15 +++-
 arch/powerpc/sysdev/mpic.c                     |   85 +++++++++++++++-----
 6 files changed, 184 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/open-pic.txt


