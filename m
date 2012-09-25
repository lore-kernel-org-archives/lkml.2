Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2IYGJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:09:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2IYGJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:09:26 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, hdk@igel.co.jp,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [v2 PATCH 0/2] Add UIO device supporting dynamic memory allocation
Date: Tue, 25 Sep 2012 15:09:10 +0900
Message-Id: <1348553352-14334-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I've been using this UIO driver for allocation/deallocation
of memory regions through an IOMMU via the dma-mapping API, but
it seems that it would be more generally useful for userspace drivers
to access CMA memory regions. I've kept all dynamic memory handling in
the specific device driver.

The number and size of the dynamically allocatable regions is defined
statically in the device platform data, and the actually memory is
allocated and deallocated when the device is opened/closed.

Details of the dynamically allocated regions are available from sysfs in
exactly the same was as for static regions. The total number of
dynamic and static regions combined cannot exceed MAX_UIO_MAPS.

Changes from v1/RFC

* Add driver documentation to UIO HOWTO 
* Remove sh7372 specific example code

Damian Hobson-Garcia (2):
  Add new uio device for dynamic memory allocation
  Add uio_dmem_genirq description to UIO documentation

 Documentation/DocBook/uio-howto.tmpl          |   55 ++++
 drivers/uio/Kconfig                           |   16 ++
 drivers/uio/Makefile                          |    1 +
 drivers/uio/uio_dmem_genirq.c                 |  354 +++++++++++++++++++++++++
 include/linux/platform_data/uio_dmem_genirq.h |   26 ++
 6 files changed, 466 insertions(+), 5 deletions(-)
 create mode 100644 drivers/uio/uio_dmem_genirq.c
 create mode 100644 include/linux/platform_data/uio_dmem_genirq.h

-- 
1.7.5.4

