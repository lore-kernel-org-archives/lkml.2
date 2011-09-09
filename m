Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab1IIXOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:14:17 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:38639 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741Ab1IIXOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:14:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1315610054!14844263!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/x86/mm/pageattr.c: quiet sparse noise; local functions should be static
Date: Fri, 9 Sep 2011 16:14:04 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <castet.matthieu@free.fr>, <sliakh.lkml@gmail.com>,
        <jiang@cs.ncsu.edu>, <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201109091614.05314.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local functions should be marked static.  This quiets the following
sparse noise:

warning: symbol '_set_memory_array' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: Xuxian Jiang <jiang@cs.ncsu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f9e5267..eda2acb 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -998,7 +998,7 @@ out_err:
 }
 EXPORT_SYMBOL(set_memory_uc);
 
-int _set_memory_array(unsigned long *addr, int addrinarray,
+static int _set_memory_array(unsigned long *addr, int addrinarray,
 		unsigned long new_type)
 {
 	int i, j;
