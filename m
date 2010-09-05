Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0IEQ7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:59:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27630 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0IEQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:59:44 -0400
Date: Sun, 5 Sep 2010 18:59:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jin.dongming@np.css.fujitsu.com, lm-sensors@lm-sensors.org,
        seto.hidetoshi@jp.fujitsu.com, fenghua.yu@intel.com,
        khali@linux-fr.org, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu, len.brown@intel.com
Cc: jin.dongming@np.css.fujitsu.com, linux-tip-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, lm-sensors@lm-sensors.org,
        seto.hidetoshi@jp.fujitsu.com, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu,
        len.brown@intel.com
Subject: Re: [tip:x86/debug] therm_throt.c: Trival printk message fix for a
 unsuitable abbreviation of 'thermal'
Message-ID: <20100905185921.13c7c3f5@hyperion.delvare>
In-Reply-To: <tip-6981fe03b2055685fb6da40f54518bc6baf2b751@git.kernel.org>
References: <4C7C492D.5020704@np.css.fujitsu.com>
	<tip-6981fe03b2055685fb6da40f54518bc6baf2b751@git.kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6 people and 2 mailing lists Cc'd for a one-line trivial patch??

On Sun, 5 Sep 2010 13:06:45 GMT, tip-bot for Jin Dongming wrote:
> Commit-ID:  6981fe03b2055685fb6da40f54518bc6baf2b751
> Gitweb:     http://git.kernel.org/tip/6981fe03b2055685fb6da40f54518bc6baf2b751
> Author:     Jin Dongming <jin.dongming@np.css.fujitsu.com>
> AuthorDate: Tue, 31 Aug 2010 09:13:33 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 5 Sep 2010 14:39:15 +0200
> 
> therm_throt.c: Trival printk message fix for a unsuitable abbreviation of 'thermal'

Typo: trivial.

> 
> In unexpected_thermal_interrupt(), "LVT TMR interrupt" is used
> in error message.
> 
> I don't think TMR is a suitable abbreviation for thermal.
>   1.TMR has been used in IA32 Architectures Software Developer's
>     Manual, and is the abbreviation for Trigger Mode Register.
>   2.There is not an standard abbreviation "TMR" defined for thermal
>     in IA32 Architectures Software Developer's Manual.
>   3.Though we could understand it as Thermal Monitor Register, it is
>     easy to be misunderstood as a *TIMER* interrupt also.
> 
> I think this patch will fix it.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> Cc: Brown
> Cc: Len <len.brown@intel.com>

Something's fishy here.

> Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: lm-sensors@lm-sensors.org <lm-sensors@lm-sensors.org>

Mailing lists shouldn't be included in Cc headers.

> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Jean Delvare <khali@linux-fr.org>

This should read:

Reviewed-by: Jean Delvare <khali@linux-fr.org>

> Cc: Fenghua Yu <fenghua.yu@intel.com>
> LKML-Reference: <4C7C492D.5020704@np.css.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index c2a8b26..1d0f743 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -348,7 +348,7 @@ static void intel_thermal_interrupt(void)
>  
>  static void unexpected_thermal_interrupt(void)
>  {
> -	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
> +	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
>  			smp_processor_id());
>  	add_taint(TAINT_MACHINE_CHECK);
>  }


-- 
Jean Delvare
