Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1GZGaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:30:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36137 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1GZG37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:29:59 -0400
Subject: [GIT PULL] RTC fixes for 3.1
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>,
        Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 23:29:54 -0700
Message-ID: <1311661794.2945.305.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	So while your analysis obviously pointed out the problem, just to be
sure I took your rtc patches and ran them through the stress test that I
was using to reproduce the issue Ben reported, and they've lasted for
over six hours now without issue (usually I could trigger the lockup in
30 minutes to an hour).

Thanks again for the narrowing down the issue and the patches to fix it!

I've reworked some of the commit logs and also refined the PIE hrtimer
freq limit (using Willy's suggestion of the ~8khz max value from the man
page). The patches are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/rtc

Thomas Gleixner (3):
      rtc: Handle errors correctly in rtc_irq_set_state()
      rtc: Fix hrtimer deadlock
      rtc: Limit RTC PIE frequency

 drivers/rtc/interface.c |   55 ++++++++++++++++++++++++++++++++--------------
 include/linux/rtc.h     |    3 ++
 2 files changed, 41 insertions(+), 17 deletions(-)


