Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2DSRQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:16:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52959 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2DSRQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:16:13 -0400
Date: Thu, 19 Apr 2012 19:16:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/5] x86-64: Handle exception table entries during early
 boot
Message-ID: <20120419171609.GH3221@aftab.osrc.amd.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <1334794610-5546-5-git-send-email-hpa@zytor.com>
 <20120419130240.GE30447@aftab>
 <4F90445B.9050106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F90445B.9050106@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 09:59:07AM -0700, H. Peter Anvin wrote:
> The offsets in my code refer to offsets after we push the vector number,
> %rax, %rcx and %rdx onto the stack manually; that is 4*8 = 32 bytes,
> hence the offset.

Ah, sure, you push those upon entry into early_idt_handler, ok.

Btw, just tested the patchset here with the following hunk below and it
looks good.

Also, you can add a revert of ce37defc0f667 as the last one in your
patchset since the comment becomes invalid after it goes in.

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0a44b90..a3a6299 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -448,6 +448,8 @@ static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
 
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
+       u32 dummy1, dummy2;
+
        early_init_amd_mc(c);
 
        /*
@@ -479,6 +481,7 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
                        set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
        }
 #endif
+       rdmsr_safe(0xdeadbeef, &dummy1, &dummy2);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
