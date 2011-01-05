Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1AEDiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:38:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab1AEDis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:38:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2] touch_nmi_watchdog semantic changes
Date: Tue,  4 Jan 2011 22:38:29 -0500
Message-Id: <1294198711-15492-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to change the semantics of how touch_nmi_watchdog worked
to cover a corner case where endless console writing would block the
watchdog from going off.

Ingo recommended that I add ratelimiting to the panic code to in case we
get a slew of locked up cpus, hence my first patch in the series.

Cheers,
Don

--
Crap forgot to cc lkml, sorry for the spam...


Don Zickus (2):
  panic:  ratelimit panic messages
  watchdog:  touch_nmi_watchdog should only touch local cpu not every
    one

 Documentation/kernel-parameters.txt |    6 ++++++
 kernel/panic.c                      |   30 ++++++++++++++++++++++++++++++
 kernel/watchdog.c                   |   17 +++++++++--------
 3 files changed, 45 insertions(+), 8 deletions(-)

-- 
1.7.3.4

