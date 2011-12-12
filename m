Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1LLT5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:57:01 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:40089 "EHLO
	intmgw002.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753924Ab1LLT4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:56:37 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 0/2] Add a thread cpu time implementation to vDSO
Date: Mon, 12 Dec 2011 11:36:16 -0800
Message-Id: <1323718578-1157-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should speed up profilers that need to query thread
cpu time a lot to do fine-grained timestamps.

Arun Sharma (1):
  Extend VVAR support to multiple pages

Kumar Sundararajan (1):
  Add a thread cpu time implementation to vDSO

 arch/x86/include/asm/fixmap.h  |    1 +
 arch/x86/include/asm/timer.h   |   18 +++++++++---
 arch/x86/include/asm/vvar.h    |    4 ++-
 arch/x86/kernel/tsc.c          |    6 ++++
 arch/x86/kernel/vmlinux.lds.S  |    2 +-
 arch/x86/kernel/vsyscall_64.c  |    2 +
 arch/x86/vdso/vclock_gettime.c |   58 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/vdso/vdso.lds.S       |    2 +
 arch/x86/vdso/vma.c            |    5 +++
 include/linux/jiffies.h        |   16 +++++++++++
 kernel/sched.c                 |    6 ++++
 11 files changed, 111 insertions(+), 9 deletions(-)

-- 
1.7.4

