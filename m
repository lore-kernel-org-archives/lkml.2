Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1A0K6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:58:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53399 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1A0K6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IY4kmFcqf10CiyCF6niDy75WkBDCyZ8JzLndWeY5E506+N2LGbGMBuVc6yjB0x0zbP
         zj1BtyIWPV3Nuu9sj0VLbQ1xkSrOo2rZnpQW1GUXy/0BMP780st1ZAdvXA90t9EJBHMo
         udtRxiFxM+YP7pyyFAh2HnryRWOPGmzWmerz4=
Date: Thu, 27 Jan 2011 11:58:34 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH V10 10/15] posix clocks: remove useless default methods
Message-ID: <16925dc1baef5f57599b3fde55f8775d7b17e741.1296124770.git.richard.cochran@omicron.at>
References: <cover.1296124770.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1296124770.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the k_clocks which do not allow timers or sleeping, it does not make
sense to use the default "common" methods for these kinds of functions.
Thus we simply remove them.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 7a3683d..f227474 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -262,11 +262,6 @@ static __init int init_posix_timers(void)
 		.clock_adj = do_posix_clock_noadjtime,
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
-		/* defaults: */
-		.nsleep_restart	= common_nsleep_restart,
-		.timer_del	= common_timer_del,
-		.timer_get	= common_timer_get,
-		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres = posix_get_coarse_res,
@@ -275,11 +270,6 @@ static __init int init_posix_timers(void)
 		.clock_adj = do_posix_clock_noadjtime,
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
-		/* defaults: */
-		.nsleep_restart	= common_nsleep_restart,
-		.timer_del	= common_timer_del,
-		.timer_get	= common_timer_get,
-		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres = posix_get_coarse_res,
@@ -288,11 +278,6 @@ static __init int init_posix_timers(void)
 		.clock_adj = do_posix_clock_noadjtime,
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
-		/* defaults: */
-		.nsleep_restart	= common_nsleep_restart,
-		.timer_del	= common_timer_del,
-		.timer_get	= common_timer_get,
-		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_posix_cpu = {
 		.clock_getres	= posix_cpu_clock_getres,
-- 
1.7.0.4

