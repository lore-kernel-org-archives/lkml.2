Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1CJHAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:00:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60006 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1CJHAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=RDGfrONV54GyUH5Nrxlz8BbABi9s2KflcUyQ8AM99z+s/Q7WIVCz81939qdX5QOMj+
         f+FJbk/GzzGCcAFCRMzFIjTZwX0qgApFFlWfGPsiBAuUsbgrUL2veYcXjzl46NuYnumi
         lV6evusx7dWd3+4afxbY71kNJr1nRP+wB/VWU=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        mst@redhat.com
Date: Thu, 10 Mar 2011 16:05:41 +0900
Message-Id: <20110310070541.27327.52089.sendpatchset@t400s>
Subject: [PATCH 00/02] virtio: Virtio platform driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio: Virtio platform driver

[PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
[PATCH 02/02] virtio: Add virtio platform driver

These patches add a virtio platform driver to the Linux kernel. This
platform driver has the same role as the virtio_pci driver, but instead
of building on top of emulated PCI this driver is making use of the
platform bus together with driver specific callbacks.

The virtio platform driver can be seen as a reusable implementation of
the lguest virtio driver - in fact, most code is just taken directly
from lguest_device.c and reworked to fit the platform device driver
abstraction. The first patch breaks out code that can be shared between
lguest and the virtio platform driver.

This code has been used to implement a mailbox interface between the
two processor cores included in the sh7372 SoC. The sh7372 contains
one ARM Cortex-A8 and one SH4AL-DSP core, and in the prototype two
Linux kernels are running in parallel on the same chip. Virtio serves
as a communication link between the two cores.

Tested on the SH architecture, but should work on any architecture.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/x86/lguest/Kconfig          |    1 
 drivers/lguest/lguest_device.c   |  209 ----------------------------
 drivers/virtio/Kconfig           |   13 +
 drivers/virtio/Makefile          |    2 
 drivers/virtio/virtio_lguest.c   |  205 ++++++++++++++++++++++++++++
 drivers/virtio/virtio_platform.c |  282 +++++++++++++++++++++++++++++++++++++++
 include/linux/lguest.h           |    1 
 include/linux/lguest_device.h    |   46 ++++++
 include/linux/virtio_platform.h  |   12 +
 9 files changed, 564 insertions(+), 207 deletions(-)
