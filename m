Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2JAIEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:04:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53991 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2JAIDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:03:48 -0400
Message-ID: <50694E5B.3030602@gmail.com>
Date: Mon, 01 Oct 2012 10:03:39 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Sasikantha Babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Trevor Woerner <twoerner@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [patch] Remove proposed ABI change for setitimer(2)
References: <CAHO5Pa2dnFH+SVkrJngR8Vn4VomsfJ00nOCzRB3+Ns4zs_pxnQ@mail.gmail.com> <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
In-Reply-To: <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2 scheduled an ABI
change for setitimer() whose rationale is dubious. The standards
are largely silent on the point referred to in that commit's 
changelog. In addition, current behavior is causing no reported
hardship for user-space. So, there are no benefits to the change,
and making it risks breaking userspace applications that rely
on the (so far undocumented) Linux behavior. Finally, if one even 
contemplated making a change to the ABI on this point, the sensible 
change would be to make Linux behave as Solaris and the BSDs where:
setitimer(..., NULL, &ovalue) == getitimer(..., &ovalue)

The sensible thing is no change at all. This patch removes the 
scheduled change from feature-removal-schedule.txt.

Signed-off-by: Michael Kerrisk <mtk.man-pages@gmail.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f4d8c71..cdf4ded 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -528,14 +528,6 @@ Who:	Samuel Ortiz <sameo@linux.intel.com>
 
 ----------------------------
 
-What:	setitimer accepts user NULL pointer (value)
-When:	3.6
-Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
-	violates the spec.
-Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
-
-----------------------------
-
 What:	remove bogus DV presets V4L2_DV_1080I29_97, V4L2_DV_1080I30 and
 	V4L2_DV_1080I25
 When:	3.6
