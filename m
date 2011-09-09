Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983Ab1IIXJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:09:37 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:12720 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab1IIXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:09:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1315609775!31061392!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/x86/mm/init_32.c: quiet sparse noise; local functions should be static
Date: Fri, 9 Sep 2011 16:09:23 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tj@kernel.org>, <yinghai@kernel.org>, <bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091609.23433.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local functions should be marked static.  This quiets the following
sparse noise:

warning: symbol 'lowmem_pfn_init' was not declared. Should it be static?
warning: symbol 'highmem_pfn_init' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers,com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de> 

---

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 29f7c6d..cc56c76 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -560,7 +560,7 @@ early_param("highmem", parse_highmem);
  * artificially via the highmem=x boot parameter then create
  * it:
  */
-void __init lowmem_pfn_init(void)
+static void __init lowmem_pfn_init(void)
 {
 	/* max_low_pfn is 0, we already have early_res support */
 	max_low_pfn = max_pfn;
@@ -596,7 +596,7 @@ void __init lowmem_pfn_init(void)
  * We have more RAM than fits into lowmem - we try to put it into
  * highmem, also taking the highmem=x boot parameter into account:
  */
-void __init highmem_pfn_init(void)
+static void __init highmem_pfn_init(void)
 {
 	max_low_pfn = MAXMEM_PFN;
 
