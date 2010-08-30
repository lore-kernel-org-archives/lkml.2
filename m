Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0H3H6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:58:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10327 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0H3H6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:58:11 -0400
Date: Mon, 30 Aug 2010 09:57:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [lm-sensors] [Patch-next]therm_throt.c: Trival fix for a
 unsuitable  abbreviation of thermal.
Message-ID: <20100830095753.6724bc89@hyperion.delvare>
In-Reply-To: <4C7B6358.3040703@np.css.fujitsu.com>
References: <4C7B6358.3040703@np.css.fujitsu.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 16:52:56 +0900, Jin Dongming wrote:
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
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index d9368ee..2f9f468 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -349,7 +349,7 @@ static void intel_thermal_interrupt(void)
>  
>  static void unexpected_thermal_interrupt(void)
>  {
> -	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
> +	printk(KERN_ERR "CPU%d: Unexpected LVT Thermal Interrupt!\n",
>  			smp_processor_id());
>  	add_taint(TAINT_MACHINE_CHECK);
>  }

I see no good reason to upper-case the first letter of each word. This
is a kernel log message, not a movie title.

Other than that, I agree with your proposal.


-- 
Jean Delvare
