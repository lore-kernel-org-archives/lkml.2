Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2GZN22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:28:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49739 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2GZN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:28:26 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, JBottomley@parallels.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/2] virtio-scsi fixes for 3.6
Date: Thu, 26 Jul 2012 15:28:06 +0200
Message-Id: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

patch 1 fixes scanning of LUNs whose number is greater than 255.  QEMU
passes a max_lun of 16383 (because it uses SAM numbering) but in Linux
it must become 32768 (because LUNs above 255 are "relocated" to 16640).
Patch 2 is a resubmission of the patch for online resizing of virtio-scsi
LUNs, which needs to be rebased.

LUNs above 255 now work for all of scanning, hotplug, hotunplug and
resize.

Thanks,

Paolo

Paolo Bonzini (2):
  virtio-scsi: fix LUNs greater than 255
  virtio-scsi: support online resizing of disks

 drivers/scsi/virtio_scsi.c  |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/virtio_scsi.h |    2 ++
 2 files changed, 37 insertions(+), 2 deletions(-)

