Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0GVUZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:25:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab0GVUYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:24:55 -0400
X-Authority-Analysis: v=1.1 cv=0ETVU5ClxBlG/P3Ky9ZuhqraSVIot/cIDNO6awFX9oc= c=1 sm=0 a=XmSWgzr7B-oA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=voDV4CxJghPir0R3_wYA:9 a=KWR4e7zooMaY1CK9T0-xQQSAOAcA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100722202453.766121554@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 16:24:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 7/7] trace: strlen() return doesnt account for the NULL
References: <20100722202411.920807480@goodmis.org>
Content-Disposition: inline; filename=0007-trace-strlen-return-doesn-t-account-for-the-NULL.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

We need to add one to the strlen() return because of the NULL
character.  The type->name here generally comes from the kernel and I
don't think any of them come close to being MAX_TRACER_SIZE (100)
characters long so this is basically a cleanup.

Signed-off-by: Dan Carpenter <error27@gmail.com>
LKML-Reference: <20100710100644.GV19184@bicker>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f7488f4..cacb6f0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -739,7 +739,7 @@ __acquires(kernel_lock)
 		return -1;
 	}
 
-	if (strlen(type->name) > MAX_TRACER_SIZE) {
+	if (strlen(type->name) >= MAX_TRACER_SIZE) {
 		pr_info("Tracer has a name longer than %d\n", MAX_TRACER_SIZE);
 		return -1;
 	}
-- 
1.7.1


