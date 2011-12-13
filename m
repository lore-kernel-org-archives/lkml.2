Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1LMB0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:26:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53910 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1LMB0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:26:47 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/2] ABI for clock_gettime_ns
Date: Mon, 12 Dec 2011 17:26:36 -0800
Message-Id: <cover.1323739287.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, clock_gettime is so fast that the overhead converting to and
from nanoseconds is non-negligible.  clock_gettime_ns is a different
interface that is potentially faster.  If people like the ABI, I'll
implement an optimized version.

For the git-inclined, this series is at
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/timing/clock_gettime_ns/rfc_v1

Andy Lutomirski (2):
  Add clock_gettime_ns syscall
  x86-64: Add __vdso_clock_gettime_ns vsyscall

 arch/x86/include/asm/unistd_64.h |    2 +
 arch/x86/vdso/vclock_gettime.c   |   70 +++++++++++++++++++++++++++++---------
 arch/x86/vdso/vdso.lds.S         |    7 ++++
 include/linux/syscalls.h         |    2 +
 kernel/posix-timers.c            |   29 ++++++++++++++++
 5 files changed, 94 insertions(+), 16 deletions(-)

-- 
1.7.7.4

