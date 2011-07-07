Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1GGTKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:10:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:43797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab1GGTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] cleanup patches for arch/x86/pci/xen.c (Xen PCI) for 3.1 (v1)
Date: Thu,  7 Jul 2011 15:08:16 -0400
Message-Id: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E160438.00D2:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 07 Jul 2011 19:08:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proposing these ten patches for 3.1. The goal of these patches is to clean
up the Xen PCI glue code in xen.c and squash some common code together.

The patches are also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/pci.cleanups.v1

I've tested them on PV, PV + PCI, PVonHVM, and PV initial domain without
encountering any regressions.

 arch/x86/include/asm/xen/pci.h |    5 +-
 arch/x86/pci/xen.c             |  371 +++++++++++++++++-----------------------
 drivers/xen/events.c           |    7 +-
 include/xen/events.h           |    2 -
 4 files changed, 165 insertions(+), 220 deletions(-)

Konrad Rzeszutek Wilk (10):
      xen/pci: Shuffle code around.
      xen/pci: Update comments and fix empty spaces.
      xen/pci: Provide #ifdef CONFIG_ACPI to easy code squashing.
      xen/pci: In xen_register_pirq bind the GSI to the IRQ after the hypercall.
      xen/pci: Use the xen_register_pirq for HVM and initial domain users
      xen/pci: Squash pci_xen_initial_domain and xen_setup_pirqs together.
      xen/pci: Move the allocation of IRQs when there are no IOAPIC's to the end
      xen/pci: Retire unnecessary #ifdef CONFIG_ACPI
      xen/pci: Remove 'xen_allocate_pirq_gsi'.
      xen/pci: Use 'acpi_gsi_to_irq' value unconditionally.

