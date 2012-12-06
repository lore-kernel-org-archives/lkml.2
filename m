Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947017Ab2LFTfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:35:39 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59896 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556Ab2LFTfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:35:37 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
Subject: [RFC 0/5] remoteproc: Support bi-directional vdev config space.
Date: Thu,  6 Dec 2012 20:35:19 +0100
Message-Id: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur@brendeland.net>

This patch-set adds support for shared resource table between
Linux kernel and remote devices. 
Features:
1. dynamically-allocated address of the vrings can be communicated
2. vdev statuses can be communicated
3. virtio config space becomes bi-directional
4. virtio feature negotiation is two-way 

This is done by loading firmware once. First pass parsing of the
resource table will allocate carveouts. Then the firmware
is loaded into device memory. After this the address
of the resource table in shared memory is located. This address
is used in the second pass of parsing of the resource
table. This time the virtio devices are created. When the
virtio device are created the virto feature bits, status,
and configuration-space is shared with the remote device.

NOTE: This change will probably break existing device firmware!
The device memory allocation will change. Virtio Rings are no
longer located at start of device memory. But Ring Address in
resource table is supported.

Thanks,
Sjur

Sjur Brændeland (5):
  remoteproc: Refactor function rproc_elf_find_rsc_table
  remoteproc: Add operation to find resource table in memory
  remoteproc: Add state RPROC_LOADED
  remoteproc: Load firmware to device memory once.
  remoteproc: Support virtio config space.

 drivers/remoteproc/remoteproc_core.c       |  226 ++++++++++++----------------
 drivers/remoteproc/remoteproc_debugfs.c    |    1 +
 drivers/remoteproc/remoteproc_elf_loader.c |   99 ++++++++----
 drivers/remoteproc/remoteproc_internal.h   |   13 ++
 drivers/remoteproc/remoteproc_virtio.c     |   30 +++-
 drivers/remoteproc/ste_modem_rproc.c       |   43 ++++--
 include/linux/remoteproc.h                 |    6 +-
 7 files changed, 232 insertions(+), 186 deletions(-)

-- 
1.7.9.5

