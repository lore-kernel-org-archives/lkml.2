Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2JKX2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:28:05 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35456 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JKX2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:28:01 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>
Subject: [PATCH v6 0/6] TSC trace_clock
Date: Thu, 11 Oct 2012 16:27:50 -0700
Message-Id: <1349998076-15495-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Yoshihiro Yonomae's patches to change the per_cpu stats to show raw
timestamps when the clock is not in nanoseconds.

Also added a small patch to fix a warning.


David Sharp (4):
  tracing,x86: Add a TSC trace_clock
  tracing: Reset ring buffer when changing trace_clocks
  tracing: Format non-nanosec times from tsc clock without a decimal
    point.
  tracing: Fix maybe-uninitialized warning in
    ftrace_function_set_regexp

Yoshihiro YUNOMAE (2):
  ftrace: Change unsigned long type of ring_buffer_oldest_event_ts() to
    u64
  ftrace: Show raw time stamp on stats per cpu using counter or tsc
    mode for trace_clock

 arch/alpha/include/asm/trace_clock.h      |    6 ++
 arch/arm/include/asm/trace_clock.h        |    6 ++
 arch/avr32/include/asm/trace_clock.h      |    6 ++
 arch/blackfin/include/asm/trace_clock.h   |    6 ++
 arch/c6x/include/asm/trace_clock.h        |    6 ++
 arch/cris/include/asm/trace_clock.h       |    6 ++
 arch/frv/include/asm/trace_clock.h        |    6 ++
 arch/h8300/include/asm/trace_clock.h      |    6 ++
 arch/hexagon/include/asm/trace_clock.h    |    6 ++
 arch/ia64/include/asm/trace_clock.h       |    6 ++
 arch/m32r/include/asm/trace_clock.h       |    6 ++
 arch/m68k/include/asm/trace_clock.h       |    6 ++
 arch/microblaze/include/asm/trace_clock.h |    6 ++
 arch/mips/include/asm/trace_clock.h       |    6 ++
 arch/mn10300/include/asm/trace_clock.h    |    6 ++
 arch/openrisc/include/asm/trace_clock.h   |    6 ++
 arch/parisc/include/asm/trace_clock.h     |    6 ++
 arch/powerpc/include/asm/trace_clock.h    |    6 ++
 arch/s390/include/asm/trace_clock.h       |    6 ++
 arch/score/include/asm/trace_clock.h      |    6 ++
 arch/sh/include/asm/trace_clock.h         |    6 ++
 arch/sparc/include/asm/trace_clock.h      |    6 ++
 arch/tile/include/asm/trace_clock.h       |    6 ++
 arch/um/include/asm/trace_clock.h         |    6 ++
 arch/unicore32/include/asm/trace_clock.h  |    6 ++
 arch/x86/include/asm/trace_clock.h        |   16 ++++++
 arch/x86/kernel/Makefile                  |    1 +
 arch/x86/kernel/trace_clock.c             |   21 ++++++++
 arch/xtensa/include/asm/trace_clock.h     |    6 ++
 include/asm-generic/trace_clock.h         |   16 ++++++
 include/linux/ftrace_event.h              |    6 ++
 include/linux/ring_buffer.h               |    2 +-
 include/linux/trace_clock.h               |    2 +
 kernel/trace/ring_buffer.c                |    4 +-
 kernel/trace/trace.c                      |   47 ++++++++++++++---
 kernel/trace/trace.h                      |    4 --
 kernel/trace/trace_events_filter.c        |    3 +-
 kernel/trace/trace_output.c               |   80 ++++++++++++++++++++---------
 38 files changed, 316 insertions(+), 42 deletions(-)
 create mode 100644 arch/alpha/include/asm/trace_clock.h
 create mode 100644 arch/arm/include/asm/trace_clock.h
 create mode 100644 arch/avr32/include/asm/trace_clock.h
 create mode 100644 arch/blackfin/include/asm/trace_clock.h
 create mode 100644 arch/c6x/include/asm/trace_clock.h
 create mode 100644 arch/cris/include/asm/trace_clock.h
 create mode 100644 arch/frv/include/asm/trace_clock.h
 create mode 100644 arch/h8300/include/asm/trace_clock.h
 create mode 100644 arch/hexagon/include/asm/trace_clock.h
 create mode 100644 arch/ia64/include/asm/trace_clock.h
 create mode 100644 arch/m32r/include/asm/trace_clock.h
 create mode 100644 arch/m68k/include/asm/trace_clock.h
 create mode 100644 arch/microblaze/include/asm/trace_clock.h
 create mode 100644 arch/mips/include/asm/trace_clock.h
 create mode 100644 arch/mn10300/include/asm/trace_clock.h
 create mode 100644 arch/openrisc/include/asm/trace_clock.h
 create mode 100644 arch/parisc/include/asm/trace_clock.h
 create mode 100644 arch/powerpc/include/asm/trace_clock.h
 create mode 100644 arch/s390/include/asm/trace_clock.h
 create mode 100644 arch/score/include/asm/trace_clock.h
 create mode 100644 arch/sh/include/asm/trace_clock.h
 create mode 100644 arch/sparc/include/asm/trace_clock.h
 create mode 100644 arch/tile/include/asm/trace_clock.h
 create mode 100644 arch/um/include/asm/trace_clock.h
 create mode 100644 arch/unicore32/include/asm/trace_clock.h
 create mode 100644 arch/x86/include/asm/trace_clock.h
 create mode 100644 arch/x86/kernel/trace_clock.c
 create mode 100644 arch/xtensa/include/asm/trace_clock.h
 create mode 100644 include/asm-generic/trace_clock.h

-- 
1.7.7.3

