Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab0JXVYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:24:12 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52945 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab0JXVYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:24:11 -0400
Date: Sun, 24 Oct 2010 22:23:50 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>
Subject: [PATCH] MIPS: MT: Fix build error iFPU affinity code
Message-ID: <20101024212350.GA18747@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit b0ae19811375031ae3b3fecc65b702a9c6e5cc28
> Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date:   Fri Oct 15 04:21:18 2010 +0900
>
>     security: remove unused parameter from security_task_setscheduler()

broke the build of arch/mips/kernel/mips-mt-fpaff.c.  The function
arguments were unnecessary, not the semicolon ...

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/kernel/mips-mt-fpaff.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index 9a526ba..802e616 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -103,7 +103,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
-	retval = security_task_setscheduler(p)
+	retval = security_task_setscheduler(p);
 	if (retval)
 		goto out_unlock;
 
