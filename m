Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1CQARV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:17:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1CQARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:17:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=e19v/yCakitBKnA47ziWUAVFPGQCUN3kFB4ZO855V1bFiRVoxuvalv/GE8lG/r4Sy7
         iNnCSYjanbllCTFfbisw==
Date: Wed, 16 Mar 2011 17:17:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [patch] trace: fix branch profiling location in debugfs
Message-ID: <alpine.DEB.2.00.1103161716320.11407@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs interface for branch profiling is through

	/sys/kernel/debug/tracing/trace_stat/branch_annotated
	/sys/kernel/debug/tracing/trace_stat/branch_all

so update the Kconfig accordingly.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/trace/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -275,7 +275,7 @@ config PROFILE_ANNOTATED_BRANCHES
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
 
-	  /sys/kernel/debug/tracing/profile_annotated_branch
+	  /sys/kernel/debug/tracing/trace_stat/branch_annotated
 
 	  Note: this will add a significant overhead; only turn this
 	  on if you need to profile the system's use of these macros.
@@ -288,7 +288,7 @@ config PROFILE_ALL_BRANCHES
 	  taken in the kernel is recorded whether it hit or miss.
 	  The results will be displayed in:
 
-	  /sys/kernel/debug/tracing/profile_branch
+	  /sys/kernel/debug/tracing/trace_stat/branch_all
 
 	  This option also enables the likely/unlikely profiler.
 
