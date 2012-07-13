Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2GMIyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2GMIyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:54:08 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Moyer <jmoyer@redhat.com>, kvm@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RESEND 0/5] Add vhost-blk support
Date: Fri, 13 Jul 2012 16:55:06 +0800
Message-Id: <1342169711-12386-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

[I am resending to fix the broken thread in the previous one.]

This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
gives about 5% to 15% performance improvement.

Asias He (5):
  aio: Export symbols and struct kiocb_batch for in kernel aio usage
  eventfd: Export symbol eventfd_file_create()
  vhost: Make vhost a separate module
  vhost-net: Use VHOST_NET_FEATURES for vhost-net
  vhost-blk: Add vhost-blk support

 drivers/vhost/Kconfig  |   20 +-
 drivers/vhost/Makefile |    6 +-
 drivers/vhost/blk.c    |  600 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/net.c    |    4 +-
 drivers/vhost/test.c   |    4 +-
 drivers/vhost/vhost.c  |   48 ++++
 drivers/vhost/vhost.h  |   18 +-
 fs/aio.c               |   37 ++-
 fs/eventfd.c           |    1 +
 include/linux/aio.h    |   21 ++
 include/linux/vhost.h  |    3 +
 11 files changed, 731 insertions(+), 31 deletions(-)
 create mode 100644 drivers/vhost/blk.c

-- 
1.7.10.4

