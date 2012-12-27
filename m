Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2L0SWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:22:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55013 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab2L0SWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:22:33 -0500
Date: Thu, 27 Dec 2012 19:22:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, realmode: set real_mode permissions early
Message-ID: <20121227182232.GA10054@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit 77e277cb85290a183bbc1995a1cd839b1c216f25
> Subject: [PATCH] x86, realmode: set real_mode permissions early
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Mon Dec 24 18:00:21 2012 -0800
> 
>     x86, realmode: set real_mode permissions early
>     
>     We need to set trampoline code to EXEC early before we do smp
>     AP bootings.
>     
>     Found the problem after switching to #PF handler set page table,
>     and we do not set initial kernel low mapping with EXEC anymore.
>     
>     Change to use early_initcall instead that will make sure tramopline
>     will have EXEC set.
>     
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 80450261215c..0b7e840ad4d4 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -111,5 +111,4 @@ static int __init set_real_mode_permissions(void)
>  
>  	return 0;
>  }
> -
> -arch_initcall(set_real_mode_permissions);
> +early_initcall(set_real_mode_permissions);

I'm looking at this patch in the -v8 branch: you need to update the
comment above that function to say that trampoline code needs to be
marked X now earlier.

Thanks.

-- 
Regards/Gruss,
Boris.
