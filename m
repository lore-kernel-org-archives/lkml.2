Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3AIQp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:45:56 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53070 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3AIQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:45:55 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com
Subject: [PATCHSET] block: improve tracepoints
Date: Wed,  9 Jan 2013 08:45:03 -0800
Message-Id: <1357749908-16562-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

This patchset fixes/improves bio_complete TP so that block layer
proper triggers for all completing bios instead of stackign drivers
triggering them manually and adds more buffer / block / writeback TPs.
These improve visibility in general and are already in use in google.

This patchset contains the following five patches.

 0001-block-add-missing-block_bio_complete-tracepoint.patch
 0002-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
 0003-buffer-make-touch_buffer-an-exported-function.patch
 0004-block-add-block_touch_buffer-tracepoint.patch
 0005-writeback-add-more-tracepoints.patch

It's based on top of v3.8-rc2 and also available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-tps

diffstat follows.  Thanks.

 block/blk-core.c                 |    5 -
 drivers/md/dm.c                  |    1 
 drivers/md/raid5.c               |   11 ---
 fs/bio.c                         |    2 
 fs/buffer.c                      |    8 ++
 fs/fs-writeback.c                |   17 ++++
 include/linux/blktrace_api.h     |    1 
 include/linux/buffer_head.h      |    2 
 include/trace/events/block.h     |   78 ++++++++++++++++++----
 include/trace/events/writeback.h |  135 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/blktrace.c          |   28 +++++++-
 mm/page-writeback.c              |    2 
 12 files changed, 255 insertions(+), 35 deletions(-)

--
tejun
