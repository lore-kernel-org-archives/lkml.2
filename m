Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2EBTd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:33:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab2EBTcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:39 -0400
X-Authority-Analysis: v=2.0 cv=bcnpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=x8qD5-t7whsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=TSbVqHtbAAAA:8 a=D19gQVrFAAAA:8 a=H7t6wJQMtRbMoyt0clQA:9 a=Z2kmO31Tqjrkum7Xtn4A:7 a=b3D6R9wpAFoA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502192418.024103772@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/9][RFC] ftrace: ftrace location lookup speedup, and clean ups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches are based on a previous pull request:

  http://comments.gmane.org/gmane.linux.kernel/1289098

(Hmm, LKML.org is missing April 27th and 28th, as that pull request
 was on the 27th)

This code makes the search for an ftrace location done by kprobes
much faster as it now does a binary search instead of a linear one.
It also consolidates two functions ftrace_location() and ftrace_text_resevered()
as on is for one addr, the other is for a range. The two functions still
exist, but use the same search.

Some more clean ups are also made to the ftrace code.

These haven't been through all my tests yet, but if they survive this
will be the patches I use for my next git pull request.

I would like these to make it into 3.5. Please comment if you have concerns.

Thanks!

-- Steve

Steven Rostedt (9):
      ftrace: Sort all function addresses, not just per page
      ftrace: Remove extra helper functions
      ftrace: Speed up search by skipping pages by address
      ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
      ftrace: Return record ip addr for ftrace_location()
      kprobes: Allow probe on ftrace reserved text (but move it)
      ftrace: Make ftrace_modify_all_code() global for archs to use
      ftrace/x86: Have x86 ftrace use the ftrace_modify_all_code()
      ftrace: Remove selecting FRAME_POINTER with FUNCTION_TRACER

----
 arch/x86/kernel/ftrace.c          |   15 +--
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/ftrace.h            |    7 +-
 include/linux/kprobes.h           |    1 +
 kernel/kprobes.c                  |   13 ++-
 kernel/trace/Kconfig              |    1 -
 kernel/trace/ftrace.c             |  198 ++++++++++++++++++++-----------------
 7 files changed, 129 insertions(+), 108 deletions(-)
