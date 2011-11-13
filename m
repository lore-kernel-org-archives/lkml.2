Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1KMXTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:19:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:45123 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1KMXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:48 -0500
Message-Id: <20111113230921.728083714@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 0/7] timekeeping: Decouple xtime_lock from xtime seqcount
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_lock which serializes the update of time relevant data
structures is held over a large code pathes which results in extended
seqlock contention times on the reader side. This series decouples the
lock from the seqcount and reduces the seqcount protected sections to
those which actually update the reader visible data.

Thanks,

	tglx
---
 jiffies.c       |    4 
 ntp.c           |   16 +--
 tick-common.c   |    8 -
 tick-internal.h |    3 
 tick-sched.c    |   12 +-
 timekeeping.c   |  237 +++++++++++++++++++++++++++++++-------------------------
 6 files changed, 157 insertions(+), 123 deletions(-)


