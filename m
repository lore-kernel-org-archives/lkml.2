Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1ALLbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:31:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:44703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1ALLbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:31:05 -0500
Date: Wed, 12 Jan 2011 11:30:47 GMT
From: tip-bot for Nicolas Pitre <nico@fluxnic.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, nicolas.pitre@linaro.org, tglx@linutronix.de,
        nico@fluxnic.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, nicolas.pitre@linaro.org, tglx@linutronix.de,
        nico@fluxnic.net
In-Reply-To: <alpine.LFD.2.00.1101111207140.17086@xanadu.home>
References: <alpine.LFD.2.00.1101111207140.17086@xanadu.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Rename misnamed minsec argument of clocks_calc_mult_shift()
Message-ID: <tip-5fdade95f26372154459347dfb9f60721d22cfc7@git.kernel.org>
Git-Commit-ID: 5fdade95f26372154459347dfb9f60721d22cfc7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 Jan 2011 11:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fdade95f26372154459347dfb9f60721d22cfc7
Gitweb:     http://git.kernel.org/tip/5fdade95f26372154459347dfb9f60721d22cfc7
Author:     Nicolas Pitre <nico@fluxnic.net>
AuthorDate: Tue, 11 Jan 2011 12:18:12 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Jan 2011 12:23:12 +0100

time: Rename misnamed minsec argument of clocks_calc_mult_shift()

The minsec argument to clocks_calc_mult_shift() is misnamed. It is used 
to clamp the magnitude of the mult factor so that a multiplication with 
any value in the given range won't overflow a 64 bit result.  Let's 
rename it to match the actual usage.

Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Acked-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <alpine.LFD.2.00.1101111207140.17086@xanadu.home>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/clocksource.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..8588abc 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -113,7 +113,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * @shift:	pointer to shift variable
  * @from:	frequency to convert from
  * @to:		frequency to convert to
- * @minsec:	guaranteed runtime conversion range in seconds
+ * @maxsec:	guaranteed runtime conversion range in seconds
  *
  * The function evaluates the shift/mult pair for the scaled math
  * operations of clocksources and clockevents.
@@ -122,7 +122,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * NSEC_PER_SEC == 1GHz and @from is the counter frequency. For clock
  * event @to is the counter frequency and @from is NSEC_PER_SEC.
  *
- * The @minsec conversion range argument controls the time frame in
+ * The @maxsec conversion range argument controls the time frame in
  * seconds which must be covered by the runtime conversion with the
  * calculated mult and shift factors. This guarantees that no 64bit
  * overflow happens when the input value of the conversion is
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * factors.
  */
 void
-clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 {
 	u64 tmp;
 	u32 sft, sftacc= 32;
@@ -140,7 +140,7 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
 	 * Calculate the shift factor which is limiting the conversion
 	 * range:
 	 */
-	tmp = ((u64)minsec * from) >> 32;
+	tmp = ((u64)maxsec * from) >> 32;
 	while (tmp) {
 		tmp >>=1;
 		sftacc--;
