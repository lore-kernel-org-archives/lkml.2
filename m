Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2ILFaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:30:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2ILFaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:30:02 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: horms@verge.net.au, magnus.damm@gmail.com
Cc: hjk@hansjkoch.de, linux-sh@vger.kernel.org, hdk@igel.co.jp,
        linux-kernel@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [RFC PATCH 0/2] Add UIO device supporting dynamic memory allocation
Date: Wed, 12 Sep 2012 14:29:43 +0900
Message-Id: <1347427785-9767-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting: I realized that this series should have gone out to a broader list.
My apologies to those who those who will recieve a duplicate post. 

Hello all,

I've been using this UIO driver for allocation/deallocation
of memory regions through an IOMMU via the dma-mapping API, but
it seems that it would be more generally useful for userspace drivers
to access CMA memory regions. I don't know if it's useful to try to add
this functionality into the core uio driver or not, so for now I've kept
all dynamic memory handling in the specific device driver.

The number and size of the dynamically allocatable regions is defined
statically in the device platform data, and the actually memory is
allocated and deallocated when the device is opened/closed.

Details of the dynamically allocated regions are available from sysfs in
exactly the same was as for static regions. The total number of
dynamic and static regions combined cannot exceed MAX_UIO_MAPS.

Any comments, especially with regard to exposing the dma-mapping API to
userspace in this way, would be greatly appreciated.

Damian Hobson-Garcia (2):
  Add new uio device for dynamic memory allocation
  ARM: shmobile: sh7372: Change VPU UIO to uio_dmem_genirq

 arch/arm/mach-shmobile/setup-sh7372.c         |   19 +-
 drivers/uio/Kconfig                           |   16 ++
 drivers/uio/Makefile                          |    1 +
 drivers/uio/uio_dmem_genirq.c                 |  356 +++++++++++++++++++++++++
 include/linux/platform_data/uio_dmem_genirq.h |   26 ++
 5 files changed, 413 insertions(+), 5 deletions(-)
 create mode 100644 drivers/uio/uio_dmem_genirq.c
 create mode 100644 include/linux/platform_data/uio_dmem_genirq.h

-- 
1.7.5.4

