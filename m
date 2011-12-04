Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1LDRHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:07:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:52588 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1LDRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:07:45 -0500
Date: Sun, 4 Dec 2011 18:07:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Richard Cochran <richard.cochran@omicron.at>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PTP] Implement clock_getres() function correctly
In-Reply-To: <alpine.LFD.2.02.1112041801000.2735@ionos>
Message-ID: <alpine.LFD.2.02.1112041806550.2735@ionos>
References: <alpine.LFD.2.02.1112041801000.2735@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Dec 2011, Thomas Gleixner wrote:

> clock_getres() needs to put the resolution into the provided timespec
> and return 0 in case of success.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org

Gah, wrong version.

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index cf3f999..6b0c02a 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -101,7 +101,10 @@ static s32 scaled_ppm_to_ppb(long ppm)
 
 static int ptp_clock_getres(struct posix_clock *pc, struct timespec *tp)
 {
-	return 1; /* always round timer functions to one nanosecond */
+	/* Resolution is one nanosecond */
+	tp->tv_sec = 0;
+	tp->tv_nsec = 1;
+	return 0;
 }
 
 static int ptp_clock_settime(struct posix_clock *pc, const struct timespec *tp)

