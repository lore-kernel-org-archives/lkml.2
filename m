Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab2EJRcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:32:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52242 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab2EJRcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:32:02 -0400
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com> <1336666614-21090-8-git-send-email-fenghua.yu@intel.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1336666614-21090-8-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 07/12] x86/head_32.S: Define start_cpu0
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 10 May 2012 10:31:08 -0700
To: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Message-ID: <878ae68a-72cf-40cb-a654-a2c1cb3df0c3@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you check how this interacts with tip:x86/realmode?

Fenghua Yu <fenghua.yu@intel.com> wrote:

>From: Fenghua Yu <fenghua.yu@intel.com>
>
>start_cpu0() is defined in head_32.S for 32-bit. The function sets up
>stack and
>jumps to start_secondary() for CPU0 wake up.
>
>Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>---
> arch/x86/kernel/head_32.S |   12 ++++++++++++
> 1 files changed, 12 insertions(+), 0 deletions(-)
>
>diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>index 463c979..a441303 100644
>--- a/arch/x86/kernel/head_32.S
>+++ b/arch/x86/kernel/head_32.S
>@@ -266,6 +266,18 @@ num_subarch_entries = (. - subarch_entries) / 4
> 	jmp default_entry
> #endif /* CONFIG_PARAVIRT */
> 
>+#ifdef CONFIG_HOTPLUG_CPU
>+/*
>+ * Boot CPU0 entry point. It's called from play_dead(). Everything has
>been set
>+ * up already except stack. We just set up stack here. Then call
>+ * start_secondary().
>+ */
>+ENTRY(start_cpu0)
>+	movl stack_start, %ecx
>+	movl %ecx, %esp
>+	jmp  *(initial_code)
>+#endif
>+
> /*
>  * Non-boot CPU entry point; entered from trampoline.S
>  * We can't lgdt here, because lgdt itself uses a data segment, but
>-- 
>1.6.0.3

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
