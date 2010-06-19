Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0FSAbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 20:31:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:2783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0FSAbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 20:31:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=mMuDJhckpPnhC7OBwiLMfjRWX5rPXauMAWfpy1zTTGw3O0x2CyJUFmqLF59pARbNM
	RotBJRJYeMIGQrfIBdaBw==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Cc: jack@suse.cz, akpm@linux-foundation.org, david@fromorbit.com, hch@lst.de,
       axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 0/3] writeback visibility
Date: Fri, 18 Jun 2010 17:30:12 -0700
Message-Id: <1276907415-504-1-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging writeback issues and tuning an application's writeback activity is
easier when the activity is visible.  With large clusters, classifying
and root causing writeback problems has been a big headache. This patch
series contains a series of patches that our team has been using to start
getting a handle on writeback behaviour. These changes should be helpful
for single system maintainers also. It's still a big headache.

Once these changes are reviewed I will make sure the Documentation files
are updated, but I expect some back and forth first.

Michael Rubin (3):
  writeback: Creating /sys/kernel/mm/writeback/writeback
  writeback: per bdi monitoring
  writeback: tracking subsystems causing writeback

 drivers/base/node.c         |   14 +++++
 fs/buffer.c                 |    2 +-
 fs/fs-writeback.c           |   28 +++++++--
 fs/nilfs2/segment.c         |    4 +-
 fs/sync.c                   |    2 +-
 include/linux/backing-dev.h |    9 +++
 include/linux/mmzone.h      |    2 +
 include/linux/writeback.h   |   50 +++++++++++++++-
 mm/backing-dev.c            |  137 ++++++++++++++++++++++---------------------
 mm/mm_init.c                |  122 ++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |   18 ++++--
 mm/vmscan.c                 |    3 +-
 mm/vmstat.c                 |    2 +
 13 files changed, 311 insertions(+), 82 deletions(-)

