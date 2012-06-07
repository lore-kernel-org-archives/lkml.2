Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab2FGRuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:50:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633Ab2FGRuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:50:52 -0400
Message-ID: <4FD0E9F9.60906@gmail.com>
Date: Thu, 07 Jun 2012 10:50:49 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH RT 3/4] mips-remove-smp-reserve-lock.patch
References: <20120607155148.698959275@goodmis.org> <20120607155221.836885041@goodmis.org>
In-Reply-To: <20120607155221.836885041@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 08:51 AM, Steven Rostedt wrote:
> From: Thomas Gleixner<tglx@linutronix.de>
>
> Instead of making the lock raw, remove it as it protects nothing.

I don't know how you guys are managing the RT branch, but this seems 
quite similar to:

a3c8b4faeeccb33dbad6969bc9e50bf409f167e7 (MIPS: Cavium: Remove 
smp_reserve_lock.)

David Daney


>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> Cc: stable-rt@vger.kernel.org
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>   arch/mips/cavium-octeon/smp.c |    6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index efcfff4..86fce15 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -257,8 +257,6 @@ DEFINE_PER_CPU(int, cpu_state);
>
>   extern void fixup_irqs(void);
>
> -static DEFINE_SPINLOCK(smp_reserve_lock);
> -
>   static int octeon_cpu_disable(void)
>   {
>   	unsigned int cpu = smp_processor_id();
> @@ -266,8 +264,6 @@ static int octeon_cpu_disable(void)
>   	if (cpu == 0)
>   		return -EBUSY;
>
> -	spin_lock(&smp_reserve_lock);
> -
>   	cpu_clear(cpu, cpu_online_map);
>   	cpu_clear(cpu, cpu_callin_map);
>   	local_irq_disable();
> @@ -277,8 +273,6 @@ static int octeon_cpu_disable(void)
>   	flush_cache_all();
>   	local_flush_tlb_all();
>
> -	spin_unlock(&smp_reserve_lock);
> -
>   	return 0;
>   }
>

