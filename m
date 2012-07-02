Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2GBNUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:20:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37954 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GBNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:20:33 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: snitzer@redhat.com, david@fromorbit.com, dm-devel@redhat.com,
        xfs@oss.sgi.com, hch@lst.de, martin.petersen@oracle.com,
        axboe@kernel.dk
Subject: [PATCH v2 1/3] block: add sysfs entry for discard_alignment
Date: Mon,  2 Jul 2012 15:20:23 +0200
Message-Id: <1341235225-27551-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patches will actually use the alignment, expose it in sysfs
for ease of debugging.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-sysfs.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index aa41b47..95e919c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -146,6 +146,11 @@ static ssize_t queue_io_opt_show(struct request_queue *q, char *page)
 	return queue_var_show(queue_io_opt(q), page);
 }
 
+static ssize_t queue_discard_alignment_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.discard_alignment, page);
+}
+
 static ssize_t queue_discard_granularity_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->limits.discard_granularity, page);
@@ -343,6 +348,11 @@ static struct queue_sysfs_entry queue_io_opt_entry = {
 	.show = queue_io_opt_show,
 };
 
+static struct queue_sysfs_entry queue_discard_alignment_entry = {
+	.attr = {.name = "discard_alignment", .mode = S_IRUGO },
+	.show = queue_discard_alignment_show,
+};
+
 static struct queue_sysfs_entry queue_discard_granularity_entry = {
 	.attr = {.name = "discard_granularity", .mode = S_IRUGO },
 	.show = queue_discard_granularity_show,
@@ -403,6 +413,7 @@ static struct attribute *default_attrs[] = {
 	&queue_io_min_entry.attr,
 	&queue_io_opt_entry.attr,
 	&queue_discard_granularity_entry.attr,
+	&queue_discard_alignment_entry.attr,
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_nonrot_entry.attr,
-- 
1.7.1


