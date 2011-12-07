Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab1LGQUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab1LGQUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:29 2011
Message-Id: <20111207160829.070713264@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:39 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "Yang Honggang (Joseph)" <eagle.rtlinux@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [79/80] clocksource: Fix bug with max_deferment margin calculation
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yang Honggang (Joseph)" <eagle.rtlinux@gmail.com>

commit b1f919664d04a8d0ba29cb76673c7ca3325a2006 upstream.

In order to leave a margin of 12.5% we should >> 3 not >> 5.

Signed-off-by: Yang Honggang (Joseph) <eagle.rtlinux@gmail.com>
[jstultz: Modified commit subject]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clocksource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -531,7 +531,7 @@ static u64 clocksource_max_deferment(str
 	 * note a margin of 12.5% is used because this can be computed with
 	 * a shift, versus say 10% which would require division.
 	 */
-	return max_nsecs - (max_nsecs >> 5);
+	return max_nsecs - (max_nsecs >> 3);
 }
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
@@ -653,7 +653,7 @@ void __clocksource_updatefreq_scale(stru
 	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
 	 * margin as we do in clocksource_max_deferment()
 	 */
-	sec = (cs->mask - (cs->mask >> 5));
+	sec = (cs->mask - (cs->mask >> 3));
 	do_div(sec, freq);
 	do_div(sec, scale);
 	if (!sec)


