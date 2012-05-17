Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967238Ab2EQPrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:47:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:21754 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2EQPrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144446754"
From: Lin Ming <ming.m.lin@intel.com>
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>,
        Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC v2 PATCH 0/4]: block layer runtime pm
Date: Thu, 17 May 2012 23:48:02 +0800
Message-Id: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2

Here are the RFC v2 patches that try to implement the ideas discussed.
And it's a workable version now.
Welcome to give it a try.

The test steps, for example

# ls -l /sys/block/sda
/sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda

# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/power/control
# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control

Then you'll see sda is suspended after 10secs idle.

# cat /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/runtime_status
suspended

And if you do some IO, it will resume immediately.

v2:
- remove queue idle timer, use runtime pm core's auto suspend

Lin Ming (4):
      block: add a flag to identify PM request
      block: add queue runtime pm callbacks
      block: implement block layer runtime pm
      [SCSI] sd: change to auto suspend mode

 block/blk-core.c           |   12 +++++++
 block/blk-settings.c       |    8 +++++
 block/elevator.c           |    9 +++++
 drivers/scsi/scsi_lib.c    |   25 +++++++++++++--
 drivers/scsi/scsi_pm.c     |    7 ++--
 drivers/scsi/sd.c          |   72 ++++++++++++++++++++++++++++++++++++--------
 include/linux/blk_types.h  |    2 +
 include/linux/blkdev.h     |    7 ++++
 include/scsi/scsi_device.h |    4 ++
 9 files changed, 127 insertions(+), 19 deletions(-)
