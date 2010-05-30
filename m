Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0E3P2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:28:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:33914 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752600Ab0E3P23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:28:29 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/+yk0T9mL+PmBPjvv8eTAeqkSU9I4ghGrr01GUQd
	qwUL7RVevBYE27
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Borislav Petkov <bp@alien8.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: current git kernel crashes UML system during boot
Date: Sun, 30 May 2010 17:28:25 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; i686; ; )
References: <201005271944.09541.toralf.foerster@gmx.de> <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com> <20100530150214.GA1565@liondog.tnic>
In-Reply-To: <20100530150214.GA1565@liondog.tnic>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201005301728.25976.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Borislav Petkov wrote at 17:02:14
> Can you guys check whether the following fixes the issue?
> 
> Thanks.
> 
> --
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 545776e..c9dad12 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -444,7 +444,11 @@ static inline int fls(int x)
>  
>  #define ARCH_HAS_FAST_MULTIPLIER 1
>  
> +#ifdef CONFIG_UML
> +#include <asm-generic/bitops/arch_hweight.h>
> +#else
>  #include <asm/arch_hweight.h>
> +#endif
>  
>  #include <asm-generic/bitops/const_hweight.h>
>  
> 
> 
solved reported issue.
Thx

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

