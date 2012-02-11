Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2BKWz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 17:55:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56473 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505Ab2BKWz6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 17:55:58 -0500
Message-ID: <1329000959.325.56.camel@deadeye>
Subject: [PATCH 5/5] powernow-k7: Fix CPU family number
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Date: Sat, 11 Feb 2012 22:55:59 +0000
In-Reply-To: <1329000256.325.48.camel@deadeye>
References: <1329000256.325.48.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fa8031aefec0cf7ea6c2387c93610d99d9659aa2 ('cpufreq: Add support
for x86 cpuinfo auto loading v4') seems to have inadvertently changed
the matched CPU family number from 6 to 7.  Change it back.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cpufreq/powernow-k7.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 501d167..cf7e1ee 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -112,7 +112,7 @@ static int check_fsb(unsigned int fsbspeed)
 }
 
 static const struct x86_cpu_id powernow_k7_cpuids[] = {
-	{ X86_VENDOR_AMD, 7, },
+	{ X86_VENDOR_AMD, 6, },
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, powernow_k7_cpuids);
-- 
1.7.9


