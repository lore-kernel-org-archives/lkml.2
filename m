Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab2GLPeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947Ab2GLPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:34:09 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Asias He <asias@redhat.com>
Subject: [PATCH 0/5] Add vhost-blk support
Date: Thu, 12 Jul 2012 23:35:01 +0800
Message-Id: <1342107302-28116-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

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
 include/linux/vhost.h  |    1 +
 11 files changed, 729 insertions(+), 31 deletions(-)
 create mode 100644 drivers/vhost/blk.c

-- 
1.7.10.4

