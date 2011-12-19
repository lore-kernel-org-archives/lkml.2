Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1LSMDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:03:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51839 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1LSMDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:03:20 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH v3 0/2] virtio-scsi driver
Date: Mon, 19 Dec 2011 13:03:06 +0100
Message-Id: <1324296188-3426-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first implementation of the virtio-scsi driver, a virtual
HBA that will be supported by KVM.  It implements a subset of the spec,
in particular it does not implement asynchronous notifications for either
LUN reset/removal/addition or CD-ROM media events, but it is already
functional and usable.

I waited a week for James to follow up on the thread and to get other
remarks.  I got none, so here is the patch amended after Mike Christie's
review.

Other matching bits:

- spec at http://people.redhat.com/pbonzini/virtio-spec.pdf

- QEMU implementation at git://github.com/bonzini/qemu.git,
  branch virtio-scsi

Please review.

Paolo Bonzini (2):
  virtio-scsi: first version
  virtio-scsi: add error handling

 drivers/scsi/Kconfig        |    8 +
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/virtio_scsi.c  |  551 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_scsi.h |  112 +++++++++++
 include/linux/virtio_ids.h  |    1 +
 4 files changed, 673 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/virtio_scsi.c

-- 
1.7.7.1

