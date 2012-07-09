Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2GIUcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:32:05 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48588 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2GIUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:32:01 -0400
Subject: [PATCH 0/3] PCI: P2P bridge window fixes
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel Yeisley <dan.yeisley@unisys.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Jul 2012 14:31:58 -0600
Message-ID: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes here:

1) Zero is a legal P2P bridge window base and BAR value and is likely to
occur when there is an offset between bus addresses and CPU addresses.
Stop disallowing it.

2) The Intel-specific 1K I/O window granularity for P2P bridges was
implemented in a way that precluded reassignment of the window after
FINAL quirks.  Fix that.

And also replace the sparc pci_cfg_fake_ranges() with the functionally
equivalent generic version.

---

Bjorn Helgaas (3):
      PCI: allow P2P bridge windows starting at PCI bus address zero
      PCI: reimplement P2P bridge 1K I/O windows (Intel P64H2)
      sparc/PCI: replace pci_cfg_fake_ranges() with pci_read_bridge_bases()


 arch/sparc/kernel/pci.c  |   89 +---------------------------------------------
 drivers/pci/probe.c      |   31 +++++++++-------
 drivers/pci/quirks.c     |   39 +-------------------
 drivers/pci/setup-bus.c  |   11 +++++-
 include/linux/pci.h      |    1 +
 include/linux/pci_regs.h |    3 +-
 6 files changed, 31 insertions(+), 143 deletions(-)

-- 
Bjorn
