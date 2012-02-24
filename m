Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2BXHr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:47:26 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38105 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2BXHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:47:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 00/11] PCI: quirk related clean up
Date: Thu, 23 Feb 2012 23:46:48 -0800
Message-Id: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F474089.00CF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit:
| commit 3209874a1da2c51c7325e601d9634189ee178ad6
| Author: Arjan van de Ven <arjan@infradead.org>
| Date:   Mon Jan 30 20:52:07 2012 -0800
|
|    PCI: Annotate PCI quirks in initcall_debug style

will have lots of print out for quirks when initcall_debug is specified.

It turns out most of them are not really called for the devices because
quirks itself will check class id and bail out early.

Try to put class into quirk declaration. So we could avoid dive into these
quirks.

could be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci5

4ace9ad: PCI: Use class for quirk for usb host controller fixup
cc60c7c: PCI: Use class for quirk for ti816x class fixup
85fa49c: PCI: Use class for quirk for intel e100 interrupt fixup
8e4b35b: PCI: Use class for quirk for netmos class fixup
7c4b5d6: PCI: Use class for quirk for legacy ATA NO_D3
176e7df: PCI: Use class for quirk for cardbus_legacy
c2c7107: PCI: Use class for quirk for host bridge mmio_always_on
6924d3b: PCI: Use class for quirk for pci_fixup_video
7133c84: PCI: Use class quirk for intel fix_transparent_bridge
bf9f6e6: PCI: Use class for quirk for via_no_dac
d2e6e88: PCI: Add class support in quirk handling


-v2: separate to small patches for different quirk according to Jesse.

Thanks

Yinghai

 arch/x86/kernel/pci-dma.c     |    5 ++-
 arch/x86/pci/fixup.c          |   12 +++----
 drivers/pci/quirks.c          |   61 +++++++++++++++++++++------------------
 drivers/usb/host/pci-quirks.c |    3 +-
 include/linux/pci.h           |   63 +++++++++++++++++++++++++++++++++-------
 5 files changed, 95 insertions(+), 49 deletions(-)

