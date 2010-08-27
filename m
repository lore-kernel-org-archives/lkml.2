Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0H0NUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:20:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22627 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0H0NU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:20:28 -0400
Date: Fri, 27 Aug 2010 15:20:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [lm-sensors] [Patch-next] therm_throt.c: fix missing { and }.
Message-ID: <20100827152007.27636fa5@hyperion.delvare>
In-Reply-To: <4C7625D1.4060201@np.css.fujitsu.com>
References: <4C75D3C4.6040802@np.css.fujitsu.com>
	<20100826060822.GA15021@fenghua-desk.sc.intel.com>
	<4C7625D1.4060201@np.css.fujitsu.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 17:29:05 +0900, Jin Dongming wrote:
> When the feature PTS is not supported by CPU, the sysfile
> package_power_limit_count for package should not be generated.
> 
> This patch is used for fixing missing { and }. But I have not confirmed
> this patch because I don't have such machine.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index d9368ee..169d880 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -216,7 +216,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_core_power_limit_count.attr,
>  					      thermal_attr_group.name);
> -	if (cpu_has(c, X86_FEATURE_PTS))
> +	if (cpu_has(c, X86_FEATURE_PTS)) {
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_package_throttle_count.attr,
>  					      thermal_attr_group.name);
> @@ -224,6 +224,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
>  			err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					&attr_package_power_limit_count.attr,
>  					thermal_attr_group.name);
> +	}
>  
>  	return err;
>  }

This is incomplete. Error handling in this function is totally broken.


-- 
Jean Delvare
