Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab0HLPzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0HLPzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:55:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] MN10300: Fix RTC routines
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 12 Aug 2010 16:54:36 +0100
Message-ID: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A change to the RTC routines in the MN10300 arch used set_rtc_mms() when it
meant set_rtc_mmss().  This results in an error due to a reference of an
undefined symbol.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/rtc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)


diff --git a/arch/mn10300/kernel/rtc.c b/arch/mn10300/kernel/rtc.c
index 815a933..4eef0e7 100644
--- a/arch/mn10300/kernel/rtc.c
+++ b/arch/mn10300/kernel/rtc.c
@@ -20,9 +20,6 @@
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
-/* last time the RTC got updated */
-static long last_rtc_update;
-
 /* time for RTC to update itself in ioclks */
 static unsigned long mn10300_rtc_update_period;
 
@@ -110,7 +107,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 
 int update_persistent_clock(struct timespec now)
 {
-	return set_rtc_mms(now.tv_sec);
+	return set_rtc_mmss(now.tv_sec);
 }
 
 /*

