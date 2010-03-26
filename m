Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0CZXeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:34:31 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:34539 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753437Ab0CZXe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:34:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DbopL3ro0UtKGagXiMduZyAzowBIy3Q8sifLBOr8lSXM+FE85q4bs44L/p7cNaI18gD1K2jy9Dosm2Jb25S0lpxF1OIj58hrx4+qP0UfBR7ld1UzxQqM2rZ8j2I31U9A;
Date: Fri, 26 Mar 2010 16:33:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100326163349.3ba918c2@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
fc7f99cf36ebae853639dabb43bc2f0098c59aef: Linus Torvalds (1):
        Merge branch 'for-linus' of
git://git.kernel.org/.../sage/ceph-client

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Bjorn's been working hard to track down regressions related to the new
"use _CRS by default" code, and things are looking better than I
thought they would at this point.  I believe Yinghai is also tracking a
regression or two related to the new re-allocation code, but that's
also looking fairly good.

Note this does include a few extra bits of debug output; though not
strictly bug fixes I figured they'd help us track down any remaining
issues with the new code, and so were important enough to include here.

Bjorn Helgaas (11):
      resources: add interfaces that return conflict information
      PCI: for address space collisions, show conflicting resource
      PCI: break out primary/secondary/subordinate for readability
      PCI: make disabled window printk style match the enabled ones
      PCI: print resources consistently with %pR
      PCI: complain about devices that seem to be broken
      PCI: don't say we claimed a resource if we failed
      x86/PCI: remove redundant warnings
      frv/PCI: remove redundant warnings
      x86/PCI: for host bridge address space collisions, show conflicting resource
      x86/PCI: truncate _CRS windows with _LEN > _MAX - _MIN + 1

Clemens Ladisch (1):
      PCI quirk: RS780/RS880: work around missing MSI initialization

Dean Nelson (3):
      PCI: fix return value from pcix_get_max_mmrbc()
      PCI: fix access of PCI_X_CMD by pcix get and set mmrbc functions
      PCI: cleanup error return for pcix get and set mmrbc functions

Matthew Wilcox (1):
      PCI quirk: Disable MSI on VIA K8T890 systems

Paul Mundt (1):
      PCI: kill off pci_register_set_vga_state() symbol export.

Tim Yamin (1):
      PCI quirk: only apply CX700 PCI bus parking quirk if external VT6212L is present

 arch/frv/mb93090-mb00/pci-frv.c         |    4 +--
 arch/x86/pci/acpi.c                     |   22 +++++++++--
 arch/x86/pci/i386.c                     |    5 ---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    8 +----
 drivers/pci/hotplug/pciehp_hpc.c        |    5 +--
 drivers/pci/ioapic.c                    |    9 ++---
 drivers/pci/pci.c                       |   44 ++++++++++------------
 drivers/pci/probe.c                     |   53 +++++++++++++++++----------
 drivers/pci/quirks.c                    |   59 ++++++++++++++++++++++++++++---
 drivers/pci/setup-res.c                 |   14 ++++---
 drivers/pcmcia/rsrc_nonstatic.c         |   12 ++----
 include/linux/ioport.h                  |    2 +
 kernel/resource.c                       |   44 +++++++++++++++++++----
 13 files changed, 184 insertions(+), 97 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
