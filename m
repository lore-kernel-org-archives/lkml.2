Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab2CIALK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:11:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43853 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757866Ab2CIALI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:11:08 -0500
Message-ID: <1331251863.30848.4.camel@joe2Laptop>
Subject: Re: [PATCH] init: check printed flag to skip printing message
From: Joe Perches <joe@perches.com>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Phil Carmody'" <ext-phil.2.carmody@nokia.com>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Sameer Nanda'" <snanda@chromium.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>
Date: Thu, 08 Mar 2012 16:11:03 -0800
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE4665237994F30F4@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	 <1328024684.2446.234.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
	 <1328040137.2446.242.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE4665237994F30F4@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 15:44 -0800, Diwakar Tundlam wrote:
> Otherwise the 'Calibration skipped' message gets printed everytime a CPU is
> hotplugged in, cluttering console for systems that frequently hotplug CPUs.

Perhaps this is more uniform and it saves a few bytes too.

$ size init/calibrate.o*
   text	   data	    bss	    dec	    hex	filename
   2933	     73	    521	   3527	    dc7	init/calibrate.o.new
   2957	     73	    513	   3543	    dd7	init/calibrate.o.old

 init/calibrate.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 5f117ca..4f0af03 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -267,31 +267,32 @@ void __cpuinit calibrate_delay(void)
 
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
-		pr_info("Calibrating delay loop (skipped) "
-				"already calibrated this CPU");
+		if (!printed)
+			pr_info("Calibrating delay loop%s",
+				" (skipped) already calibrated this CPU");
 	} else if (preset_lpj) {
 		lpj = preset_lpj;
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"preset value.. ");
+			pr_info("Calibrating delay loop%s",
+				" (skipped) preset value..");
 	} else if ((!printed) && lpj_fine) {
 		lpj = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		pr_info("Calibrating delay loop%s",
+			" (skipped), value calculated using timer frequency..");
 	} else if ((lpj = calibrate_delay_is_known())) {
 		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
-			pr_info("Calibrating delay using timer "
-				"specific routine.. ");
+			pr_info("Calibrating delay loop%s",
+				" using timer specific routine..");
 	} else {
 		if (!printed)
-			pr_info("Calibrating delay loop... ");
+			pr_info("Calibrating delay loop%s", "...");
 		lpj = calibrate_delay_converge();
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
 	if (!printed)
-		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
+		pr_cont(" %lu.%02lu BogoMIPS (lpj=%lu)\n",
 			lpj/(500000/HZ),
 			(lpj/(5000/HZ)) % 100, lpj);
 


