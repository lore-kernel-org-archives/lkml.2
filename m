Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0KJL4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:56:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab0KJL43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:56:29 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tracing,mm - add kernel pagefault tracepoint for x86 & x86_64
Date: Wed, 10 Nov 2010 12:56:10 +0100
Message-Id: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a tracepoint to trace kernel pagefault event
for x86 and x86_64 architectures.

There's a problem with this tracepoint when having the
userstacktrace option enabled, since it might generated
the page fault itself. The 2/2 patch address this issue.

attached patches:
1/2 tracing,mm - add kernel pagefault tracepoint for x86 & x86_64
2/2 tracing - fix recursive user stack trace

wbr,
jirka
---
 arch/x86/mm/fault.c         |   32 +++++++++++++++++++++-----------
 include/trace/events/kmem.h |   22 ++++++++++++++++++++++
 kernel/trace/trace.c        |   19 +++++++++++++++++++
 3 files changed, 62 insertions(+), 11 deletions(-)
