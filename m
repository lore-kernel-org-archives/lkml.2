Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0HRTEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:04:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0HRTEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:04:20 -0400
Message-ID: <4C6C2E85.9050401@zytor.com>
Date: Wed, 18 Aug 2010 12:03:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 2/2] x86, cpu hotplug: Fix cpu bringup concurrency
 issue
References: <4C59F24B.1010702@zytor.com> <20100805074503.GI18307@amd.com> <4C5AC736.20903@zytor.com> <20100812144142.GY23755@8bytes.org> <4C64148D.5080305@zytor.com> <20100812170644.GZ23755@8bytes.org> <4C644507.9020606@zytor.com> <20100812190414.GA23755@8bytes.org> <20100813123543.GC9046@aftab> <20100816121933.GA28147@aftab> <20100816123959.GC28147@aftab>
In-Reply-To: <20100816123959.GC28147@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 05:39 AM, Borislav Petkov wrote:
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index dcb0593..1598663 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -58,6 +58,7 @@ config X86
>  	select ANON_INODES
>  	select HAVE_ARCH_KMEMCHECK
>  	select HAVE_USER_RETURN_NOTIFIER
> +	select ARCH_CPU_PROBE_RELEASE
>  

warning: (X86) selects ARCH_CPU_PROBE_RELEASE which has unmet direct
dependencies (HOTPLUG_CPU)

... and build failure when compiling without CONFIG_HOTPLUG_CPU.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

