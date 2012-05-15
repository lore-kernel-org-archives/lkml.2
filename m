Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab2EOIsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:48:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:13901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338Ab2EOIs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140769272"
From: Lin Ming <ming.m.lin@intel.com>
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC PATCH 0/3] block layer runtime pm
Date: Tue, 15 May 2012 16:48:14 +0800
Message-Id: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2

Here are the very draft, compile tested only patches that try to
implement the ideas discussed.

I throw it out early to get feedbacks and see if I'm on the right
direction.

Lin Ming (3):
      block: add a flag to identify PM request
      block: add queue runtime pm callback
      block: add queue idle timer

 block/blk-core.c           |   25 +++++++++++++++++++++++
 block/blk-settings.c       |    6 +++++
 block/elevator.c           |   10 +++++++++
 drivers/scsi/scsi_lib.c    |   25 ++++++++++++++++++++--
 drivers/scsi/sd.c          |   47 +++++++++++++++++++++++++++++++++++++------
 include/linux/blk_types.h  |    2 +
 include/linux/blkdev.h     |    8 +++++++
 include/scsi/scsi_device.h |    4 +++
 8 files changed, 117 insertions(+), 10 deletions(-)
