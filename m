Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab1KJNe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:34:57 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55242 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab1KJNe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:34:56 -0500
Message-ID: <4EBBD2F7.5090905@linux.vnet.ibm.com>
Date: Thu, 10 Nov 2011 19:04:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Daniel Drake <dsd@laptop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com> <20111108203116.GF25083@aftab> <4EB9A6BC.7050600@zytor.com> <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com> <CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com> <20111108223744.GA1996@x1.osrc.amd.com> <CAMLZHHRc+yNr=6SB7Z1t_hyL+e8a0T-BokyQ+wVUPw-vhd3rQA@mail.gmail.com> <20111109173412.GE14181@aftab>
In-Reply-To: <20111109173412.GE14181@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Apparently my mailer couldn't mail to bp@alien8.de and failed.
So resending with that address removed.

On 11/09/2011 11:04 PM, Borislav Petkov wrote:
> On Tue, Nov 08, 2011 at 04:59:05PM -0600, Daniel Drake wrote:
>> On Tue, Nov 8, 2011 at 4:37 PM, Borislav Petkov <bp@alien8.de> wrote:
>>> Yep, just send me /proc/cpuinfo from a working kernel.
> 
> Daniel, would you please test? It should work though :-)
> 
> Thanks.
> 
> --
> From daa04c94628d5686404bd6985d4545f12c2fa4fd Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Wed, 9 Nov 2011 18:08:40 +0100
> Subject: [PATCH] x86, microcode, AMD: Restrict microcode reporting
> 
> bcb80e53877c ("x86, microcode, AMD: Add microcode revision to
> /proc/cpuinfo") added support for dumping microcode patch level in
> /proc/cpuinfo on AMD. Although we were very cautious and did rdmsr_safe
> on the microcode patch level MSR, this broke booting on Geode LX because
> this CPU doesn't have that MSR and at the time we do the read, exception
> tables which are used by rdmsr_safe are not yet initialized, leading to
> a boot hang.
> 
> This is the simple fix which enables the microcode line in /proc/cpuinfo
> for K8 and newer (it is not that interesting for older boxes anyway
> :-)).
> 
> Reported-and-bisected-by: Daniel Drake <dsd@laptop.org>
> Link: http://lkml.kernel.org/r/CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com
                     ^^^^^^^
I couldn't open this web-page!

Thanks,
Srivatsa S. Bhat

> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index c7e46cb..a72d183 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -474,7 +474,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
>  	}
>  #endif
> 
> -	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
> +	if (c->x86 >= 0xf)
> +		rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
>  }
> 
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
