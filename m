Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1F2FoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1F2FoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:44:11 -0400
Message-ID: <4E0ABBAF.3020200@redhat.com>
Date: Wed, 29 Jun 2011 13:44:15 +0800
From: hank <pyu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: johnstul@us.ibm.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Change jiffies_to_clock_t function input parameter's,
 type to unsigned long
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dbc32d224ca024a98b2521a8a7bf20989bec34ee Mon Sep 17 00:00:00 2001
From: hank <pyu@redhat.com>
Date: Wed, 29 Jun 2011 09:17:45 +0800
Subject: [PATCH 1/1] Change jiffies_to_clock_t function input parameter's
 type to unsigned long

The parmaeter's origin type is long. On an i386 architecture, it can easily
larger than 0x80000000, then this function convert it to a u64 type, get a
result: 0xffffffff80000000, it is unexpected, so change the type to
unsigned long, we can get the correct result: 0x0000000080000000

Signed-off-by: hank <pyu@redhat.com>
---
 kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 8e8dc6d..d776062 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -575,7 +575,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
-- 
1.7.4.4



