Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1JIL2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:28:21 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:6218
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab1JIL2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:28:19 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z37d5kz1432N98dKzz1202hzz8275bh8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LSSQIO-02-427-02
X-M-MSG: 
Date: Sun, 9 Oct 2011 13:27:55 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <bp@amd64.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CPU hotplug,x86 Microcode: Don't request microcode from
 userspace unnecessarily
Message-ID: <20111009112755.GC17926@aftab>
References: <4E90B6F9.8020804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E90B6F9.8020804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08, 2011 at 04:47:53PM -0400, Srivatsa S. Bhat wrote:
> Requesting the microcode from userspace *every time* when onlining CPUs
> (during a CPU hotplug operation) is unnecessary.
> 
> So, this patch ensures that once the kernel gets the microcode after booting,
> it is not freed nor invalidated when a CPU goes offline, so that it can be
> reused when that CPU comes back online, without requesting userspace for it
> again. As a result, the CPU hotplug operations become faster as well.
> 
> Tested-by: Borislav Petkov <bp@amd64.org>
> Acked-by: Borislav Petkov <bp@amd64.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Good, thanks. Just a minor nitpick below.

> ---
> 
>  arch/x86/kernel/microcode_core.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index f924280..3fd0189 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -483,7 +483,13 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>  		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>  		pr_debug("CPU%d removed\n", cpu);
>  		break;
> -	case CPU_DEAD:
> +
> +	/* When a CPU goes offline, don't free up or invalidate the copy of
> +	 * the microcode in kernel memory, so that we can reuse it when the
> +	 * CPU comes back online without unnecessarily requesting the userspace
> +	 * for it again.
> +	 */
> +

Kernel comment style is in this format:

/*
 * Blabla
 * blublu
 */

@Ingo, can you please adjust it in-flight when applying?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

