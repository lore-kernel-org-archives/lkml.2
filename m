Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1JKDS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:18:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JKDS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:18:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=QtsuvoKqTjX0aoXeK8LncJ1ClLNqvvXMqF4Sb4O8/lFcOV3Idp1i9YSRLgzsml9wq
	MMJuZriSGPpckNkKp2cRA==
Subject: [RFC PATCH 00/12] Create PCI root buses with correct resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:18:24 -0600
Message-ID: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core of this series (patch 2) is due to Deng-Cheng Zhu.

The idea is that we should create PCI root buses with the correct resources,
rather than creating them with default resources and fixing them up later.
This makes the code read more naturally and prevents problems for code,
e.g., quirks, that runs between the bus creation and the fixups.

This is just an RFC because I tweaked the method of passing the root bus
resources to pci_create_bus(), I intend to extend this to a few more
architectures, and I haven't set up cross-compilers to build anything other
than x86 yet.

---

Bjorn Helgaas (12):
      PCI: add helpers for building PCI bus resource lists
      PCI: pass available resources into pci_create_bus()
      MIPS: PCI: supply root bus resources to pci_create_bus()
      x86/PCI: supply root bus resources to pci_create_bus()
      powerpc/pci: make pcibios_setup_phb_resources() static
      powerpc/pci: split PHB part out of pcibios_map_io_space()
      powerpc/pci: supply root bus resources to pci_create_bus()
      microblaze/pci: make pcibios_setup_phb_resources() static
      microblaze/pci: supply root bus resources to pci_create_bus()
      sparc/pci: supply root bus resources to pci_create_bus()
      sparc/pci: use pci_create_bus() instead of pci_scan_bus_parented()
      sparc/pci: supply root bus resources to pci_create_bus()


 arch/microblaze/include/asm/pci-bridge.h |    1 -
 arch/microblaze/pci/pci-common.c         |   29 ++++++++++++---------
 arch/mips/pci/pci.c                      |   21 ++++++++++-----
 arch/powerpc/include/asm/pci-bridge.h    |    1 -
 arch/powerpc/kernel/pci-common.c         |   27 ++++++++++++--------
 arch/powerpc/kernel/pci_64.c             |   40 +++++++++++++++--------------
 arch/sparc/kernel/leon_pci.c             |   28 ++++++++++++--------
 arch/sparc/kernel/pci.c                  |   11 +++++---
 arch/x86/pci/acpi.c                      |   41 +++++++++++++++++++-----------
 drivers/pci/bus.c                        |   30 ++++++++++++++++++----
 drivers/pci/probe.c                      |   17 ++++++++++--
 include/linux/pci.h                      |    5 +++-
 12 files changed, 158 insertions(+), 93 deletions(-)

-- 
Bjorn
