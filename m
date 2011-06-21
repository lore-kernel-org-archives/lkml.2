Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1FUKSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:18:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49429 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab1FUKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=tRpe4JS9m37sU62aqzMgFYbDwToi8iaYnjFwOMgUf1j1RRcyKxuAoeYNjT2ZMis5Jl
         Mak29tC2PNMegWt+rNtip7yBR2WQvS9vkEc9AwwVqawbgEZETHlUNRyooeGWK9ePz05K
         303VpmC0I+Iee1seQSGDvopYu1lBNgGSSnVzA=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, linux-sh@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, horms@verge.net.au,
        mst@redhat.com, Magnus Damm <magnus.damm@gmail.com>,
        iws@ovro.caltech.edu
Date: Tue, 21 Jun 2011 19:26:05 +0900
Message-Id: <20110621102605.1382.90232.sendpatchset@t400s>
Subject: [PATCH 00/02][RESEND] virtio: Virtio platform driver
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

These patches have not been updated since last time they were posted
20110310, but are known to apply and compile against linux-3.0-rc.

For a full source release, have a look at SH Core Linux 20110317:
http://www.spinics.net/lists/linux-sh/msg07188.html

The SH kernel patch shows how to make use of the virtio platform driver.

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
