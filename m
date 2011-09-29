Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1I2HpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:45:11 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3740 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1I2HpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:45:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 4/6] videobuf: only start streaming in poll() if so requested by the poll mask.
Date: Thu, 29 Sep 2011 09:44:10 +0200
Message-Id: <0ff6a902e6c8cf127bd60e813996d155fb2578a3.1317281827.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
References: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index de4fa4e..ffdf59c 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -1129,6 +1129,7 @@ unsigned int videobuf_poll_stream(struct file *file,
 				  struct videobuf_queue *q,
 				  poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
@@ -1137,7 +1138,7 @@ unsigned int videobuf_poll_stream(struct file *file,
 		if (!list_empty(&q->stream))
 			buf = list_entry(q->stream.next,
 					 struct videobuf_buffer, stream);
-	} else {
+	} else if (req_events & (POLLIN | POLLRDNORM)) {
 		if (!q->reading)
 			__videobuf_read_start(q);
 		if (!q->reading) {
-- 
1.7.5.4

