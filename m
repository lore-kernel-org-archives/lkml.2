Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2GRIpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:45:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2GRIpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:45:08 -0400
Date: Wed, 18 Jul 2012 10:45:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] time/ntp fix
Message-ID: <20120718084503.GA12871@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: 6b1859dba01c7d512b72d77e3fd7da8354235189 ntp: Fix STA_INS/DEL clearing bug

 Thanks,

	Ingo

------------------>
John Stultz (1):
      ntp: Fix STA_INS/DEL clearing bug


 kernel/time/ntp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 70b33ab..b7fbadc 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -409,7 +409,9 @@ int second_overflow(unsigned long secs)
 			time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (secs % 86400 == 0) {
+		if (!(time_status & STA_INS))
+			time_state = TIME_OK;
+		else if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
 			time_tai++;
@@ -418,7 +420,9 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_DEL:
-		if ((secs + 1) % 86400 == 0) {
+		if (!(time_status & STA_DEL))
+			time_state = TIME_OK;
+		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
 			time_tai--;
 			time_state = TIME_WAIT;
