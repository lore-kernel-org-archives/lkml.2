Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2INVLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:11:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2INVLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:11:23 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: pci: Prepare for Tegra PCIe controller driver
Date: Fri, 14 Sep 2012 23:11:16 +0200
Message-Id: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:OHpeKzaADJDvbV6yAdwbILBGNveK16zj2iroHfC+j1z
 xReUxHne5snNqL4qWjSGz3uaXIXS8jfYR8GJbvqyJpwYQjyCDn
 oJXxGavyQDQT2pyf+k9fTJUr2Z7AtD4c9dz/zE2tjWL6pxisLV
 +dQYkV/H+6MlwlHWF+247zyYWWowLBv/AXE7YF2m0f9EVy9re3
 hrdo33Hzi6pgP72r7vOxmjZid9yogANrfIMHWEzRFx8qfKeb83
 qg7sD4q972jJ1X6jD6OdM5s7w62J74b4nox6SuJ7pHokgLJQvl
 kOSy+bYNJqmrHH9KMAie23kh3Zh4I8ZJJL/v3vuXzyRh2ZnNzM
 cdNPP4f4KPHoXdJaWPgoOMPpj4YSh3aFGb9aXycuEtT1D7ZXUb
 KSVQaaI5rGx3OSL+brfb+hXXCcQqpHVsoNuJQ3LhxUbgNSMtpn
 IKVWk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

These are two patches I've been carrying in a larger series that
converts the Tegra PCIe controller driver to a proper platform driver.
Since the complete series didn't get much feedback, I've begun to post
smaller subsets in an effort to get them merged more easily.

The first patch in this series converts the __init annotations for
pci_common_init() (and pcibios_init_hw() because it is called from the
former) to __devinit to make sure that they stay around after the init
stage. This is required because the Tegra driver depends on regulators
that become available only very late during boot and uses deferred
probing to handle this situation. It turned out that this postpones the
PCI bus initialization until after init, thus this patch.

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
 arch/arm/kernel/bios32.c        | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
1.7.12

