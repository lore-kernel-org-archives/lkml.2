Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0JCJhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 05:37:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57021 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab0JCJhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 05:37:04 -0400
Date: Sun, 3 Oct 2010 11:37:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: NOPL on 32-bit
Message-ID: <20101003093701.GB3733@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it looks like we currently clear X86_FEATURE_NOPL in detect_nopl()
unconditionally and not only on 32-bit, as it should be according to
ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8.

I'm thinking maybe something like the following might be in order

--
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index caa967d..9a2cfeb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -713,7 +713,9 @@ void __init early_cpu_init(void)
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 	clear_cpu_cap(c, X86_FEATURE_NOPL);
+#endif
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
--

or maybe get even more radical and rip out the whole X86_FEATURE_NOPL
thing?

-- 
Regards/Gruss,
    Boris.
