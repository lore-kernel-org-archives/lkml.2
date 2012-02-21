Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2BUKkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:40:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49457 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab2BUKkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:40:15 -0500
Date: Tue, 21 Feb 2012 11:40:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86: Move per cpu cpu_llc_id to a field in struct
 cpuinfo_x86
Message-ID: <20120221104020.GB2486@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <20120217115627.GA25601@elte.hu>
 <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
 <1329789966-693-3-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329789966-693-3-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 10:06:03PM -0400, Kevin Winchester wrote:
> This simplifies the various code paths using this field as it
> groups the per-cpu data together.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/include/asm/processor.h      |    2 ++
>  arch/x86/include/asm/smp.h            |    2 --
>  arch/x86/kernel/apic/apic_numachip.c  |    2 +-
>  arch/x86/kernel/cpu/amd.c             |   14 ++++----------
>  arch/x86/kernel/cpu/common.c          |    1 +
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   11 ++---------
>  arch/x86/kernel/smpboot.c             |   18 ++++++++----------
>  7 files changed, 18 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 0c8b574..2d4eb6f 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -111,6 +111,8 @@ struct cpuinfo_x86 {
>  	u16			cpu_index;
>  	u32			microcode;
>  	cpumask_t		llc_shared_map;
> +	/* cpus sharing the last level cache: */

Just a minor nitpick which I forgot: we spell "CPUs" in the comments as
in the next patch you're adding a comment about the sibling_map.

Thanks.

-- 
Regards/Gruss,
Boris.
