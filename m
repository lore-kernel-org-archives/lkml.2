Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab0LMSD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:03:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47576 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab0LMSCL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2] Xen PCI backend driver.
Date: Mon, 13 Dec 2010 13:01:34 -0500
Message-Id: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is set of patches for the Xen PCI backend driver. Lot of driver pieces
have been reviewed in the past, but I don't recall it being sent to xen-devel.
The infrastructure parts (patches #1-#6) were posted at some point.

The Xen PCI back driver patch (#7) was squished from the git tree
(devel/xen-pciback-0.2) as some of them were just boring (supporting 2.6.18
driver to work, checkpatch), and some already posted/reviewed. The 
full tree is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pciback-0.2

.. and that is the tree I will use when asking Linus to pull the
driver.

So what is Xen PCI backend? It is a simple driver that utilizes the
ring-buffer to exchange 0xcf8 inb/outb commands from the guest to
the control domain. The backend carries out sanitized PCI configuration
reads/writes on behest of the guest. It also has some extra commands
for enabling/disabling MSI/MSI-X interrupts.

Please take a look at the patches (or even just a couple of them)
and provide feedback.

The patch set depends on stable/xenbus, which is back-port of XenBus
backend driver done by Ian Campbell. A merge of this tree along with
stable/xenbus is available as:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git master

The diffstat:

 arch/x86/include/asm/xen/pci.h                  |   16 +
 arch/x86/pci/xen.c                              |   73 ++
 drivers/xen/Kconfig                             |   65 ++
 drivers/xen/Makefile                            |    1 +
 drivers/xen/events.c                            |   68 ++-
 drivers/xen/pciback/Makefile                    |   17 +
 drivers/xen/pciback/conf_space.c                |  435 +++++++
 drivers/xen/pciback/conf_space.h                |  126 +++
 drivers/xen/pciback/conf_space_capability.c     |   66 ++
 drivers/xen/pciback/conf_space_capability.h     |   26 +
 drivers/xen/pciback/conf_space_capability_msi.c |  111 ++
 drivers/xen/pciback/conf_space_capability_pm.c  |  113 ++
 drivers/xen/pciback/conf_space_capability_vpd.c |   40 +
 drivers/xen/pciback/conf_space_header.c         |  385 +++++++
 drivers/xen/pciback/conf_space_quirks.c         |  140 +++
 drivers/xen/pciback/conf_space_quirks.h         |   35 +
 drivers/xen/pciback/controller.c                |  442 ++++++++
 drivers/xen/pciback/passthrough.c               |  178 +++
 drivers/xen/pciback/pci_stub.c                  | 1371 +++++++++++++++++++++++
 drivers/xen/pciback/pciback.h                   |  142 +++
 drivers/xen/pciback/pciback_ops.c               |  241 ++++
 drivers/xen/pciback/slot.c                      |  191 ++++
 drivers/xen/pciback/vpci.c                      |  244 ++++
 drivers/xen/pciback/xenbus.c                    |  726 ++++++++++++
 include/xen/events.h                            |    9 +
 25 files changed, 5258 insertions(+), 3 deletions(-)

