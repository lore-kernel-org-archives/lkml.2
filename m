Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2GSBTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:19:49 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53726 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2GSBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:19:47 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] Additional time changes for 3.6
Date: Wed, 18 Jul 2012 21:19:11 -0400
Message-Id: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071901-2398-0000-0000-0000089CA711
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo, 

Just wanted to send out two more patches against tip/timers/core
for consideration for 3.6.

The first is Catalin's patch to make CLOCK_TICK_RATE optional and
is fairly straight forward.

The second is a patch to improve the handling of the duplicate
offs_real/wall_to_mono and  offs_boot/total_sleep_time pairs.

This second one is a result of the suspend regression in 3.5-rc7
making it clear that these value pairs have to be more carefully
handled, so by forcing all modifications use the set functions
and warning if the value pairs are ever out of sync should
avoid future mistakes.

Please take a look and let me know if you have any thoughts
or concerns on these changes.

thanks
-john


Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>


Catalin Marinas (1):
  jiffies: Allow CLOCK_TICK_RATE to be undefined

John Stultz (1):
  time: Cleanup offs_real/wall_to_mono and offs_boot/total_sleep_time
    updates

 include/linux/jiffies.h   |   10 +++--
 kernel/time/timekeeping.c |   94 ++++++++++++++++++++++++++++-----------------
 2 files changed, 66 insertions(+), 38 deletions(-)

-- 
1.7.9.5

