Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab2LLXfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:35:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2LLXfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:35:11 -0500
Message-ID: <50C9148C.4040308@zytor.com>
Date: Wed, 12 Dec 2012 15:34:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1355343572-23074-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 12:19 PM, stefani@seibold.net wrote:
> diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
> new file mode 100644
> index 0000000..c9a1909
> --- /dev/null
> +++ b/arch/x86/vdso/vdso32/vclock_gettime.c
> @@ -0,0 +1,7 @@
> +/*
> + * since vgtod layout differs between X86_64 and x86_32, it is not possible to
> + * provide a 32 bit vclock with a 64 bit kernel
> + */
> +#ifdef CONFIG_X86_32
> +#include "../vclock_gettime.c"
> +#endif

This is where this goes fail.  Sorry, it is not acceptable to introduce 
an ABI on x86-32 without providing it also on x86-64 in compatibility mode.

I also don't believe it is not possible... it might require some more 
cleverness; perhaps we need to do the 32-bit vgtod in such a way that it 
*is* compatible with 64 bits.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

