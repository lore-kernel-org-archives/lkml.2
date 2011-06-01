Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513Ab1FALTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:19:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44955 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161274Ab1FALTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=JGEvCp+eKQV224kUmZFPJaaK8ZkqbzY3hbx8+MRfWlddtJHS793YEpQZNTSoUp/skx
         0q/4Rkr2yjHNFvrGDLVeVglts+tZQlYvHqwgUMMxMe9pmQpXRXNIriDSWcD4avZ9qjqD
         IiaU3FJzWJudZGydibdi2ep4AlYOCRIHfmw5c=
From: GuoWen Li <guowen.li.linux@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Fix compiler warning in ftrace.c
Date: Wed, 1 Jun 2011 19:18:47 +0800
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106011918.47939.guowen.li.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/trace/ftrace.c: In function ‘ftrace_regex_write.clone.15’:
kernel/trace/ftrace.c:2743:6: warning: ‘ret’ may be used uninitialized in this 
function

Signed-off-by: GuoWen Li
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..204b3eb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2740,7 +2740,7 @@ static int ftrace_process_regex(struct ftrace_hash 
*hash,
 {
        char *func, *command, *next = buff;
        struct ftrace_func_command *p;
-       int ret;
+       int ret = -EINVAL;
 
        func = strsep(&next, ":");
