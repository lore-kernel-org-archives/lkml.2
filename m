Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2HXJeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:34:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40675 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab2HXJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:34:39 -0400
Date: Fri, 24 Aug 2012 11:34:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v7 02/12] x86/Kconfig: Add config switch for CPU0 hotplug
Message-ID: <20120824093436.GC3019@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asit K Mallick <asit.k.mallick@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Arjan Dan De Ven <arjan@linux.intel.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Len Brown <len.brown@intel.com>,
	"Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Chen Gong <gong.chen@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
References: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
 <1345769771-27019-3-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345769771-27019-3-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:56:01PM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> New config switch CONFIG_BOOTPARAM_HOTPLUG_CPU0 sets default state of whether
> the CPU0 hotplug is on or off.
> 
> If the switch is off, CPU0 is not hotpluggable by default. But the CPU0 hotplug
> feature can still be turned on by kernel parameter cpu0_hotplug at boot.
> 
> If the switch is on, CPU0 is always hotpluggable. The default value of
> the switch is off.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/Kconfig |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1d91dac..31c8b89 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1711,6 +1711,35 @@ config HOTPLUG_CPU
>  	    automatically on SMP systems. )
>  	  Say N if you want to disable CPU hotplug.
>  
> +config BOOTPARAM_HOTPLUG_CPU0
> +	bool "Set default setting of cpu0_hotpluggable"

Why not change this boot option into something more understandable like

	bool "BSP hotpluggable by default"

or similar?

And, btw, maybe I didn't catch this earlier, but why is in all
user-visible options the thing called "cpu0_*"? Wouldn't it be better to
call it "bsp_*"?

Thanks.

-- 
Regards/Gruss,
    Boris.
