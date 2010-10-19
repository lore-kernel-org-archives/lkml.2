Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0JSTmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 15:42:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab0JSTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 15:42:06 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=0e85fstYS4oA:10 a=HRn4fpiT8EsA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=-ffWZT35FHoUeY4KuuoA:9 a=NGlxHhF2FJY9NtbRwUIA:7 a=zdWDirTXOSsUgorSJBnfYMLas5oA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101019175432.854431527@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 13:54:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] ring-buffer: Various optimizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I based this tree off of Linus's latest, since it removes the macro
that was updated in rc8. This patch set supplies a better fix,
albeit, a bit more complex of a change, hence not going into the rc.

Please pull the latest tip/perf/ringbuffer tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/ringbuffer


Steven Rostedt (5):
      ring-buffer: Make write slow path out of line
      ring-buffer: Bind time extend and data events together
      ring-buffer: Remove condition to add timestamp in fast path
      ring-buffer: Micro-optimize with some strategic inlining
      ring-buffer: Remove unused macro RB_TIMESTAMPS_PER_PAGE

----
 include/linux/ring_buffer.h |   12 --
 kernel/trace/ring_buffer.c  |  344 ++++++++++++++++++++++--------------------
 2 files changed, 180 insertions(+), 176 deletions(-)
