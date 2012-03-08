Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab2CHXoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:44:38 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4026 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042Ab2CHXog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:44:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 08 Mar 2012 15:44:16 -0800
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Phil Carmody'" <ext-phil.2.carmody@nokia.com>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Sameer Nanda'" <snanda@chromium.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>
Date: Thu, 8 Mar 2012 15:44:16 -0800
Subject: [PATCH] init: check printed flag to skip printing message
Thread-Topic: [PATCH] init: check printed flag to skip printing message
Thread-Index: AczgU0erG2gZs14gRdCqHlqSrZe0nwcX5wagADRp3wA=
Message-ID: <1DD7BFEDD3147247B1355BEFEFE4665237994F30F4@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	 <1328024684.2446.234.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
 <1328040137.2446.242.camel@twins>
 <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the 'Calibration skipped' message gets printed everytime a CPU is
hotplugged in, cluttering console for systems that frequently hotplug CPUs.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
---
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 5f117ca..fda0a7b 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -267,7 +267,8 @@ void __cpuinit calibrate_delay(void)
 
	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
-		pr_info("Calibrating delay loop (skipped) "
+		if (!printed)
+			pr_info("Calibrating delay loop (skipped) "
 			"already calibrated this CPU");
	} else if (preset_lpj) {
		lpj = preset_lpj;
