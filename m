Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2IORmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 13:42:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2IORmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 13:42:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 05/24] ARM: imx: use __iomem pointers for MMIO
Date: Sat, 15 Sep 2012 17:42:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-6-git-send-email-arnd@arndb.de> <CAOMZO5DemdKtxORhRwyGyF46rdden5QRZh9D9f4KRki5+BfM2A@mail.gmail.com>
In-Reply-To: <CAOMZO5DemdKtxORhRwyGyF46rdden5QRZh9D9f4KRki5+BfM2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209151742.41828.arnd@arndb.de>
X-Provags-ID: V02:K0:y3fLlLkG12SA3HL8xEZHuyxBZopNqhMZdSdOIRjksDU
 jHA62+O4oce2bgl9K3SYHc5SkMQiqS4EO4gDkHlrczelPYJ6Z1
 hAEdX/qCaZ7romds7S1hZs7jOrv2zZxLUy96AMuKYoS7y2b8+n
 3zQio71M9PD5HPpXTnJEKcbPIfnuuFlT+xJuvW7zUI+B7uH5a0
 LrRBmANDiW3JMhYNknM7nzQGh+Qeh+FQx92SuxDQ2YbioZ0RRR
 SnZJIA0SJ1sYG+04hVqYdhaM2WqANfYVi94vGZVH3iakOCEoV8
 oR4ZkV48BCAPFfV/hbKXQWvFPbrNktmuV05HsmKGeQA5JcsVGx
 am7rzz9NPeRVTSld2koM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2012, Fabio Estevam wrote:
> On Fri, Sep 14, 2012 at 6:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > ARM is moving to stricter checks on readl/write functions,
> > so we need to use the correct types everywhere.
> >
> > This found a bug in mach-armadillo5x0.c, where we attempt mmio
> > on the MXC_CCM_RCSR address that is currently defined to 0xc
> > and consequently causes an illegal address access.
> ...
> 
> >         /* set NAND page size to 2k if not configured via boot mode pins */
> > -       __raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
> > +       /* FIXME __raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR); */
> 
> Good catch, the correct access would be:
> __raw_readl(mx3_ccm_base + MXC_CCM_RCSR) ...
> 
> I will fix this after your series reaches linux-next.
> 

I think I'd prefer it if you can fix it on the current kernel. This seems to
be a serious bug that we actually want to fix in 3.6 or maybe backport to
the stable series (I don't know when it was introduced). I'll just drop
this hunk from my patch then.

	Arnd
