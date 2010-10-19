Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0JSTmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 15:42:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0JSTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 15:42:06 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=GnwYtQRWDy4A:10 a=HRn4fpiT8EsA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=KTeW7JNuhSk4JWS1EwMA:9 a=c_Mq1e9W30UGxj13cvPQ5h8NtowA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101019194204.680033652@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 13:54:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/5] ring-buffer: Remove unused macro RB_TIMESTAMPS_PER_PAGE
References: <20101019175432.854431527@goodmis.org>
Content-Disposition: inline; filename=0005-ring-buffer-Remove-unused-macro-RB_TIMESTAMPS_PER_PA.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the binding of time extends to events we no longer need to use
the macro RB_TIMESTAMPS_PER_PAGE. Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fda009a..bd31d97 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -448,9 +448,6 @@ static inline int test_time_stamp(u64 delta)
 /* Max payload is BUF_PAGE_SIZE - header (8bytes) */
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
-/* Max number of timestamps that can fit on a page */
-#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_EXTEND)
-
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
 	struct buffer_data_page field;
-- 
1.7.1


