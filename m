Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2JJSeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:34:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2JJSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:34:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 6/6] mfd: Differentiate between u8500 and u9540 TCDM address mapping
Date: Wed, 10 Oct 2012 18:34:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org> <1349882335-6786-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1349882335-6786-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210101834.40749.arnd@arndb.de>
X-Provags-ID: V02:K0:y5diUZfiC5VdlUS5hdlhex9Vb1qtpEpyv8hK/sh3Bci
 51mZYRj7yHi8+BwElUiUSsjx9D+ozgasMF5OA/GXvMMlAhTjgx
 Prrek22JNIohZYHP1ac9wnlblK65cdYW0dCa6l3ULLTY4NGYnJ
 STFWYSD9xboDX2AIIBrNNKZfEtf9lkP2OH4HXNYqzZ7jUnrAHi
 6uqyXjbSCrJx3p7izKl1wpWIiuPujpsmD0n+aVeOmo0W5ywE8C
 Xg5ktR9SnMhEGHScj4InIEH9gPc0gt1gI9piVYGY7UgzmIjtBf
 lxrYtXpuYp7vDt3+eIRWK6Gd2buOBGjRBDRL8u1PJkioQ/SI6g
 9XDQWEPkpviXppkcXEFo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2012, Lee Jones wrote:
> @@ -2688,7 +2688,11 @@ void __init db8500_prcmu_early_init(void)
>                         iounmap(tcpm_base);
>                 }
>  
> -               tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
> +               if (cpu_is_u9540())
> +                       tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE,
> +                                               SZ_4K + SZ_8K) + SZ_8K;
> +               else
> +                       tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
>         } else {
>                 pr_err("prcmu: Unsupported chip version\n");
>                 BUG();

Would it be possible to get the base out of the device tree and always
map it from there? Adding another dependency on a fixed constant is
just going to make the conversion to multiplatform harder, since it
was decided that device drivers should not have access to platform
header files in the multiplatform case.

	Arnd
