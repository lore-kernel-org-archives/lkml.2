Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab1LPTtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:49:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760623Ab1LPTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:56 2011
Message-Id: <20111216194556.616948785@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: [16/53] ptp: Fix clock_getres() implementation
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit d68fb11c3dae75c8331538dcf083a65e697cc034 upstream.

The clock_getres() function must return the resolution in the timespec
argument and return 0 for success.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ptp/ptp_clock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -101,7 +101,9 @@ static s32 scaled_ppm_to_ppb(long ppm)
 
 static int ptp_clock_getres(struct posix_clock *pc, struct timespec *tp)
 {
-	return 1; /* always round timer functions to one nanosecond */
+	tp->tv_sec = 0;
+	tp->tv_nsec = 1;
+	return 0;
 }
 
 static int ptp_clock_settime(struct posix_clock *pc, const struct timespec *tp)


