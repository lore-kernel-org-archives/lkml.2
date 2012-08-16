Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2HPHSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:18:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2HPHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:18:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V3 1/5] clk: mmp: add mmp specific clocks
Date: Thu, 16 Aug 2012 07:18:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1345086525-12328-1-git-send-email-xiechao.mail@gmail.com> <1345086525-12328-2-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1345086525-12328-2-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208160718.01769.arnd@arndb.de>
X-Provags-ID: V02:K0:3+l4JXWa9qETPJyZe7+H6vUAmwTvWRDs8251WHYPunl
 dtTWYKfQ1syMWLKlBhB+Ce3YHsd8IadzJ1Tnq8ZI8Y/ZLuSYy7
 47If2zTAI4WpOFynSpqqXX1DyXxcSBMGkFVmSm9CBKc7/OG/Nx
 PXat/FCWqV4g6+1J+HlKlApRFwwDJyePpHsZ3VE6E3h52xN14f
 IYN0A9oDbWq/aiott68BkQd8npNy+2NBCCMgEKkha2nL0kGecH
 kkKNWtOE1VzrDCl9WNhjxCv8ddi3xOgGYKe8J9XyRLbAbrEuiV
 B89BipAYLflJysA+BcTw2jIHlot5pNlaf4KoSSx5teKrOHD6da
 /zfnXQg3R8TIrJyEAdLk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Chao Xie wrote:
> +static int clk_apbc_prepare(struct clk_hw *hw)
> +{
> +       struct clk_apbc *apbc = to_clk_apbc(hw);
> +       unsigned int data;
> +       unsigned long flags = 0;
> +
> +       /*
> +        * It may share same register as MUX clock,
> +        * and it will impact FNCLK enable. Spinlock is needed
> +        */
> +       if (apbc->lock)
> +               spin_lock_irqsave(apbc->lock, flags);
> +
> +       data = __raw_readl(apbc->base);
> +       if (apbc->flags & APBC_POWER_CTRL)
> +               data |= APBC_POWER;
> +       data |= APBC_FNCLK;
> +       __raw_writel(data, apbc->base);

It seems you have missed a few __raw_readl/__raw_writel that still
want to get changed to readl_relaxed/writel_relaxed.

	Arnd
