Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0KKJKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:10:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab0KKJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:09:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/2] tracing,mm - add kernel pagefault tracepoint for x86 & x86_64
Date: Thu, 11 Nov 2010 10:09:07 +0100
Message-Id: <1289466549-7602-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20101110164413.GA5360@nowhere>
References: <20101110164413.GA5360@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a tracepoint to trace kernel pagefault event
for x86 and x86_64 architectures.

There's a problem with this tracepoint when having the
userstacktrace option enabled, since it might generated
the page fault itself. The 1/2 patch address this issue.

v2 changes:
- replaced regs for error_code in page fault trace
- swapped the patch order not to introduce the regression
- minor code style change

attached patches:
1/2 tracing - fix recursive user stack trace
2/2 tracing,mm - add kernel pagefault tracepoint for x86 & x86_64

wbr,
jirka
---
 arch/x86/mm/fault.c         |   32 +++++++++++++++++++++-----------
 include/trace/events/kmem.h |   22 ++++++++++++++++++++++
 kernel/trace/trace.c        |   17 +++++++++++++++++
 3 files changed, 60 insertions(+), 11 deletions(-)
