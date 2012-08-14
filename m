Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2HNLtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:49:10 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34039 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2HNLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:49:08 -0400
Date: Tue, 14 Aug 2012 13:48:56 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Huacai Chen <chenhc@lemote.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        Yong Zhang <yong.zhang@windriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH V2] MIPS: Fix poweroff failure when HOTPLUG_CPU
 configured.
Message-ID: <20120814114856.GA17040@linux-mips.org>
References: <1344862344-27434-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344862344-27434-1-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 08:52:24PM +0800, Huacai Chen wrote:

> When poweroff machine, kernel_power_off() call disable_nonboot_cpus().
> And if we have HOTPLUG_CPU configured, disable_nonboot_cpus() is not an
> empty function but attempt to actually disable the nonboot cpus. Since
> system state is SYSTEM_POWER_OFF, play_dead() won't be called and thus
> disable_nonboot_cpus() hangs. Therefore, we make this patch to avoid
> poweroff failure.

> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
> index e9a5fd7..69b17a9 100644
> --- a/arch/mips/kernel/process.c
> +++ b/arch/mips/kernel/process.c
> @@ -72,9 +72,7 @@ void __noreturn cpu_idle(void)
>  			}
>  		}
>  #ifdef CONFIG_HOTPLUG_CPU
> -		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
> -		    (system_state == SYSTEM_RUNNING ||
> -		     system_state == SYSTEM_BOOTING))
> +		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))

Looks good - but I'm wondering if the "!cpu_isset(cpu, cpu_callin_map)"
can be removed as well?

Also, which -stable branches is this patch applicable?

  Ralf
