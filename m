Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0LQX3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:29:39 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:35855 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754880Ab0LQX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:29:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UgSX19kma0W9SkQLs8enf/SK2M2c4p8GdjEaiajn+jiHEAsjzEhwKSn/hxhAnM+iCMvSybTZSTzC8Y1KoxozUo13666E+Ea+tOxcKevLzqjTH9at/Rn7L4Uq+pG09Rak;
Date: Fri, 17 Dec 2010 15:29:33 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20101217152933.05c51257@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

This has the reverts and fixes you wanted from Bjorn along with another
fix for some AMD machines with nVidia chipsets.  (I thought I had other
fixes queued up but I must have been mixing up my branches, so this is
all there is for now.)

Bjorn Helgaas (9):
      Revert "PCI: fix pci_bus_alloc_resource() hang, prefer positive decode"
      Revert "x86: allocate space within a region top-down"
      Revert "x86/PCI: allocate space from the end of a region, not the beginning"
      Revert "PCI: allocate bus resources from the top down"
      Revert "resources: support allocating space within a region from the top down"
      resources: add arch hook for preventing allocation in reserved areas
      x86: avoid low BIOS area when allocating address space
      x86: avoid E820 regions when allocating address space
      x86: avoid high BIOS area when allocating address space

Neil Horman (1):
      PCI: Update MCP55 quirk to not affect non HyperTransport variants

 Documentation/kernel-parameters.txt |    5 --
 arch/x86/include/asm/e820.h         |    3 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/resource.c          |   48 ++++++++++++++++
 arch/x86/kernel/setup.c             |    1 -
 arch/x86/pci/i386.c                 |   18 ++----
 drivers/pci/bus.c                   |   81 ++-------------------------
 drivers/pci/quirks.c                |    3 +
 include/linux/ioport.h              |    2 +-
 kernel/resource.c                   |  104 +++-------------------------------
 10 files changed, 76 insertions(+), 190 deletions(-)
 create mode 100644 arch/x86/kernel/resource.c

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
