Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0DOFga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:36:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab0DOFg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:36:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=cPkPNCOTEarb08xY8FkUdIk3WhlXDnAjuv6sYlVmI9STCfocWuCWO/is6y1v7TAa9
	Uq9+PQHQFoFEA5zqRd49Q==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] blkio: Fix linux-next build failure after merge of block tree
To: jens.axboe@oracle.com, sfr@canb.auug.org.au
Cc: guijianfeng@cn.fujitsu.com, vgoyal@redhat.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 14 Apr 2010 22:36:00 -0700
Message-ID: <20100415053543.15190.98919.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After merging the block tree, 20100414's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "get_gendisk" [block/blk-cgroup.ko] undefined!
ERROR: "sched_clock" [block/blk-cgroup.ko] undefined!

This happens because the two symbols aren't exported and hence not available
when blk-cgroup code is built as a module. I've tried to stay consistent with
the use of EXPORT_SYMBOL or EXPORT_SYMBOL_GPL with the other symbols in the
respective files.

Signed-off-by: Divyesh Shah <dpshah@google.com>
---

 block/genhd.c        |    1 +
 kernel/sched_clock.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index d13ba76..154b5f8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -596,6 +596,7 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
 
 	return disk;
 }
+EXPORT_SYMBOL(get_gendisk);
 
 /**
  * bdget_disk - do bdget() by gendisk and partition number
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 5b49613..906a0f7 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -41,6 +41,7 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
 }
+EXPORT_SYMBOL_GPL(sched_clock);
 
 static __read_mostly int sched_clock_running;
 

