Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1HSQR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:17:58 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57959 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756173Ab1HSQRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:17:54 -0400
Date: Fri, 19 Aug 2011 09:17:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20110819091749.091dd1cb@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
5c80c71b9a0ec518b4b58d2a61de01a04f4a4453:

  Merge branch 'for-linus' of
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
  (2011-08-18 14:20:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 ..BRANCH.NOT.VERIFIED..

I just pushed the OF fix and should have sent it earlier this week so
it's still mirroring out.  It's a trivial fix so I hope you don't mind
it missing out on the normal linux-next soak time.

The rest of the changes are mostly related to the now hidden resource
re-allocation code, along with a good couple from Jon to better handle
PCIe parameters (this one has been going through a lot of review and
testing, but I can move it over to my -next tree if you don't think
it's appropriate).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

David Daney (1):
      PCI: OF: Don't crash when bridge parent is NULL.

Jon Mason (2):
      PCI: Set PCI-E Max Payload Size on fabric
      PCI: export pcie_bus_configure_settings symbol

Ram Pai (3):
      PCI : ability to relocate assigned pci-resources
      PCI: make cardbus-bridge resources optional
      PCI: code and comments cleanup

Yinghai Lu (2):
      PCI: honor child buses add_size in hot plug configuration
      PCI: make SRIOV resources optional

 arch/x86/pci/acpi.c              |    9 ++
 drivers/pci/hotplug/pcihp_slot.c |   45 +----------
 drivers/pci/of.c                 |    2 +-
 drivers/pci/pci.c                |   67 +++++++++++++++
 drivers/pci/pci.h                |    4 +
 drivers/pci/probe.c              |  146 +++++++++++++++++++++++++++++++++ 
 drivers/pci/setup-bus.c          |  166 ++++++++++++++++++++++++++-----------
 drivers/pci/setup-res.c          |  152 ++++++++++++++++++++++-------------
 include/linux/pci.h              |   16 ++++-
9 files changed, 454 insertions(+), 153 deletions(-)
