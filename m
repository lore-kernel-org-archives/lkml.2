Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2HVAbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:31:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35764 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2HVAbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:31:02 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 0/4] Time fixes for 3.6
Date: Tue, 21 Aug 2012 20:30:45 -0400
Message-Id: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082200-5930-0000-0000-00000B1E2249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo,
	Here are four small time fixes for 3.6
that apply against tip/timers/urgent.

One patch resolves the suspend issue Andreas saw.

The next two are casting fixes for potential overflows
on 32bits, that Andreas found, but haven't been observed
in the wild.

Finally the last one fixes an issue I found in my own
testing w/ the _COARSE clocksources.

Please take a look at them and let me know if you have
any thoughts or objections.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>

Andreas Schwab (1):
  time: Fix casting issue in timekeeping_forward_now

John Stultz (3):
  time: Ensure we normalize the timekeeper in tk_xtime_add
  time: Avoid potential shift-overflow with large shift values
  time: Avoid making adjustments if we havne't accumulated anything

 kernel/time/timekeeping.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
1.7.9.5

