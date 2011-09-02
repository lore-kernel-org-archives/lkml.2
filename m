Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1IBS2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:28:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36654 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1IBS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:28:02 -0400
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET pm-freezer] freezer: fixes & simplifications
Date: Sat,  3 Sep 2011 03:27:44 +0900
Message-Id: <1314988070-12244-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These six patches are fixes and simplifications for the recent freezer
changes.  The first four have been posted twice.  Changes since the
last posting[L] are

* freezer->state setting bug fix updated per Matt Helsley so that the
  actual per-task freeze/thaw operations are always performed.

* fixed a bug caused by forgetting to unlock freezer_lock in "freezer:
  restructure __refrigerator()".

* Two patches added.  The fifth one is mostly trivial.  The sixth a
  bit more involved but still shouldn't cause any noticeable
  functional difference.  This removes the buggy and unused
  freezable_with_signal.

Properly tested this time.  As hera is still down, no git branch
available at this point.  Patch list and diffstat follow.

Thanks.

 [PATCH 1/6] cgroup_freezer: fix freezer->state setting bug in
 [PATCH 2/6] freezer: set PF_NOFREEZE on a dying task right before
 [PATCH 3/6] freezer: restructure __refrigerator()
 [PATCH 4/6] freezer: use lock_task_sighand() in
 [PATCH 5/6] freezer: remove unused @sig_only from freeze_task()
 [PATCH 6/6] freezer: kill unused set_freezable_with_signal()

 include/linux/freezer.h |   22 +------------
 include/linux/sched.h   |    1
 kernel/cgroup_freezer.c |   18 +++++------
 kernel/exit.c           |   10 ++----
 kernel/freezer.c        |   78 ++++++++++++++++--------------------------------
 kernel/kthread.c        |    2 -
 kernel/power/process.c  |    8 ++--
 7 files changed, 47 insertions(+), 92 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1186387
