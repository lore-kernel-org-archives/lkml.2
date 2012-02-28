Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2B1Jlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:41:42 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59593 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2B1Jll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:41:41 -0500
Message-ID: <1330422097.7342.7.camel@ThinkPad-T61>
Subject: [PATCH] fix compile warnings: enumeration value
 =?UTF-8?Q?=E2=80=98TRACE=5FREG=5FPERF=5FREGISTER=E2=80=99?= not handled in
 switch
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: rostedt@goodmis.org
Date: Tue, 28 Feb 2012 17:41:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 12022723-5490-0000-0000-000000D5AFD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to fix the compile warnings: 
kernel/trace/trace_events.c: In function ‘ftrace_event_reg’:
kernel/trace/trace_events.c:152: warning: enumeration value
‘TRACE_REG_PERF_REGISTER’ not handled in switch
kernel/trace/trace_events.c:152: warning: enumeration value
‘TRACE_REG_PERF_UNREGISTER’ not handled in switch
kernel/trace/trace_kprobe.c: In function ‘kprobe_register’:
kernel/trace/trace_kprobe.c:1899: warning: enumeration value
‘TRACE_REG_PERF_REGISTER’ not handled in switch
kernel/trace/trace_kprobe.c:1899: warning: enumeration value
‘TRACE_REG_PERF_UNREGISTER’ not handled in switch

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 include/linux/ftrace_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c3da42d..235753d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,8 +144,10 @@ struct event_filter;
 enum trace_reg {
 	TRACE_REG_REGISTER,
 	TRACE_REG_UNREGISTER,
+#ifdef CONFIG_PERF_EVENTS
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
+#endif
 };
 
 struct ftrace_event_call;
-- 
1.7.1

