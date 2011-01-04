Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1ADPqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:46:35 -0500
Received: from mail.bspu.unibel.by ([195.50.2.21]:42650 "EHLO mail.bspu.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104Ab1ADPqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:46:34 -0500
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2011 10:46:34 EST
Message-ID: <4D2339F7.3090502@bspu.unibel.by>
Date: Tue, 04 Jan 2011 17:17:11 +0200
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b7pre) Gecko/20101123 Firefox/4.0b7pre SeaMonkey/2.1b1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix miscompiling with GCC 4.5 -finline-functions
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing broken automatic inlining for GCC 4.5+  (breaks build with
-finline-functions or -O3 on x86_*).

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>
---
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -569,7 +569,7 @@ static inline void ept_sync_individual_a
 	}
 }

-static unsigned long vmcs_readl(unsigned long field)
+static noinline unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value = 0;

--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -71,7 +71,7 @@ static struct rtrack rtrack_card;

 /* local things */

-static void sleep_delay(long n)
+static noinline void sleep_delay(long n)
 {
 	/* Sleep nicely for 'n' uS */
 	int d = n / msecs_to_jiffies(1000);
--
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/
