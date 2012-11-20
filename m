Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2KTIVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:21:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55667 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2KTIVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:21:09 -0500
Message-ID: <50AB3D72.1050301@jp.fujitsu.com>
Date: Tue, 20 Nov 2012 17:21:06 +0900
From: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
Organization: Fujitsu Limited
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>, John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ntp: fix return value of adjtimex() calling for STA_INS/DEL
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d,
adjtimex() system call returns TIME_OK even if STA_INS/DEL calling.
But the man page says it should be TIME_INS/TIME_DEL, respectively.

I have no idea except for such an ad-hoc fix.

Signed-off-by: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>

--- a/kernel/time/ntp.c	2012-11-20 17:09:08.000000000 +0900
+++ b/kernel/time/ntp.c	2012-11-20 17:13:18.000000000 +0900
@@ -684,6 +684,10 @@ int do_adjtimex(struct timex *txc)
 	}
 
 	result = time_state;	/* mostly `TIME_OK' */
+	if (time_status & STA_INS)
+		result = TIME_INS;
+	else if (time_status & STA_DEL)
+		result = TIME_DEL;
 	/* check for errors */
 	if (is_error_status(time_status))
 		result = TIME_ERROR;
