Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0I1RLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0I1RLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:11:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH] Various block throttling fixes
Date: Tue, 28 Sep 2010 13:10:55 -0400
Message-Id: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

During testing of block device throttling, I found few issues. Here are
the fixes for those issues.

[PATCH 1/4] blkio: Do not export throttle files if CONFIG_BLK_DEV_THROTTLING=n
[PATCH 2/4] blkio: deletion of a cgroup was causes oops
[PATCH 3/4] blkio: Add root group to td->tg_list
[PATCH 4/4] blkio: Recalculate the throttled bio dispatch time upon throttle limit change

Overall diff

 block/blk-cgroup.c   |  121 +++++++++++++++++++++------------------
 block/blk-cgroup.h   |   21 ++++---
 block/blk-throttle.c |  151 ++++++++++++++++++++++++++++++++++++++++++-------
 block/cfq-iosched.c  |    4 +-
 4 files changed, 207 insertions(+), 90 deletions(-)

Thanks
Vivek
