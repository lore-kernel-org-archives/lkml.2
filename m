Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1DUUag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:30:36 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:59392 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1DUUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:30:35 -0400
Message-ID: <4DB093E6.3040909@ece.ntua.gr>
Date: Thu, 21 Apr 2011 23:30:30 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: annoying new gcc 4.6.0 warnings.
References: <20110421192117.GA14249@redhat.com>
In-Reply-To: <20110421192117.GA14249@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Thu, 21 Apr 2011 23:30:33 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/2011 10:21 μμ, Dave Jones wrote:
> gcc 4.6.0 enables a new warning by default, which spews ~3000 lines
> of extra warnings to my build. The warning looks like ..
>
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function ‘pending_bit_stuck’:
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c:108:10: warning: variable ‘hi’ set but not used [-Wunused-but-set-variable]
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function ‘core_voltage_pre_transition’:
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c:340:14: warning: variable ‘lo’ set but not used [-Wunused-but-set-variable]
>
> In those cases, there's no bug there, the code just doesn't use all the arguments
> that get passed to rdmsr...   For eg,
>
> static int pending_bit_stuck(void)
> {
>         u32 lo, hi;
>
>         if (cpu_family == CPU_HW_PSTATE)
>                 return 0;
>
>         rdmsr(MSR_FIDVID_STATUS, lo, hi); 
>         return lo & MSR_S_LO_CHANGE_PENDING ? 1 : 0; 
> }
>
>
> gcc's manpage says to dismiss this warning with attribute(unused), but sprinkling thousands
> of those through the source seems pretty ugly.  As does rewriting functions
> like rdmsr to handle NULL as an argument.
>
> There might be some valid bugs found (I think DaveM found a few already) from this new
> warning, but it seems like everything I've looked at so far is just noise.
>
> Any thoughts ?
>
> 	Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
This new gcc-4.6.0 behavior can also cause build failures for archs
which use -Werror by default (sparc, ppc) [1][2].

[1] https://lkml.org/lkml/2011/4/19/383
[2] https://lkml.org/lkml/2011/4/18/287

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

