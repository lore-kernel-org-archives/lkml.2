Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2BVQOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:14:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2BVQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:14:05 -0500
Date: Wed, 22 Feb 2012 08:13:08 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-jceb26fns5w7tv8edlivhxpa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, jim.cromie@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, jim.cromie@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: scx200_hrt: Fix the build
Git-Commit-ID: 10ea9d6f5663c3ed51f91cd037b4b9b147273cbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:13:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10ea9d6f5663c3ed51f91cd037b4b9b147273cbb
Gitweb:     http://git.kernel.org/tip/10ea9d6f5663c3ed51f91cd037b4b9b147273cbb
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 22 Feb 2012 13:19:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 13:25:16 +0100

clocksource: scx200_hrt: Fix the build

This commit:

  12d6d41276de: clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz

Breaks the build on x86-32:

  drivers/clocksource/scx200_hrt.c: In function ‘init_hrt_clocksource’:
  drivers/clocksource/scx200_hrt.c:95:0: error: unterminated argument list invoking macro "pr_info"
  drivers/clocksource/scx200_hrt.c:84:2: error: ‘pr_info’ undeclared (first use in this function)

It could not possibly have been build tested, because it had this mismerge:

	pr_info("enabling scx200 high-res timer (%s MHz +%d ppm)\n",
	printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
		mhz27 ? "27":"1", ppm);

Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/n/tip-jceb26fns5w7tv8edlivhxpa@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/clocksource/scx200_hrt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx200_hrt.c
index 60db8b1..64f9e82 100644
--- a/drivers/clocksource/scx200_hrt.c
+++ b/drivers/clocksource/scx200_hrt.c
@@ -81,9 +81,7 @@ static int __init init_hrt_clocksource(void)
 	if (mhz27)
 		freq *= 27;
 
-	pr_info("enabling scx200 high-res timer (%s MHz +%d ppm)\n",
-	printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
-		mhz27 ? "27":"1", ppm);
+	pr_info("enabling scx200 high-res timer (%s MHz +%d ppm)\n", mhz27 ? "27":"1", ppm);
 
 	return clocksource_register_hz(&cs_hrt, freq);
 }
