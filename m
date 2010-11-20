Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0KTCJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:09:23 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39182 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab0KTCJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:09:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dima Zavin <dima@android.com>, Erik Gilling <konkers@android.com>,
        Mike Chan <mike@android.com>
Subject: [PATCH 0/5] [RFC] Trivial scheduler related Android patches
Date: Fri, 19 Nov 2010 18:08:49 -0800
Message-Id: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after all the heat that was generated in the various Android
discussions, I took a look a look at the android git tree, and 
while there are a fair number of large and controversial 
infrastructure changes, there are also a number of small fixes 
that apply easily against Linus' git tree.

So after cherry picking these 50-some small patches out of the
android tree, I organized them into topic branches, and over
the next few weeks, I hope to send them out to lkml and topic
maintainers for comments.

Now, I'm not proposing that these changes be merged as-is. It
may very well be that, unknown to me, android developers have
already tried to submit these patches and they have been rejected
for good reason. Or some patches may very well be necessary hacks
to get thing shipping while deeper fixes are being worked on. If
that is the case, let me know and forgive me for the noise.

But as, it seemed many of these small changes have been obscured
by the debate over the larger infrastructure changes, I wanted 
to bring them forward so that possibly good fixes were not missed
in the controversy.

Maintainers: If you do find any of these patches distasteful,
that's fine, I'll be happy to drop them from my tree for now.
I really don't want to stir up another huge mail thread over these 
small patches, but I'd appreciate if you'd consider them as a
bug report illustrating an issue or a desired feature, and suggest 
what you see as a reasonable way to accomplish the desired
functionality presented in the patch.

The following patches are just the scheduler related trivial patches
from the Android tree. You can find this as well as my other trivial
Android topic branches here:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=summary

thanks
-john

Cc: Arve Hjønnevåg <arve@android.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Dima Zavin <dima@android.com>
CC: Erik Gilling <konkers@android.com>
CC: Mike Chan <mike@android.com>


Arve HjÃ¸nnevÃ¥g (1):
  sched: Enable might_sleep before initializing drivers.

Dima Zavin (1):
  sched: use the old min_vruntime when normalizing on dequeue

Erik Gilling (1):
  sched: make task dump print all 15 chars of proc comm

Mike Chan (2):
  scheduler: cpuacct: Enable platform hooks to track cpuusage for CPU
    frequencies
  scheduler: cpuacct: Enable platform callbacks for cpuacct power
    tracking

 Documentation/cgroups/cpuacct.txt |    7 +++
 include/linux/cpuacct.h           |   43 +++++++++++++++++++
 kernel/sched.c                    |   84 ++++++++++++++++++++++++++++++++++++-
 kernel/sched_fair.c               |    6 ++-
 4 files changed, 137 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/cpuacct.h

-- 
1.7.3.2.146.gca209

