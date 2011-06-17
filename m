Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab1FQOxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:53:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37456 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297Ab1FQOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Ts1v43ORt8LkzALvejqB0Ayknf3YafPjER5sf7j7jxMaNlu3Y57i0DSw+w/6g/Rfh6
         SzALpAhEEKH+CUeFTci+UAptpH+sXvDSi7mgsd7w6HoWpaJhbsF7NwwjXjLrRxwrKu04
         7mylYbhDeWWUrlrSLsCa3D8OQSgW0rTTuw/IU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org
Subject: [PATCHSET] ptrace: kill most tracehooks
Date: Fri, 17 Jun 2011 16:50:33 +0200
Message-Id: <1308322240-8247-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

At this point, tracehooks aren't useful to mainline kernel and mostly
just add an extra layer of obfuscation.  Although they have comments,
without actual in-kernel users, it is difficult to tell what are their
assumptions and they're actually trying to achieve.  To mainline
kernel, they just aren't worth keeping around.

This patchset kills most tracehooks which aren't used from arch codes.
The remaining ones will be dealt with with future changes.

 0001-ptrace-kill-task_ptrace.patch
 0002-ptrace-introduce-ptrace_event_enabled-and-simplify-p.patch
 0003-ptrace-move-SIGTRAP-on-exec-2-logic-to-ptrace_event.patch
 0004-ptrace-kill-trivial-tracehooks.patch
 0005-ptrace-kill-clone-exec-tracehooks.patch
 0006-ptrace-kill-detah-tracehooks.patch
 0007-ptrace-s-tracehook_tracer_task-ptrace_parent.patch

Most conversions are straightforward.  The only tricky one is 0006
which reimplements the decision logic.

This patch is on top of Oleg's ptrace branch[1] - 544b2c91a9 (ptrace:
implement PTRACE_LISTEN), and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-tracehook

diffstat follows.

 arch/s390/kernel/traps.c   |    4 
 fs/exec.c                  |    9 -
 fs/proc/array.c            |    2 
 fs/proc/base.c             |    2 
 include/linux/ptrace.h     |   71 ++++++---
 include/linux/tracehook.h  |  333 ---------------------------------------------
 kernel/exit.c              |   43 +++--
 kernel/fork.c              |   43 ++++-
 kernel/signal.c            |   22 +-
 mm/nommu.c                 |    3 
 mm/oom_kill.c              |    3 
 security/apparmor/domain.c |    2 
 security/selinux/hooks.c   |    4 
 13 files changed, 136 insertions(+), 405 deletions(-)

--
tejun

[1] git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace
