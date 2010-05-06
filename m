Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0EFXF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:05:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0EFXF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:05:57 -0400
X-Authority-Analysis: v=1.1 cv=Ebn0m7KaSvUJV60GCOzUqyhjUj7QmnsyUUVbVvk8w6o= c=1 sm=0 a=fAN4bZ6l490A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=5cPxywkZGpyR0_AJOkgA:9 a=v9DQi2CQnZXmhADKNOwA:7 a=FqMyRxIh-DyxxYuHyU4LhS9NP8IA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100506230555.640538099@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 06 May 2010 19:05:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH 3/3] tracing: Fix "integer as NULL pointer" warning.
References: <20100506230459.278936703@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-integer-as-NULL-pointer-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thiago Farina <tfransosi@gmail.com>

kernel/trace/trace_output.c:256:24: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
LKML-Reference: <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8e46b33..2404c12 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -253,7 +253,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 	void *ret;
 
 	if (s->full)
-		return 0;
+		return NULL;
 
 	if (len > ((PAGE_SIZE - 1) - s->len)) {
 		s->full = 1;
-- 
1.7.0


