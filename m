Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0JUBnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:43:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab0JUBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:45 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=BkBXSgKk0nIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=cRCWTgFKUZ41F5K7QuIA:9 a=pqljsMEkz_AOr4D6z3MA:7 a=xKrDjY-QiAVEkCK1doy80MVXnn0A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021013906.507064528@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 21:39:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 0/8] [GIT PULL] ring-buffer: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Thomas suggested that I try to fine grain the big patch in this series.
It contained some minor clean ups, so I pulled them out of that patch.
But that patch is still a bit big. Just because it changes the fact
that the ring buffer functions can now accept a time extend as well
as a data event. Those changes were rather trivial though.

Please pull the latest tip/perf/ringbuffer-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/ringbuffer-2


Steven Rostedt (8):
      ring-buffer: Make write slow path out of line
      ring-buffer: Pass timestamp by value and not by reference
      ring-buffer: Pass delta by value and not by reference
      ring-buffer: Remove ring_buffer_event_time_delta()
      ring-buffer: Bind time extend and data events together
      ring-buffer: Remove condition to add timestamp in fast path
      ring-buffer: Micro-optimize with some strategic inlining
      ring-buffer: Remove unused macro RB_TIMESTAMPS_PER_PAGE

----
 include/linux/ring_buffer.h |   12 --
 kernel/trace/ring_buffer.c  |  335 ++++++++++++++++++++++---------------------
 2 files changed, 172 insertions(+), 175 deletions(-)
