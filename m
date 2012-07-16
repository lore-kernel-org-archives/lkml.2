Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2GPQGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:06:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45136 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab2GPQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:06:06 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com
Subject: [PATCH 0/2] virtio-scsi event changes for 3.6
Date: Mon, 16 Jul 2012 18:05:49 +0200
Message-Id: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

here are two more small patches for virtio-scsi.  The first fixes a
problem with the recently introduced hotplug/hot-unplug support
(happens with LUNs whose number is greater than 255).  The second
introduces support for online resizing of disks.

The host here will also send the sense code via unit attention.
This will be discarded by the high-level driver for non-removable
units.  I sent a separate patch to deal with it for removable
units.

Paolo

Paolo Bonzini (2):
  virtio-scsi: fix parsing of hotplug/hot-unplug LUN number
  virtio-scsi: support online resizing of disks

 drivers/scsi/virtio_scsi.c  |   39 ++++++++-
 include/linux/virtio_scsi.h |    2 +
 2 files changed, 38 insertions(+), 2 deletions(-)

