Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab2IMAiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:38:04 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62680 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2ILXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:04 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v2 0/3] TSC trace_clock
Date: Wed, 12 Sep 2012 16:31:56 -0700
Message-Id: <1347492720-26078-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347417671-22998-1-git-send-email-dhsharp@google.com>
References: <1347417671-22998-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated to move arch-specific bits out of generic code. I did this by adding a
new file in asm-generic because I couldn't think of a better place to put it,
but I'm open to suggestions.

David Sharp (3):
  tracing,x86: add a TSC trace_clock
  tracing: reset ring buffer when changing trace_clocks
  tracing: format non-nanosec times from tsc clock without a decimal
    point.

 arch/x86/include/asm/trace_clock.h |   16 +++++++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/trace_clock.c      |   20 +++++++++
 include/asm-generic/trace_clock.h  |   15 +++++++
 include/linux/ftrace_event.h       |    6 +++
 include/linux/trace_clock.h        |    2 +
 kernel/trace/trace.c               |   24 +++++++++-
 kernel/trace/trace.h               |    4 --
 kernel/trace/trace_output.c        |   82 +++++++++++++++++++++++++-----------
 9 files changed, 138 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/include/asm/trace_clock.h
 create mode 100644 arch/x86/kernel/trace_clock.c
 create mode 100644 include/asm-generic/trace_clock.h

-- 
1.7.7.3

