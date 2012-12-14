Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2LNQHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:19 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:58393 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2LNQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:18 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 00/10] remoteproc: Support bi-directional vdev config space
Date: Fri, 14 Dec 2012 17:06:49 +0100
Message-Id: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- Separate vring allocation and registration
- Break up patches in smaller parts to facilitate review.
  (The patches here are perhaps too fine grained and can be squashed later).

This patch-set adds support for shared resource table between
Linux kernel and remote devices. 
Features:
- dynamically-allocated address of the vrings can be communicated
- vdev statuses can be communicated
- virtio config space becomes bi-directional
- virtio feature negotiation is two-way 

NOTE: This change may not be backwards compatible with existing
device firmware! The memory allocation order may change. Previously
the Virtio Rings were always allocated at start of the share memory
area, but with this patch-set the memory allocation are done in the
order defined resource table.

A number of changes are introduced to achieve this:
- The firmware is loaded once.
- The allocations of resources is done before registering 
  the virtio devices.
- The virtio device uses resource bits, status and config
  space in memory shared with the device.

Review comments and feedback are welcomed!

Thanks,
Sjur

Sjur Brændeland (11):
  remoteproc: Code cleanup of resource parsing
  remoteproc: Move check on firmware name to rproc_add
  remoteproc: Set vring addresses in resource table
  remoteproc: Add state RPROC_LOADED
  remoteproc: Load firmware once.
  remoteproc: Add resource entry number to callbacks
  remoteproc: Register virtio devices after vring allocation
  remoteproc: Refactor function rproc_elf_find_rsc_table
  remoteproc: Add operation to find resource table in memory
  remoteproc: Find resource table in device memory
  remoteproc: Support virtio config space.

 drivers/remoteproc/remoteproc_core.c       |  216 ++++++++++++---------------
 drivers/remoteproc/remoteproc_debugfs.c    |    1 +
 drivers/remoteproc/remoteproc_elf_loader.c |   99 +++++++++-----
 drivers/remoteproc/remoteproc_internal.h   |   13 ++
 drivers/remoteproc/remoteproc_virtio.c     |   30 ++++-
 drivers/remoteproc/ste_modem_rproc.c       |   43 ++++--
 include/linux/remoteproc.h                 |    9 +-
 7 files changed, 238 insertions(+), 173 deletions(-)

-- 
1.7.5.4

