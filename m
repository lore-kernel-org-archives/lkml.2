Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2AXAGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:06:19 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51665 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2AXAGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:06:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ralf Baechle <ralf@linux-mips.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-mips@linux-mips.org
Subject: [PATCH 3/3] clocksource: Convert mips pnx8550 to use clocksource_register_hz
Date: Mon, 23 Jan 2012 16:05:50 -0800
Message-Id: <1327363550-19952-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
References: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012400-7282-0000-0000-000005DDD2CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the registration to use clocksource_register_hz()
but is clearly broken, as the pnx_clocksource doesn't seem to set a
proper mult/shift pair.

CC: Ralf Baechle <ralf@linux-mips.org>
CC: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-mips@linux-mips.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/mips/pnx8550/common/time.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pnx8550/common/time.c b/arch/mips/pnx8550/common/time.c
index 831d6b3..006ac88 100644
--- a/arch/mips/pnx8550/common/time.c
+++ b/arch/mips/pnx8550/common/time.c
@@ -104,7 +104,12 @@ __init void plat_time_init(void)
 
 	pnx8xxx_clockevent.cpumask = cpu_none_mask;
 	clockevents_register_device(&pnx8xxx_clockevent);
-	clocksource_register(&pnx_clocksource);
+	
+	/*
+	 * XXX - Nothing seems to set pnx_clocksource mult/shift! 
+	 * So I don't know what freq to use here. Help! -johnstul
+	 */
+	clocksource_register_hz(&pnx_clocksource, 0);
 
 	/* Timer 1 start */
 	configPR = read_c0_config7();
-- 
1.7.3.2.146.gca209

