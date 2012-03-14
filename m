Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031326Ab2CNX7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:59:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44759 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031186Ab2CNX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:59:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] time: Fix races at clocksource switch time
Date: Wed, 14 Mar 2012 16:58:54 -0700
Message-Id: <1331769536-4602-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031423-3270-0000-0000-000004CC020E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In testing some recent timekeeping changes, I found some problem
when changing clocksources.

These two patches close races at clocksource switch time. One I sent out
earlier, and have reworked to integrate Thomas' comments.

These two patches, along with Thomas' recent cleanup patches ontop can
be found here:
	git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/time

CC: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>

John Stultz (2):
  time: x86: Fix race switching from vsyscall to non-vsyscall clock
  time: Fix change_clocksource locking

 arch/x86/vdso/vclock_gettime.c |   63 ++++++++++++++++++++++++----------------
 kernel/time/timekeeping.c      |    7 ++++
 2 files changed, 45 insertions(+), 25 deletions(-)

-- 
1.7.3.2.146.gca209

