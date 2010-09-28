Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab0I1A1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:27:35 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43408 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0I1A1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:27:34 -0400
Date: Mon, 27 Sep 2010 17:26:34 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928002634.GA5030@ericsson.com>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
 <20100927125946.GB2862@elte.hu>
 <AANLkTinPHP8WhoAZQqcmhotEfFa6=mG_Acy+xCBQ0_5+@mail.gmail.com>
 <20100927232716.GB4744@ericsson.com>
 <AANLkTinDkJu2MSJM6bUpWJoB2XOD4LLf6GTPBX39wteD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTinDkJu2MSJM6bUpWJoB2XOD4LLf6GTPBX39wteD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 07:44:01PM -0400, Linus Torvalds wrote:
[...]

>  include/linux/smp.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index cfa2d20..ad48077 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -149,6 +149,8 @@ smp_call_function_any(const struct cpumask *mask, void (*func)(void *info),
>  	return smp_call_function_single(0, func, info, wait);
>  }
>  
> +static inline const struct cpumask *cpu_sibling_mask(int cpu) { return NULL; }
> +
>  #endif /* !SMP */
>  
Not that simple. cpu_sibling_mask()  is defined in asm/smp.h, which is only
included from linux/smp.h if SMP is defined. But many other files do include
asm/smp.h directly. This causes the following error all over the place
if CONFIG_SMP is not defined.

In file included from /opt/scratch/groeck/linux-staging/arch/x86/include/asm/apic.h:473,
                 from arch/x86/xen/enlighten.c:46:
/opt/scratch/groeck/linux-staging/arch/x86/include/asm/smp.h:29: error: conflicting types for cpu_sibling_mask
include/linux/smp.h:152: note: previous definition of cpu_sibling_mask was here

Guenter

