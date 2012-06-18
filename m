Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2FRGwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2FRGwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:52:24 -0400
From: Asias He <asias@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Asias He <asias@redhat.com>
Subject: [PATCH v2 0/3] Improve virtio-blk performance
Date: Mon, 18 Jun 2012 14:53:07 +0800
Message-Id: <1340002390-3950-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements bio-based IO path for virito-blk to improve
performance.

Fio test shows it gives, 28%, 24%, 21%, 16% IOPS boost and 32%, 17%, 21%, 16%
latency improvement for sequential read/write, random read/write respectively.

Asias He (3):
  block: Introduce __blk_segment_map_sg() helper
  block: Add blk_bio_map_sg() helper
  virtio-blk: Add bio-based IO path for virtio-blk

 block/blk-merge.c          |  117 +++++++++++++++++--------
 drivers/block/virtio_blk.c |  203 +++++++++++++++++++++++++++++++++++---------
 include/linux/blkdev.h     |    2 +
 3 files changed, 247 insertions(+), 75 deletions(-)

-- 
1.7.10.2

