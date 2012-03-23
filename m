Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2CWEQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:16:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55561 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2CWEQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:16:01 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86-64: Simplify and speed up vdso clock_gettime
Date: Thu, 22 Mar 2012 21:15:50 -0700
Message-Id: <cover.1332475308.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think clock_gettime is already almost as fast as possible, but every
little bit helps.  Also, I think the diffstat is pretty good for a
speedup.  Here are some approximate timings.

                             Before       After
CLOCK_REALTIME                 16.7        15.2
CLOCK_MONOTONIC                17.3        15.5
CLOCK_REALTIME_COARSE           3.6         3.0
CLOCK_MONOTONIC_COARSE          4.2         3.6

These are extracted from an earlier series that's mostly abandoned now [1-2].
They apply to tip/timers/core commit 57779dc2b3b75bee05ef5d1ada47f615f7a13932.

For the git-inclined, the patches are here:
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/timing/vclock_speedup/patch_v1

I'm not sure whether these are 3.4 material.  On the pro side, they've
technically been floating around since long before the merge window.
They're also quite straightforward, and they're based on other -tip
changes (which is why I'm submitting now).  On the con side, they don't
fix anything, and they're a little later than ideal.

[1] https://lkml.org/lkml/2011/12/25/26
[2] https://lkml.org/lkml/2011/12/25/27

Andy Lutomirski (2):
  x86-64: Simplify and optimize vdso clock_gettime monotonic variants
  x86-64: Inline vdso clock_gettime helpers

 arch/x86/include/asm/vgtod.h   |   15 +++++++-----
 arch/x86/kernel/vsyscall_64.c  |   10 +++++++-
 arch/x86/vdso/vclock_gettime.c |   47 +++++++++++----------------------------
 3 files changed, 31 insertions(+), 41 deletions(-)

-- 
1.7.7.6

