Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2CXWEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2CXWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 07/09] remoteproc/rpmsg: new subsystem
Date: Sat, 24 Mar 2012 22:02:46 +0000
Message-Id: <1332626568-17812-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0O45XC/YqZYdRSZY8nZhjOoIgQiQqmW06tQSMevDLBB
 GfH/wJwCimTuzAEKpH0kS6vnz8OxLJZ3Zo/tArcN1r9reMeJXC
 f0k/Z0qq+f73mZQkq+/GDWzfnGSlU2QOIw5TboQ/OQ8m7xs02x
 wLmbY7uFSGk+6DmRa74Ac+Qsu2oTkgBUIll48iyiX3+QOMQMfK
 yCULAD4RB+p0k2aDuVPl+yZIIOetJo8bhXOIlnr88v7WMxQhPl
 bHNFNG5kfM9RRSrcM2A6+DB21gQSvTqt6S/X/IDT7iY7xoJDOB
 G6+31XENUXaeGBt3XHyzQj78e54Wol90axCptDVd80DvEByV8T
 cYmiFmOGEXxPX+rfSeJ+Fl3iUXFc2gRZug+1e5ndyxVAqwMV48
 nLN+oC/dJtYrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new subsystem provides a common way to talk to secondary processors
on an SoC, e.g. a DSP, GPU or service processor, using virtio as the
transport. In the long run, it should replace a few dozen vendor
specific ways to do the same thing, which all never made it into the
upstream kernel. There is a broad agreement that rpmsg is the way to
go here and several vendors have started working on replacing their
own subsystems.

Two branches each add one virtio protocol number. Fortunately the
numbers were agreed upon in advance, so there are only context changes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "a9c3210 Merge branch
'next/rpmsg' into for-next", leading up to commit " 6458acb Merge tag
'rpmsg-fixes-and-more-for-3.4' of git://gi", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/rpmsg

Arnd Bergmann (2):
      Merge tag 'rpmsg-for-3.4' of git://git.kernel.org/.../ohad/remoteproc into next/rpmsg
      Merge branch 'next/rpmsg' into for-next

Axel Lin (1):
      rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf

Mark Asselstine (1):
      rpmsg: fix build warning when dma_addr_t is 64-bit

Mark Grosen (2):
      remoteproc: do not require an iommu
      remoteproc: avoid registering a virtio device if not supported

Ohad Ben-Cohen (28):
      remoteproc: add framework for controlling remote processors
      remoteproc: add debugfs entries
      remoteproc: create rpmsg virtio device
      remoteproc/omap: add a remoteproc driver for OMAP4
      rpmsg: add virtio-based remote processor messaging bus
      samples/rpmsg: add an rpmsg driver sample
      remoteproc: remove unused resource type
      remoteproc/omap: utilize module_platform_driver
      remoteproc: look for truncated firmware images
      remoteproc: add Kconfig menu
      rpmsg: add Kconfig menu
      remoteproc: depend on EXPERIMENTAL
      rpmsg: depend on EXPERIMENTAL
      remoteproc: don't use virtio's weak barriers
      remoteproc: bail out if firmware has different endianess
      remoteproc: s/big switch/lookup table/
      remoteproc: make sure we're parsing a 32bit firmware
      remoteproc/omap: two Kconfig fixes
      rpmsg: fix name service endpoint leak
      rpmsg: validate incoming message length before propagating
      rpmsg: fix published buffer length in rpmsg_recv_done
      remoteproc: resource table overhaul
      remoteproc: remoteproc_rpmsg -> remoteproc_virtio
      remoteproc: safer boot/shutdown order
      remoteproc: remove the single rpmsg vdev limitation
      remoteproc/omap: remove the mbox_callback limitation
      remoteproc: remove the hardcoded vring alignment
      remoteproc: cleanup resource table parsing paths

Olof Johansson (1):
      Merge tag 'rpmsg-fixes-and-more-for-3.4' of git://git.kernel.org/.../ohad/remoteproc into next/rpmsg


 Documentation/ABI/testing/sysfs-bus-rpmsg    |   75 ++
 Documentation/remoteproc.txt                 |  322 ++++++
 Documentation/rpmsg.txt                      |  293 +++++
 MAINTAINERS                                  |    7 +
 arch/arm/plat-omap/include/plat/remoteproc.h |   57 +
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/remoteproc/Kconfig                   |   28 +
 drivers/remoteproc/Makefile                  |    9 +
 drivers/remoteproc/omap_remoteproc.c         |  229 ++++
 drivers/remoteproc/omap_remoteproc.h         |   69 ++
 drivers/remoteproc/remoteproc_core.c         | 1586 ++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_debugfs.c      |  179 +++
 drivers/remoteproc/remoteproc_internal.h     |   44 +
 drivers/remoteproc/remoteproc_virtio.c       |  289 +++++
 drivers/rpmsg/Kconfig                        |   10 +
 drivers/rpmsg/Makefile                       |    1 +
 drivers/rpmsg/virtio_rpmsg_bus.c             | 1054 +++++++++++++++++
 include/linux/mod_devicetable.h              |    9 +
 include/linux/remoteproc.h                   |  478 ++++++++
 include/linux/rpmsg.h                        |  326 ++++++
 include/linux/virtio_ids.h                   |    1 +
 samples/Kconfig                              |    8 +
 samples/Makefile                             |    2 +-
 samples/rpmsg/Makefile                       |    1 +
 samples/rpmsg/rpmsg_client_sample.c          |  100 ++
 26 files changed, 5182 insertions(+), 1 deletions(-)
