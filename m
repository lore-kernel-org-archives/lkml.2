Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2BUOV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:21:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49885 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2BUOV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:21:28 -0500
Date: Tue, 21 Feb 2012 15:21:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: Move per cpu cpu_core_map to a field in struct
 cpuinfo_x86
Message-ID: <20120221142131.GD2486@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <20120217115627.GA25601@elte.hu>
 <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
 <1329789966-693-5-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329789966-693-5-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 10:06:05PM -0400, Kevin Winchester wrote:
> This simplifies the various code paths using this field as it
> groups the per-cpu data together.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/include/asm/smp.h       |    6 ------
>  arch/x86/include/asm/topology.h  |    4 ++--
>  arch/x86/kernel/cpu/proc.c       |    3 +--
>  arch/x86/kernel/smpboot.c        |   35 ++++++++++++++---------------------
>  arch/x86/xen/smp.c               |    4 ----
>  drivers/cpufreq/acpi-cpufreq.c   |    2 +-
>  drivers/cpufreq/powernow-k8.c    |   13 +++----------
>  8 files changed, 23 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 38de3aa..53f7a8c 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -115,6 +115,8 @@ struct cpuinfo_x86 {
>  	u16			llc_id;
>  	/* representing HT siblings of each logical CPU */
>  	cpumask_t		sibling_map;
> +	/* representing HT and core siblings of each logical CPU */

Let's change that to be more clear:

	"representing all execution threads on a logical CPU, i.e. per physical
	socket"

or if someone has an even better formulation...

other than that:

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
