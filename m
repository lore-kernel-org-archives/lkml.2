Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1DKPZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:25:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1DKPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:25:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: about __BITS_PER_LONG
Date: Mon, 11 Apr 2011 17:24:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <003f01cbf81a$f48cfdf0$dda6f9d0$@mprc.pku.edu.cn>
In-Reply-To: <003f01cbf81a$f48cfdf0$dda6f9d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104111724.57607.arnd@arndb.de>
X-Provags-ID: V02:K0:NFu7uL5uKcNJCyCdVDwHIkI1jjc37bGKbeiitTaEMOo
 tMG5b6dYoj8MPf2m45rSZyMJa8lveDVGSRnPoFXhbhy7Fykg3E
 s+TJZm4iaaA6ysCKWRfLTd6IspSuiG5fcb5tOTLvppxvvgoqbw
 bxNSbl1mbltjIwdomdrPvMewhNSxiN0X9XGmqEcbUFIEnEpGHF
 XOuNTnj6FEGDNIABWBVMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 April 2011, Guan Xuetao wrote:
> --- a/include/asm-generic/bitsperlong.h
> +++ b/include/asm-generic/bitsperlong.h
> @@ -9,7 +9,11 @@
>   * to decide it, but rather check a compiler provided macro.
>   */
>  #ifndef __BITS_PER_LONG
> -#define __BITS_PER_LONG 32
> +#   ifdef CONFIG_64BIT
> +#      define __BITS_PER_LONG 64
> +#   else
> +#      define __BITS_PER_LONG 32
> +#   endif /* CONFIG_64BIT */
>  #endif
>  

Unfortunately, this does not work, because the __BITS_PER_LONG definition is meant
for user space. You have to make this depend on a preprocessor macro that
is provided by the compiler based on the command line switches (e.g. -m64) that
a use could pass to the compiler.

In user space, the CONFIG_* symbols are meaningless.

	Arnd
