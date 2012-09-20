Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2ITHV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:21:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2ITHV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:21:56 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/2] ARM: pci: Prepare for Tegra PCIe controller driver
Date: Thu, 20 Sep 2012 09:21:48 +0200
Message-Id: <1348125710-28726-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:VritkSSrmpdf1lDjFtBEYaoFxsDTDTJ3Ggu0XwcGqKo
 bHmefTHqxfU49QmW2mxzarCXXSgFFfFACTIcAn3S+4sTpUqOMO
 39uKtzFLA5CrI5oODw+Y45MkzcZgzOxNt9rjCPCdVCe0BrB59R
 p2MniH7efohazrIAuiYu1Sq/ahFpGtC3+TyS2WA6J5vYq1h6aw
 xtUy8r548c5y1q9eiYbI+L1aFPA35EJuBv6wu8XgQtBQF3yHHp
 lmy8vm+Lrdyzi7re8KLnqQ8iinfVVb8ptT7LgoAaPKITN9X3Jt
 wpJlIY2KeUbL6XFAurJ1dJZEgph74ZfGYk4rGU7yT1E/pEnPuM
 Inuy++qEcTrCXpVozOKYwDyDQI6/UIU5Dc595Y/4R6EHqGS/WJ
 MDyyfmPCVC32wVa1xFUNUMFJM0hHzJB3XbcUMjO494pGZ7f9ds
 1ReQ1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

These are two patches I've been carrying in a larger series that
converts the Tegra PCIe controller driver to a proper platform driver.
Since the complete series didn't get much feedback, I've begun to post
smaller subsets in an effort to get them merged more easily.

The first patch in this series removes the __init annotations from the
pci_common_init() function (and pcibios_init_hw() and pcibios_swizzle()
because they are called from the former) to make sure that they stay
around after the init stage. This is required because the Tegra driver
depends on regulators that become available only very late during boot
and uses deferred probing to handle this situation. It turned out that
this postpones the PCI bus initialization until after init, thus this
patch.

The second patch is used to pass per-controller or per-host-bridge data
to the driver, such that it can be associated with the corresponding
bus. This is also required by the Tegra driver in order to pass a
driver-private structure to the PCI bus (or more precisely the
pci_sys_data structure associated with a bus). It is subsequently used
to obtain the root port private data given the corresponding PCI bus.

Thierry

Thierry Reding (2):
  ARM: pci: Keep pci_common_init() around after init
  ARM: pci: Allow passing per-controller private data

 arch/arm/include/asm/mach/pci.h | 1 +
 arch/arm/kernel/bios32.c        | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.7.12

