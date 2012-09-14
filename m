Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2INWbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:31:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62555 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2INWbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <1347658492-11608-6-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-6-git-send-email-arnd@arndb.de>
Date: Fri, 14 Sep 2012 19:31:46 -0300
Message-ID: <CAOMZO5DemdKtxORhRwyGyF46rdden5QRZh9D9f4KRki5+BfM2A@mail.gmail.com>
Subject: Re: [PATCH 05/24] ARM: imx: use __iomem pointers for MMIO
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 6:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
>
> This found a bug in mach-armadillo5x0.c, where we attempt mmio
> on the MXC_CCM_RCSR address that is currently defined to 0xc
> and consequently causes an illegal address access.
...

>         /* set NAND page size to 2k if not configured via boot mode pins */
> -       __raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
> +       /* FIXME __raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR); */

Good catch, the correct access would be:
__raw_readl(mx3_ccm_base + MXC_CCM_RCSR) ...

I will fix this after your series reaches linux-next.

Regards,

Fabio Estevam
