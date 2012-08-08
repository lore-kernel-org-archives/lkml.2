Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2HHWeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:34:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33304 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab2HHWeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:34:14 -0400
Message-ID: <5022E963.9020809@zytor.com>
Date: Wed, 08 Aug 2012 15:34:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:x86:fpu 2/2] arch/x86/kernel/signal.c:626:4: error: implicit
 declaration of function '__setup_frame'
References: <20120725232716.GB5758@localhost> <1343324885.3696.527.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1343324885.3696.527.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 10:48 AM, Suresh Siddha wrote:
>
> Appended the patch for this. Thanks!
> ---
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, fpu: fix x86_64 build without CONFIG_IA32_EMULATION
>
> Fengguang's automated build reported some compilation failures:
>> arch/x86/kernel/signal.c: In function 'setup_rt_frame':
>> arch/x86/kernel/signal.c:626:4: error: implicit declaration of function '__setup_frame'
>> arch/x86/kernel/xsave.c: In function 'save_fsave_header':
>> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
>> ...
>
> Fix x86_64 kernel build without CONFIG_IA32_EMULATION.
>
> Code saving fsave prefix is applicable only for CONFIG_X86_32 or
> CONFIG_IA32_EMULATION. Use config_enabled() checks to remove the unnecessary
> code compile-time for x86_64 kernels build without CONFIG_IA32_EMULATION.
>
> Also while we are at this, fix a spurious warning:
>> arch/x86/kernel/xsave.c:209:15: warning: ignoring return value of ‘__clear_user’, declared with attribute warn_unused_result
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

With this patch applied I get an error at:

/home/hpa/kernel/tip.x86-fpu/arch/x86/kernel/signal.c:792:12: error: 
static declaration of ‘x32_setup_rt_frame’ follows non-static declaration
In file included from 
/home/hpa/kernel/tip.x86-fpu/arch/x86/kernel/signal.c:29:0:
/home/hpa/kernel/tip.x86-fpu/arch/x86/include/asm/fpu-internal.h:62:5: 
note: previous declaration of ‘x32_setup_rt_frame’ was here
/home/hpa/kernel/tip.x86-fpu/arch/x86/kernel/signal.c:792:12: warning: 
‘x32_setup_rt_frame’ defined but not used [-Wunused-function]
make[4]: *** [arch/x86/kernel/signal.o] Error 1
make[3]: *** [arch/x86/kernel] Error 2
make[2]: *** [arch/x86] Error 2
make[1]: *** [sub-make] Error 2
make[1]: Leaving directory `/home/hpa/kernel/tip.x86-fpu'

... for an x86-64 allyesconfig.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

