Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2AUKI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:08:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22170 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2AUKIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:08:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/21] PCI : bridge resource reallocation patchset
Date: Sat, 21 Jan 2012 02:08:16 -0800
Message-Id: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EB1.0012,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a181193: PCI: only enable pci realloc when SRIOV bar is not assigned
6662c73: PCI: Make pci bridge reallocating enabled/disabled
1a60212: PCI: Retry on type IORESOURCE_IO allocation.
59e4fd4: PCI: Fix cardbus bridge resources as optional size handling
daa08ff: PCI: Disable cardbus bridge MEM1 pref CTL
e11dc0e: PCI: remove add_to_failed_list()
11af29c: PCI: add debug print out for add_size
6a30c7b: PCI: Change free_list() to function
e5aa050: PCI: Rename dev_res_x to add_res or fail_res
ff503cf: PCI: Merge pci_dev_resource_x and pci_dev_resource
2874630: PCI: Replace resource_list with generic list
8eedd1e: PCI: Move struct resource_list to setup-bus.c
23a6d3e: PCI: Move pdev_sort_resources() to setup-bus.c
93acbd6: PCI: Fixing multiple retrying with pci resource optional resources allocation under multi bridges
7f5dac3: PCI: Make pci_rescan_bus handle add_list
18dd9be: PCI: Make rescan bus could increase bridge resource size if needed
52e0afc: PCI: Using add_list in pcie hotplug path.
2b6542d: PCI: Try to assign required+option size at first
4beb962: PCI: Move get_res_add_size() early
8cb9020: PCI: Make add_to_list() return status
8535f21: PCI : Calculate right add_size

those patches will fix optional resource size pass over parent bus problem.

and try allocate request + optional resource at first, and then if failed will
fall back to get requested at first then try to expand to optional one.

at last will try auto detect if we need to realloc bridge resource.

Also replace local resource_list and resource_list_x with generic list.

or get from

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci2

Thanks

Yinghai

 Documentation/kernel-parameters.txt |    7 +-
 drivers/pci/pci-sysfs.c             |    5 +-
 drivers/pci/pci.c                   |    4 +-
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/probe.c                 |   22 +-
 drivers/pci/setup-bus.c             |  629 ++++++++++++++++++++++++-----------
 drivers/pci/setup-res.c             |   52 +---
 include/linux/ioport.h              |    6 -
 include/linux/pci.h                 |    2 +-
 9 files changed, 451 insertions(+), 278 deletions(-)




