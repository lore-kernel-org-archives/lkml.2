Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0LOPkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:40:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0LOPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:40:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] ARM i.MX51: Add ipu clock support
Date: Wed, 15 Dec 2010 16:40:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Zhang Lily-R58066" <r58066@freescale.com>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1291902441-24712-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151640.03789.arnd@arndb.de>
X-Provags-ID: V02:K0:ZT82ED4QjmVbJwudFTGNpJ1SLuu8Nuh0bPlF3zanJ6B
 ZKMNHEt0H4jSTGrni/Wx7bDShGiBrhAT15VarPLc37a5OYwZkU
 Z1Sqh4wHYxjOyTtyhYa6KY9ENIywLOOV7NARKvkrFRpmrLOchj
 lqmNYTKLxzd5/XF/vzm3S79p+STqHpihD2SN5sJ7wEAuUV0s/w
 PyskYKXRZ21v8Q9GAnZ5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 December 2010, Sascha Hauer wrote:
> +static int clk_ipu_enable(struct clk *clk)
> +{
> +       u32 reg;
> +
> +       _clk_ccgr_enable(clk);
> +
> +       /* Enable handshake with IPU when certain clock rates are changed */
> +       reg = __raw_readl(MXC_CCM_CCDR);
> +       reg &= ~MXC_CCM_CCDR_IPU_HS_MASK;
> +       __raw_writel(reg, MXC_CCM_CCDR);
> +
> +       /* Enable handshake with IPU when LPM is entered */
> +       reg = __raw_readl(MXC_CCM_CLPCR);
> +       reg &= ~MXC_CCM_CLPCR_BYPASS_IPU_LPM_HS;
> +       __raw_writel(reg, MXC_CCM_CLPCR);
> +
> +       return 0;
> +}

Why __raw_readl?

The regular accessor function for I/O registers is readl, which handles
the access correctly with regard to atomicity, I/O ordering and byteorder.

	Arnd
