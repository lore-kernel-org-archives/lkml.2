Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2JKJAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:00:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54631 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2JKI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:59:56 -0400
Date: Thu, 11 Oct 2012 09:59:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 6/6] mfd: Differentiate between u8500 and u9540 TCDM
 address mapping
Message-ID: <20121011085951.GU9707@gmail.com>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-7-git-send-email-lee.jones@linaro.org>
 <201210101834.40749.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201210101834.40749.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Arnd Bergmann wrote:

> On Wednesday 10 October 2012, Lee Jones wrote:
> > @@ -2688,7 +2688,11 @@ void __init db8500_prcmu_early_init(void)
> >                         iounmap(tcpm_base);
> >                 }
> >  
> > -               tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
> > +               if (cpu_is_u9540())
> > +                       tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE,
> > +                                               SZ_4K + SZ_8K) + SZ_8K;
> > +               else
> > +                       tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
> >         } else {
> >                 pr_err("prcmu: Unsupported chip version\n");
> >                 BUG();
> 
> Would it be possible to get the base out of the device tree and always
> map it from there? Adding another dependency on a fixed constant is
> just going to make the conversion to multiplatform harder, since it
> was decided that device drivers should not have access to platform
> header files in the multiplatform case.

>From what I understand, this code has to be called before Device
Tree kicks in. Actually, this code is mearly a stand-in until Loic
has finished with the PRCMU re-vamp. Once that's complete, this
stuff will be passed from init_IRQ(), which is invoked directly in
start_kernel().

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
