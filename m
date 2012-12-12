Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2LLDAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 22:00:37 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51918 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2LLDAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 22:00:35 -0500
MIME-Version: 1.0
In-Reply-To: <201212102208.52347.arnd@arndb.de>
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org>
	<169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org>
	<201212102208.52347.arnd@arndb.de>
Date: Wed, 12 Dec 2012 08:30:35 +0530
Message-ID: <CAKohpo=FjZuMOC-wuNc3q_FXbk546ttCLr55GkW9AL0Tz-HoBA@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for replying late, was too busy with other work yesterday.

On 11 December 2012 03:38, Arnd Bergmann <arnd@arndb.de> wrote:
> I'm deeply sorry for the very late complaint on this, but I only now

Better late than never :)

> noticed this patch as I was seeing build breakage in linux-next
> because of it.

Oops!! Here is a fix for that

Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Dec 12 08:28:07 2012 +0530

    ARM: SPEAr1310: Fix CF DMA data

    We need to pass string with device-channel name to dma controller
instead of dma
    controller specific dma struct. Fix CF dma data.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-spear13xx/spear1310.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear13xx/spear1310.c
b/arch/arm/mach-spear13xx/spear1310.c
index f65ad5b..54f0e2e 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -36,7 +36,7 @@
 static struct arasan_cf_pdata cf_pdata = {
        .cf_if_clk = CF_IF_CLK_166M,
        .quirk = CF_BROKEN_UDMA,
-       .dma_priv = &cf_dma_priv,
+       .dma_priv = "cf",
 };

> Viresh, there are multiple problems with your approach unfortunately:
>
> * It does not follow the binding from
>   Documentation/devicetree/bindings/dma/dma.txt

When i patched it, this patch wasn't there in linux-next/master.
Probably was getting reviewed somewhere :)

> * It requires slave drivers to know that they are using the dw_dmac
>   driver and pass a pointer to dw_generic_filter, which is not
>   generic at all
>
> * It requires the dmac node to have information about all slaves
>
> There are also some minor issues, such as the naming of DT
> properties, but the above need to be resolved first.

I saw the binding document and it looks it can be applied to dw_dmac
too, as there is nothing special for it.

The question is how? We are already late for merge window and this
one is queued. Supplying a new patch, getting it reviewed/tested and
being pulled by Linus is not so easy :)

Two ways:
- Keep it as is, and i will fix it separately and quickly
- Drop it :(

--
viresh
