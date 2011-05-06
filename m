Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1EFPfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:35:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:37906 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1EFPfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:35:31 -0400
Message-ID: <4DC4153E.5020304@suse.com>
Date: Fri, 06 May 2011 11:35:26 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>
Subject: [PATCH] softlockup: re-increase hung tasks check from 2 minutes to
 8 minutes
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit e162b39a, which moved the soft lockup code around a bit,
 accidentally reverted commit fb822db4, which extended the soft lockup
 timeout from 2 minutes to 8 minutes.

 This patch restores it to 8 minutes.

 From the original patch:
 >Andrew says:
 >
 >> Seems that about 100% of the reports we get of this warning triggering
 >> are sys_sync, transaction commit, etc.
 >
 >increase the timeout. If it still triggers for people, we can kill it.

Originally-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 kernel/hung_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -33,7 +33,7 @@ unsigned long __read_mostly sysctl_hung_
 /*
  * Zero means infinite timeout - no checking done:
  */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = 480;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
-- 
Jeff Mahoney
SUSE Labs
