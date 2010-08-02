Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0HBANq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0HBANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=uepD0G/CM80gtbySr6CP/yP8844fVoc0Pxgfu3DOiCOF6unIcr5ZMMHjU2hr+0Xutg
         J87R9QmEZX2K65sWzh7zAkxwM+pgZtx6DpXwsCTmsGX0R6Wq3Tgfy/YtYLA9YmEhOuz8
         11GujrStUA3sQ0zYrYJqX4vPIypG+NGtIg2Qg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 02/12] tracing: Drop cpparg() macro
Date: Mon,  2 Aug 2010 02:13:03 +0200
Message-Id: <1280707993-6599-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the cpparg() macro that wraps CPP parameters. We already have
the PARAM() macro for that, no need to have several versions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/ftrace.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index fb783d9..a9377c0 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -75,15 +75,12 @@
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
 
-#undef __cpparg
-#define __cpparg(arg...) arg
-
 /* Callbacks are meaningless to ftrace. */
 #undef TRACE_EVENT_FN
 #define TRACE_EVENT_FN(name, proto, args, tstruct,			\
 		assign, print, reg, unreg)				\
-	TRACE_EVENT(name, __cpparg(proto), __cpparg(args),		\
-		__cpparg(tstruct), __cpparg(assign), __cpparg(print))	\
+	TRACE_EVENT(name, PARAMS(proto), PARAMS(args),			\
+		PARAMS(tstruct), PARAMS(assign), PARAMS(print))		\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-- 
1.6.2.3

