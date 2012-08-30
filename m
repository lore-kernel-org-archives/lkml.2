Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2H3S0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:26:31 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:33601 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab2H3S0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:26:30 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2 0/3] remoteproc: introduce rproc recovery
Date: Thu, 30 Aug 2012 13:26:11 -0500
Message-Id: <1346351174-28441-1-git-send-email-fernando.lugo@ti.com>
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

-Version 2
* Wait untill there is no more rproc users before realoding the FW again
  in order to make sure the recovery will work fine. As suggested by
  Sjur BRENDELAND

Fernando Guzman Lugo (3):
  remoteproc: add rproc_report_crash function to notify rproc crashes
  remoteproc: recover a remoteproc when it has crashed
  remoteproc: create debugfs entry to disable/enable recovery
    dynamically

 Documentation/remoteproc.txt             |    7 ++
 drivers/remoteproc/remoteproc_core.c     |  116 ++++++++++++++++++++++++++++--
 drivers/remoteproc/remoteproc_debugfs.c  |   83 +++++++++++++++++++++
 drivers/remoteproc/remoteproc_internal.h |    1 +
 include/linux/remoteproc.h               |   22 ++++++
 5 files changed, 222 insertions(+), 7 deletions(-)

