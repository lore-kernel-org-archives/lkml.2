Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2BEGzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:55:36 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:46715 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2BEGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:55:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 0/9] PCI : bridge resource reallocation patchset -- followup
Date: Sat,  4 Feb 2012 22:54:59 -0800
Message-Id: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F2E27DE.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c16c722: PCI: only enable pci realloc when SRIOV bar is not assigned
868faa5: PCI: print out suggestion about using pci=realloc
ace6e3c: PCI: Make pci bridge reallocating enabled/disabled
3cf1011: PCI: Retry on type IORESOURCE_IO allocation.
b6d30ee: PCI: Skip reset cardbus assigned resource during pci bus rescan
2bc1cf0: PCI: Fix cardbus bridge resources as optional size handling
e6c495b: PCI: Disable cardbus bridge MEM1 pref CTL
d1e2d75: PCI: Fix /sys warning when sriov enabled card is hot removed
29834f2: pci: Fix pci cardbus removal

are left over after Jesse pickup more of them.
it will try to auto detect if need to use pci=realloc, and print out suggestion.

including fixing some pci carbus handling.

could get from

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci3

-v2: add two patches before, it will fix pci cardbus removal, and srov removal
	warning
	the first one should be with v3.3.

Thanks

Yinghai

 Documentation/kernel-parameters.txt |    8 ++-
 drivers/pci/iov.c                   |    7 ++-
 drivers/pci/pci.c                   |    4 +-
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/remove.c                |   28 +++++--
 drivers/pci/setup-bus.c             |  159 +++++++++++++++++++++++++----------
 6 files changed, 153 insertions(+), 55 deletions(-)
