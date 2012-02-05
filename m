Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2BELQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:16:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42681 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2BELQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:16:07 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH v5 0/3] virtio-scsi driver
Date: Sun,  5 Feb 2012 12:15:59 +0100
Message-Id: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first implementation of the virtio-scsi driver, a virtual
HBA that will be supported by KVM.  It implements a subset of the spec,
in particular it does not implement asynchronous notifications for either
LUN reset/removal/addition or CD-ROM media events, but it is already
functional and usable.

Other matching bits:

- spec at http://people.redhat.com/pbonzini/virtio-spec.pdf

- QEMU implementation at git://github.com/bonzini/qemu.git,
  branch virtio-scsi

Please review.  Getting this in 3.3 is starting to look like wishful thinking,
but the possibility of regressions is obviously zero so I'm still dreaming.
Otherwise, that would be 3.4.

Paolo Bonzini (3):
  virtio-scsi: first version
  virtio-scsi: add error handling
  virtio-scsi: add power management support

v4->v5: change virtio id from 7 to 8

v3->v4: renamed VIRTIO_SCSI_S_UNDERRUN to VIRTIO_SCSI_S_OVERRUN;
    fixed 32-bit compilation; added power management support;
    adjusted calls to virtqueue_add_buf

 drivers/scsi/Kconfig        |    8 +
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/virtio_scsi.c  |  594 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_ids.h  |    1 +
 include/linux/virtio_scsi.h |  114 +++++++++
 5 files changed, 718 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/virtio_scsi.c
 create mode 100644 include/linux/virtio_scsi.h

