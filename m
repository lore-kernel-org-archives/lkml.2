Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab2EWGex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:34:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34436 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2EWGev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <ying6hai@kernel.org>
Subject: [PATCH 00/11] PCI: resource allocation related
Date: Tue, 22 May 2012 23:34:26 -0700
Message-Id: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <ying6hai@kernel.org>

This patchset will try to make allocation to find suitable assignement.
1. will try to assign 64 bit resource above 4g at first.
2. will find space that is matched with needed size
3. will put resource in right location to leave more big alignment with left blank resource
4. will try option rom BAR as optional resources.

Could be found:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-res-alloc

and it is based on pci for-3.6 branch.

Thanks

Yinghai Lu

Yinghai Lu (11):
  PCI: Should add children device res to fail list
  PCI: Try to allocate mem64 above 4G at first
  intel-gtt: Read 64bit for gmar_bus_addr
  PCI: Make sure assign same align with large size resource at first
  resources: Split out __allocate_resource()
  resource: make find_resource could return just fit resource
  PCI: Don't allocate small resource in big empty space.
  resource: only return range with needed align
  PCI: Add is_pci_iov_resource_idx()
  PCI: Sort unassigned resources with correct alignment
  PCI: Treat ROM resource as optional during assigning.

 drivers/char/agp/intel-gtt.c |   14 ++++--
 drivers/pci/bus.c            |   38 +++++++++++---
 drivers/pci/setup-bus.c      |   78 ++++++++++++++++++-----------
 drivers/pci/setup-res.c      |   28 +++++++----
 include/linux/ioport.h       |    8 +++
 include/linux/pci.h          |   23 ++++++++
 kernel/resource.c            |  114 ++++++++++++++++++++++++++++++++++++++---
 7 files changed, 243 insertions(+), 60 deletions(-)

-- 
1.7.7

