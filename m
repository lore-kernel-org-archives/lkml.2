Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab2HHXIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:08:06 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59753 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab2HHXIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:08:01 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 0/3] remoteproc: introduce rproc recovery
Date: Wed,  8 Aug 2012 18:07:41 -0500
Message-Id: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These set of patches make possible the remoteproc recover after a crash.
This is a hard recovery, that means the remoteproc is reset and it will
start from the beginning. When a crash happen all the virtio devices are
destroyed. Therefore, both rpmsg drivers and devices are gracefully
removed which also cause rproc users become 0 and the remoteproc is turned
off. After the virtio devices are destroyed the crash handler function
will read the virtio information from the firmware in order to recreate
the virtio devices that will boot the remoteproc and everything will be
functional again.

Fernando Guzman Lugo (3):
  remoteproc: add rproc_report_crash function to notify rproc crashes
  remoteproc: recover a remoteproc when it has crashed
  remoteproc: create debugfs entry to disable/enable recovery
    dynamically

 Documentation/remoteproc.txt             |    7 ++
 drivers/remoteproc/remoteproc_core.c     |  107 ++++++++++++++++++++++++++++--
 drivers/remoteproc/remoteproc_debugfs.c  |   83 +++++++++++++++++++++++
 drivers/remoteproc/remoteproc_internal.h |    1 +
 include/linux/remoteproc.h               |   20 ++++++
 5 files changed, 211 insertions(+), 7 deletions(-)

