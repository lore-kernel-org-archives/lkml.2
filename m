Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0GZIy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:54:56 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:62088 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab0GZIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:54:55 -0400
Subject: [PATCH] timer_list: remove alignment padding on 64 bit when
 CONFIG_TIMER_STATS
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 09:54:52 +0100
Message-ID: <1280134492.2017.9.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-order structure timer_list to remove 8 bytes of alignment padding on
64 bit builds when CONFIG_TIMER_STATS is selected.
    
timer_list is widely used across the kernel so many structures will
benefit and shrink in size.

For example, with my config on x86_64
	per_cpu_dm_data shrinks from 136 to 128 bytes
and
	ahci_port_priv shrinks from 1032 to 968 bytes.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against v2.6.35-rc6
compiled & tested on x86_64

regards
Richard


diff --git a/include/linux/timer.h b/include/linux/timer.h
index ea965b8..14a6fd4 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -24,9 +24,9 @@ struct timer_list {
 	int slack;
 
 #ifdef CONFIG_TIMER_STATS
+	int start_pid;
 	void *start_site;
 	char start_comm[16];
-	int start_pid;
 #endif
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;


