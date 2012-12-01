Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab2LAAoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:44:15 -0500
Received: from scrye.com ([75.148.32.185]:37267 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2LAAoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:44:13 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: Enumerate the guidelines for stable patches.
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
Date: Fri, 30 Nov 2012 17:44:13 -0700
Message-ID: <gr4na1u02.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b31 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Anthony Foiani <anthony.foiani@gmail.com>

Having recently received a formletter rejection on a stable patch, I
found it difficult to determine exactly which guideline I had missed.

Numbering the guidelines will allow the stable maintainer to quickly
and easily indicate which guidelines have not been followed.

The actual changes are only the addition of clause numbering, and the
wishful thinking added to S15.

Signed-Off-By: Anthony Foiani <anthony.foiani@gmail.com>
---
 Documentation/stable_kernel_rules.txt | 185 ++++++++++++++++++++--------------
 1 file changed, 108 insertions(+), 77 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index b0714d8..9a6dc59 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -1,95 +1,126 @@
 Everything you ever wanted to know about Linux -stable releases.
 
-Rules on what kind of patches are accepted, and which ones are not, into the
-"-stable" tree:
-
- - It must be obviously correct and tested.
- - It cannot be bigger than 100 lines, with context.
- - It must fix only one thing.
- - It must fix a real bug that bothers people (not a, "This could be a
-   problem..." type thing).
- - It must fix a problem that causes a build error (but not for things
-   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
-   security issue, or some "oh, that's not good" issue.  In short, something
-   critical.
- - Serious issues as reported by a user of a distribution kernel may also
-   be considered if they fix a notable performance or interactivity issue.
-   As these fixes are not as obvious and have a higher risk of a subtle
-   regression they should only be submitted by a distribution kernel
-   maintainer and include an addendum linking to a bugzilla entry if it
-   exists and additional information on the user-visible impact.
- - New device IDs and quirks are also accepted.
- - No "theoretical race condition" issues, unless an explanation of how the
-   race can be exploited is also provided.
- - It cannot contain any "trivial" fixes in it (spelling changes,
-   whitespace cleanups, etc).
- - It must follow the Documentation/SubmittingPatches rules.
- - It or an equivalent fix must already exist in Linus' tree (upstream).
+Rules on what kind of patches are accepted, and which ones are not,
+into the "-stable" tree.
 
+S1.  It must be obviously correct and tested.
+
+S2.  It cannot be bigger than 100 lines, with context.
+
+S3.  It must fix only one thing.
+
+S4.  It must fix a real bug that bothers people (not a, "This could be
+     a problem..." type thing).
+
+S5.  It must fix a problem that causes a build error (but not for
+     things marked CONFIG_BROKEN), an oops, a hang, data corruption, a
+     real security issue, or some "oh, that's not good" issue.  In
+     short, something critical.
+
+S6.  Serious issues as reported by a user of a distribution kernel may
+     also be considered if they fix a notable performance or
+     interactivity issue.  As these fixes are not as obvious and have
+     a higher risk of a subtle regression they should only be
+     submitted by a distribution kernel maintainer and include an
+     addendum linking to a bugzilla entry if it exists and additional
+     information on the user-visible impact.
+
+S7.  New device IDs and quirks are also accepted.
+
+S8.  No "theoretical race condition" issues, unless an explanation of
+     how the race can be exploited is also provided.
+
+S9.  It cannot contain any "trivial" fixes in it (spelling changes,
+     whitespace cleanups, etc).
+
+S10. It must follow the Documentation/SubmittingPatches rules.
+
+S11. It or an equivalent fix must already exist in Linus' tree
+     (upstream).
 
 Procedure for submitting patches to the -stable tree:
 
- - Send the patch, after verifying that it follows the above rules, to
-   stable@vger.kernel.org.  You must note the upstream commit ID in the
-   changelog of your submission, as well as the kernel version you wish
-   it to be applied to.
- - To have the patch automatically included in the stable tree, add the tag
-     Cc: stable@vger.kernel.org
-   in the sign-off area. Once the patch is merged it will be applied to
-   the stable tree without anything else needing to be done by the author
-   or subsystem maintainer.
- - If the patch requires other patches as prerequisites which can be
-   cherry-picked than this can be specified in the following format in
-   the sign-off area:
-
-     Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
-     Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
-     Cc: <stable@vger.kernel.org> # 3.3.x: fd21073: sched: Fix affinity logic
-     Cc: <stable@vger.kernel.org> # 3.3.x
-    Signed-off-by: Ingo Molnar <mingo@elte.hu>
-
-   The tag sequence has the meaning of:
-     git cherry-pick a1f84a3
-     git cherry-pick 1b9508f
-     git cherry-pick fd21073
-     git cherry-pick <this commit>
-
- - The sender will receive an ACK when the patch has been accepted into the
-   queue, or a NAK if the patch is rejected.  This response might take a few
-   days, according to the developer's schedules.
- - If accepted, the patch will be added to the -stable queue, for review by
-   other developers and by the relevant subsystem maintainer.
- - Security patches should not be sent to this alias, but instead to the
-   documented security@kernel.org address.
+S12. Send the patch, after verifying that it follows the above rules,
+     to stable@vger.kernel.org.  You must note the upstream commit ID
+     in the changelog of your submission, as well as the kernel
+     version you wish it to be applied to.
+
+S13. To have the patch automatically included in the stable tree, add
+     the tag
+
+       Cc: stable@vger.kernel.org
+
+     in the sign-off area. Once the patch is merged it will be applied
+     to the stable tree without anything else needing to be done by
+     the author or subsystem maintainer.
+
+S14. If the patch requires other patches as prerequisites which can be
+     cherry-picked than this can be specified in the following format
+     in the sign-off area:
 
+       Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
+       Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
+       Cc: <stable@vger.kernel.org> # 3.3.x: fd21073: sched: Fix affinity logic
+       Cc: <stable@vger.kernel.org> # 3.3.x
+       Signed-off-by: Ingo Molnar <mingo@elte.hu>
+
+     The tag sequence has the meaning of:
+
+       git cherry-pick a1f84a3
+       git cherry-pick 1b9508f
+       git cherry-pick fd21073
+       git cherry-pick <this commit>
+
+S15. The sender will receive an ACK when the patch has been accepted
+     into the queue, or a NAK if the patch is rejected.  This response
+     might take a few days, according to the developer's schedules.
+     Ideally, any NAK message would include an indication of which
+     guidelines have not been followed.
+
+S16. If accepted, the patch will be added to the -stable queue, for
+     review by other developers and by the relevant subsystem
+     maintainer.
+
+S17. Security patches should not be sent to this alias, but instead to
+     the documented security@kernel.org address.
 
 Review cycle:
 
- - When the -stable maintainers decide for a review cycle, the patches will be
-   sent to the review committee, and the maintainer of the affected area of
-   the patch (unless the submitter is the maintainer of the area) and CC: to
-   the linux-kernel mailing list.
- - The review committee has 48 hours in which to ACK or NAK the patch.
- - If the patch is rejected by a member of the committee, or linux-kernel
-   members object to the patch, bringing up issues that the maintainers and
-   members did not realize, the patch will be dropped from the queue.
- - At the end of the review cycle, the ACKed patches will be added to the
-   latest -stable release, and a new -stable release will happen.
- - Security patches will be accepted into the -stable tree directly from the
-   security kernel team, and not go through the normal review cycle.
-   Contact the kernel security team for more details on this procedure.
+S18. When the -stable maintainers decide for a review cycle, the
+     patches will be sent to the review committee, and the maintainer
+     of the affected area of the patch (unless the submitter is the
+     maintainer of the area) and CC: to the linux-kernel mailing list.
+
+S19. The review committee has 48 hours in which to ACK or NAK the
+     patch.
+
+S20. If the patch is rejected by a member of the committee, or
+     linux-kernel members object to the patch, bringing up issues that
+     the maintainers and members did not realize, the patch will be
+     dropped from the queue.
+
+S21. At the end of the review cycle, the ACKed patches will be added
+     to the latest -stable release, and a new -stable release will
+     happen.
+
+S22. Security patches will be accepted into the -stable tree directly
+     from the security kernel team, and not go through the normal
+     review cycle.  Contact the kernel security team for more details
+     on this procedure.
 
 Trees:
 
- - The queues of patches, for both completed versions and in progress
-   versions can be found at:
+S23. The queues of patches, for both completed versions and in
+     progress versions can be found at:
+
 	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git
- - The finalized and tagged releases of all stable kernels can be found
-   in separate branches per version at:
-	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
 
+S24. The finalized and tagged releases of all stable kernels can be
+     found in separate branches per version at:
+
+	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
 
 Review committee:
 
- - This is made up of a number of kernel developers who have volunteered for
-   this task, and a few that haven't.
+S25. This is made up of a number of kernel developers who have
+     volunteered for this task, and a few that haven't.
-- 
1.7.11.7

