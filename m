Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2FLB2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:28:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36859 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2FLB2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:28:51 -0400
From: Filipe Brandenburger <filbranden@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Filipe Brandenburger <filbranden@gmail.com>
Subject: [PATCHv2 0/1] prctl: move pdeath_signal from task_struct to signal_struct
Date: Mon, 11 Jun 2012 21:28:18 -0400
Message-Id: <1339464499-10270-1-git-send-email-filbranden@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a second version of the patch that I previously submitted under
title "prctl: pdeath_signal sent when parent thread (instead of parent
process) dies". As per the discussion on the original patch, I reworked
it to move pdeath_signal to signal_struct and make it truly per-process.

On Bugzilla #43300, there is some extra discussion and three test cases
including a transcript of their output running on the unpatched kernel
and on the patched kernel. The three test cases check three corner cases
where the current per-task pdeath_signal shows some behavior that is
counter intuitive and goes against what is in the documentation (the
prctl(2) manpage states that PR_SET_PDEATHSIG sets "the parent process
death signal of the calling process" which makes it clear that it is
supposed to be per-process.)

A link to the Bugzilla report:
https://bugzilla.kernel.org/show_bug.cgi?id=43300

Thanks,
Filipe


Filipe Brandenburger (1):
  prctl: move pdeath_signal from task_struct to signal_struct

 fs/exec.c                  |    2 +-
 include/linux/sched.h      |    7 ++++++-
 kernel/cred.c              |    2 +-
 kernel/exit.c              |    8 +++++---
 kernel/fork.c              |    1 -
 kernel/sys.c               |    5 +++--
 security/apparmor/domain.c |    2 +-
 security/selinux/hooks.c   |    2 +-
 security/smack/smack_lsm.c |    2 +-
 9 files changed, 19 insertions(+), 12 deletions(-)

-- 
1.7.7.6

