Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0GVUZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:25:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab0GVUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:24:54 -0400
X-Authority-Analysis: v=1.1 cv=Bg1eF82PU/BBLXqN4uYnzFVuDnL6ar87Ns1E9VhfbEo= c=1 sm=0 a=3Hci3Pwzf60A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=YoxM-lRnAAAA:8 a=meVymXHHAAAA:8 a=3Xy-S3sgpcIMMfG8J50A:9 a=LYXkWRPJ5EVuAl7SqTQA:7 a=4L51aUizZdLjfybj2lh8SDgVAvMA:4 a=jeBq3FmKZ4MA:10 a=1g7oDzIvZWB_8K9f:21 a=rSaPSPL2myXWIg54:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100722202452.515464451@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 16:24:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>
Subject: [PATCH 2/7] trace: Reorder struct ring_buffer_per_cpu to remove padding on 64bit
References: <20100722202411.920807480@goodmis.org>
Content-Disposition: inline; filename=0002-trace-Reorder-struct-ring_buffer_per_cpu-to-remove-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder structure to remove 8 bytes of padding on 64 bit builds.
This shrinks the size to 128 bytes so allowing allocation from a smaller
slab & needed one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
LKML-Reference: <1269516456.2054.8.camel@localhost>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 28d0615..3632ce8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -443,6 +443,7 @@ int ring_buffer_print_page_header(struct trace_seq *s)
  */
 struct ring_buffer_per_cpu {
 	int				cpu;
+	atomic_t			record_disabled;
 	struct ring_buffer		*buffer;
 	spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
@@ -462,7 +463,6 @@ struct ring_buffer_per_cpu {
 	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
-	atomic_t			record_disabled;
 };
 
 struct ring_buffer {
-- 
1.7.1


