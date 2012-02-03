Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2BCJaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:30:19 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1174 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab2BCJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:29:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] videobuf: only start streaming in poll() if so requested by the poll mask.
Date: Fri,  3 Feb 2012 10:28:43 +0100
Message-Id: <c9146bb921a78af683ce6f2344472ad37e6c69d5.1328260650.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
References: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
References: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
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
1.7.8.3

