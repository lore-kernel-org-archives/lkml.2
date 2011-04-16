Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab1DPKCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:02:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1DPKBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:01:53 -0400
Date: Sat, 16 Apr 2011 12:01:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] futex fix
Message-ID: <20110416100138.GA9776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (1):
      futex: Set FLAGS_HAS_TIMEOUT during futex_wait restart setup


 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index dfb924f..fe28dc2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1886,7 +1886,7 @@ retry:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = flags;
+	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
 
 	ret = -ERESTART_RESTARTBLOCK;
 
