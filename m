Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2DDMiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:38:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33680 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab2DDMiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:38:13 -0400
Date: Wed, 4 Apr 2012 14:38:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sp@numascale.com, bp@amd64.org, tglx@linutronix.de,
        borislav.petkov@amd.com, daniel@numascale-asia.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH resend] x86/platform: Remove incorrect error message in
 x86_default_fixup_cpu_id()
Message-ID: <20120404123809.GB5193@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, sp@numascale.com, bp@amd64.org,
	tglx@linutronix.de, borislav.petkov@amd.com,
	daniel@numascale-asia.com,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <20120224153127.GD28921@alberich.amd.com>
 <tip-20b25f03fbd17b4e32b786024a5f9c6306795411@git.kernel.org>
 <20120302110440.GA24019@elte.hu>
 <20120302115130.GA17876@alberich.amd.com>
 <20120402160648.GR27684@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120402160648.GR27684@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 06:06:48PM +0200, Andreas Herrmann wrote:
> 
> It's only called from amd.c:srat_detect_node(). The introduced
> condition for calling the fixup code is true for all AMD multi-node
> processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
> nodes on one socket. Thus there are cores having different
> numa-node-id but with equal phys_proc_id.
> 
> There is no point to print error messages in such a situation.
> 
> The confusing/misleading error message was introduced with commit
> 64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
> override to fix up NUMA core numbering).
> 
> Remove the default fixup function (especially the error message) and
> replace it by a NULL pointer check, move the Numascale-specific
> condition for calling the fixup into the fixup-function itself and
> slightly adapt the comment.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/include/asm/x86_init.h      |    1 -
>  arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
>  arch/x86/kernel/cpu/amd.c            |    7 ++++---
>  arch/x86/kernel/cpu/common.c         |    9 ---------
>  arch/x86/kernel/x86_init.c           |    1 -
>  5 files changed, 9 insertions(+), 16 deletions(-)
> 
> This patch didn't make it into v3.3.
> But the misleading error message introduced with numachip support was
> merged.

Yes, please apply this one, I still get the following on my box with
3.4-rc1+:

[    0.382396] Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
[    0.454471] Booting Node   1, Processors  #6
[    0.469600] NUMA core number 1 differs from configured core number 0
[    0.478361]  #7
[    0.490949] NUMA core number 1 differs from configured core number 0
[    0.499695]  #8
[    0.512577] NUMA core number 1 differs from configured core number 0
[    0.521331]  #9
[    0.533921] NUMA core number 1 differs from configured core number 0
[    0.542679]  #10
[    0.555340] NUMA core number 1 differs from configured core number 0
[    0.564088]  #11
[    0.576730] NUMA core number 1 differs from configured core number 0
[    0.585497]  Ok.
[    0.587698] Booting Node   3, Processors  #12
[    0.602916] NUMA core number 3 differs from configured core number 1
[    0.709432]  #13
[    0.722106] NUMA core number 3 differs from configured core number 1
[    0.730856]  #14
[    0.743823] NUMA core number 3 differs from configured core number 1
[    0.752577]  #15
[    0.765253] NUMA core number 3 differs from configured core number 1
[    0.774002]  #16
[    0.786684] NUMA core number 3 differs from configured core number 1
[    0.795436]  #17
[    0.808113] NUMA core number 3 differs from configured core number 1
[    0.816878]  Ok.
[    0.819377] Booting Node   2, Processors  #18
[    0.834597] NUMA core number 2 differs from configured core number 1
[    0.843348]  #19
[    0.856025] NUMA core number 2 differs from configured core number 1
[    0.864777]  #20
[    0.877750] NUMA core number 2 differs from configured core number 1
[    0.886505]  #21
[    0.899180] NUMA core number 2 differs from configured core number 1
[    0.907939]  #22
[    0.920583] NUMA core number 2 differs from configured core number 1
[    0.929335]  #23 Ok.
[    0.942785] NUMA core number 2 differs from configured core number 1
[    0.951262] Brought up 24 CPUs

Thanks.

-- 
Regards/Gruss,
Boris.
