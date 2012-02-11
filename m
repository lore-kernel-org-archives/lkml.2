Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2BKXEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:04:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56538 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab2BKXEH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:04:07 -0500
Message-ID: <1329001452.325.59.camel@deadeye>
Subject: [PATCH] powernow-k6: Really enable auto-loading
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Date: Sat, 11 Feb 2012 23:04:12 +0000
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
for x86 cpuinfo auto loading v4') added a device ID table to this
driver, but didn't declare it as the module device ID table.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This looks like an oversight, but maybe there is some good reason why
this one shouldn't be auto-loaded?

Ben.

 drivers/cpufreq/powernow-k6.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 54dd031..af23e0b 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -216,7 +216,7 @@ static const struct x86_cpu_id powernow_k6_ids[] = {
 	{ X86_VENDOR_AMD, 5, 13 },
 	{}
 };
-
+MODULE_DEVICE_TABLE(x86cpu, powernow_k6_ids);
 
 /**
  * powernow_k6_init - initializes the k6 PowerNow! CPUFreq driver
-- 
1.7.9


