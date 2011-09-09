Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab1IIVV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:21:56 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:30700 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668Ab1IIVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:21:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1315600120!34068741!427
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] e820.c: quiet sparse noise about plain integer as NULL pointer
Date: Fri, 9 Sep 2011 14:20:52 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <akpm@linux-foundation.org>, <kamal@canonical.com>,
        <paul.gortmaker@windriver.com>, <mditto@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091420.52593.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last parameter to sort() is a pointer to the function used to swap
items.  This parameter should be NULL, not 0, when not used.  This quiets
the following sparse warning:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamal Mostafa <kamal@canonical.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mike Ditto <mditto@google.com>

---

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index f655f80..d6bd853 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -296,7 +296,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 	chg_nr = chgidx;
 
 	/* sort change-point list by memory addresses (low -> high) */
-	sort(change_point, chg_nr, sizeof *change_point, cpcompare, 0);
+	sort(change_point, chg_nr, sizeof *change_point, cpcompare, NULL);
 
 	/* create a new bios memory map, removing overlaps */
 	overlap_entries = 0;	 /* number of entries in the overlap table */
