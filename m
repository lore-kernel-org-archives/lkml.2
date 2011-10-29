Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab1J2Rec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:34:32 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50634 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514Ab1J2Rea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:34:30 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] Freezer / Documentation: Update freezer documentation
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Sat, 29 Oct 2011 23:04:20 +0530
Message-ID: <20111029173418.4559.3699.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102907-5140-0000-0000-00000021E111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:
 * substitutes some obsolete references to kernel/power/process.c by
   kernel/freezer.c
 * mentions kernel/freezer.c as being part of the "freezer" code along
   with the rest of the files
 * fixes a trivial typo.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/freezing-of-tasks.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 38b5724..316c2ba 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -22,12 +22,12 @@ try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
 either wakes them up, if they are kernel threads, or sends fake signals to them,
 if they are user space processes.  A task that has TIF_FREEZE set, should react
 to it by calling the function called refrigerator() (defined in
-kernel/power/process.c), which sets the task's PF_FROZEN flag, changes its state
+kernel/freezer.c), which sets the task's PF_FROZEN flag, changes its state
 to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is cleared for it.
 Then, we say that the task is 'frozen' and therefore the set of functions
 handling this mechanism is referred to as 'the freezer' (these functions are
-defined in kernel/power/process.c and include/linux/freezer.h).  User space
-processes are generally frozen before kernel threads.
+defined in kernel/power/process.c, kernel/freezer.c & include/linux/freezer.h).
+User space processes are generally frozen before kernel threads.
 
 It is not recommended to call refrigerator() directly.  Instead, it is
 recommended to use the try_to_freeze() function (defined in
@@ -95,7 +95,7 @@ after the memory for the image has been freed, we don't want tasks to allocate
 additional memory and we prevent them from doing that by freezing them earlier.
 [Of course, this also means that device drivers should not allocate substantial
 amounts of memory from their .suspend() callbacks before hibernation, but this
-is e separate issue.]
+is a separate issue.]
 
 3. The third reason is to prevent user space processes and some kernel threads
 from interfering with the suspending and resuming of devices.  A user space

