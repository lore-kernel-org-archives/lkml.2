Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2IZKKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:10:24 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1934 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969Ab2IZKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:09:51 -0400
Message-ID: <1348654189.1664.12.camel@x61.thuisdomein>
Subject: [PATCH] x86, tsc: downgrade message for fast calibration failure
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Sep 2012 12:09:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2012 10:09:50.0453 (UTC) FILETIME=[10B64A50:01CD9BCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fast calibration of the TSC fails an error is printed:
    tsc: Fast TSC calibration failed

This message was printed at default level (ie, as a warning) before
commit c767a54ba0657e52e6edaa97cbe0b0a8bf1c1655 ("x86/debug: Add
KERN_<LEVEL> to bare printks, convert printks to pr_<level>"). But it is
more appropriate to print it at informational level. If fast calibration
fails that only means an alternative calibration strategy will be tried,
and if that strategy also fails only a warning is printed. Besides,
there's nothing one can really do after noticing a fast calibration
failure.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This is a rather verbose commit explanation. For trivialities like
these I try to write a very short explanation. But here the verbosity is
meant to obfuscate my complete ignorance of the (calibration of the)
TSC.

1) By the way, it's debatable whether this message should be printed at
informational or at notice level. But the difference between KERN_NOTICE
and KERN_INFO is too subtle for me. I even find the difference between
KERN_ALERT and KERN_CRIT, and between KERN_ERR and KERN_WARNING a bit
subtle. Are there guidelines for choosing between those levels?

 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..4f258ae 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -374,7 +374,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration failed\n");
 	return 0;
 
 success:
-- 
1.7.11.4

