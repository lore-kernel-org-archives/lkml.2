Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab2HVJmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:42:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab2HVJl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:41:58 -0400
Date: Wed, 22 Aug 2012 11:41:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@us.ibm.com>
Subject: Re: [PATCH v2] x86: don't ever patch back to UP if we unplug cpus.
Message-ID: <20120822094153.GA25894@gmail.com>
References: <87y5m5mz6o.fsf@rustcorp.com.au>
 <1343420909.3696.560.camel@sbsiddha-desk.sc.intel.com>
 <87d33em4mf.fsf@rustcorp.com.au>
 <874noqm21b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874noqm21b.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> We still patch SMP instructions to UP variants if we boot with a
> single CPU, but not at any other time.  In particular, not if we
> unplug CPUs to return to a single cpu.
> 
> Paul McKenney points out:
> 
>  mean offline overhead is 6251/48=130.2 milliseconds.
> 
>  If I remove the alternatives_smp_switch() from the offline
>  path [...] the mean offline overhead is 550/42=13.1 milliseconds
> 
> Basically, we're never going to get those 120ms back, and the code is
> pretty messy.
> 
> We get rid of:
> 1) The "smp-alt-once" boot option.  It's actually "smp-alt-boot", the
>    documentation is wrong.  It's now the default.
> 2) The skip_smp_alternatives flag used by suspend.
> 3) arch_disable_nonboot_cpus_begin() and arch_disable_nonboot_cpus_end()
>    which were only used to set this one flag.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  Documentation/kernel-parameters.txt |    3 -
>  arch/x86/include/asm/alternative.h  |    4 -
>  arch/x86/kernel/alternative.c       |  104 +++++++-----------------------------
>  arch/x86/kernel/smpboot.c           |   20 ------
>  kernel/cpu.c                        |   11 ---
>  5 files changed, 27 insertions(+), 115 deletions(-)

and this version breaks the build on allyesconfig-x86-64:

arch/x86/xen/smp.c:380:3: error: implicit declaration of function ‘alternatives_smp_switch’ [-Werror=implicit-function-declaration]

Thanks,

	Ingo
