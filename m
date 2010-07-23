Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab0GWMMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:12:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:43117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab0GWMMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:12:15 -0400
Date: Fri, 23 Jul 2010 12:11:58 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, error27@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        error27@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20100710100644.GV19184@bicker>
References: <20100710100644.GV19184@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace: strlen() return doesn't account for the NULL
Message-ID: <tip-24a461d537f49f9da6533d83100999ea08c6c755@git.kernel.org>
Git-Commit-ID: 24a461d537f49f9da6533d83100999ea08c6c755
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 12:11:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24a461d537f49f9da6533d83100999ea08c6c755
Gitweb:     http://git.kernel.org/tip/24a461d537f49f9da6533d83100999ea08c6c755
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Sat, 10 Jul 2010 12:06:44 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 22 Jul 2010 14:56:41 -0400

trace: strlen() return doesn't account for the NULL

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
