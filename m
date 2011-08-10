Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1HJROd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:14:33 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:50193 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754224Ab1HJROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:14:31 -0400
Date: Wed, 10 Aug 2011 10:14:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] EDAC: Correct Kconfig dependencies
Message-Id: <20110810101429.5a8f36e9.rdunlap@xenotime.net>
In-Reply-To: <1312980210-3692-1-git-send-email-bp@amd64.org>
References: <4E41055F.9010900@redhat.com>
	<1312980210-3692-1-git-send-email-bp@amd64.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 14:43:30 +0200 Borislav Petkov wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Both AMD and Intel i7 EDAC drivers use MCE features and are thus
> dependent of this functionality present in the kernel. Express this in
> Kconfig so that randconfig builds don't break.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/edac/Kconfig |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index f888fb5..d057d6c 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -41,7 +41,7 @@ config EDAC_DEBUG
>  
>  config EDAC_DECODE_MCE
>  	tristate "Decode MCEs in human-readable form (only on AMD for now)"
> -	depends on CPU_SUP_AMD && X86_MCE
> +	depends on CPU_SUP_AMD && X86_MCE_AMD
>  	default y
>  	---help---
>  	  Enable this option if you want to decode Machine Check Exceptions
> @@ -170,8 +170,7 @@ config EDAC_I5400
>  
>  config EDAC_I7CORE
>  	tristate "Intel i7 Core (Nehalem) processors"
> -	depends on EDAC_MM_EDAC && PCI && X86
> -	select EDAC_MCE
> +	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
>  	help
>  	  Support for error detection and correction the Intel
>  	  i7 Core (Nehalem) Integrated Memory Controller that exists on
> -- 
> 1.7.4.rc2
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
