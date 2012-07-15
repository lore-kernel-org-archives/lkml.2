Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2GOUfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 16:35:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41529 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2GOUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 16:35:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [Regression][Revert request] Excessive delay or hang during resume from system suspend due to a hrtimer commit
Date: Sun, 15 Jul 2012 22:40:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207152240.50129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please revert:

commit 5baefd6d84163443215f4a99f6a20f054ef11236
Author: John Stultz <johnstul@us.ibm.com>
Date:   Tue Jul 10 18:43:25 2012 -0400

    hrtimer: Update hrtimer base offsets each hrtimer_interrupt

This breaks resume on the iBook G4 and Toshiba Portege R500 (at least), by
adding an excessive delay to it (the Toshiba box sometimes hangs hard during
resume from system suspend).  According to Andreas
(https://lkml.org/lkml/2012/7/15/66):

"Apparently during or before noirq resume the system is hanging by the same
amount of time as the system was sleeping."

which seems to agree with my observations.

Given that the two known-affected boxes are so different, it is quite probable
that the total number of affected systems is actually quite high.

Thanks!


To everyone involved: the fact that this change, which was likely to introduce
regressions from the look of it alone, has been pushed to Linus (an to -stable
at the same time!) so late in the cycle, is seriuosly disappointing.

Thanks,
Rafael


