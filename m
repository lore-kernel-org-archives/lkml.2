Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2HQLem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:34:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2HQLej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:34:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V4 2/5] clk: mmp: add clock definition for pxa168
Date: Fri, 17 Aug 2012 11:34:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com
References: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com> <1345183330-20244-3-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1345183330-20244-3-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171134.32195.arnd@arndb.de>
X-Provags-ID: V02:K0:97FURgZBcEHUYb2hH5UWYlLdC5YvlxdPUp1zDqT4UPN
 RkcfAzO7gxJaJ1L6yPZRIKOnpZQp6jdB7VUBLgQrVU5ZL4rxkm
 6ix5Lc0XQbXdcq93HgBhANctMQGP3YqvWkqbJ41urYlSfKhohw
 DNqB0sARxQ8Xp/ZN5aoZp2ZtuAgEZHtG4t9W7kjPo575npANf4
 dbJw+1DkFPsSFd7AsipDhCcMfgIyKXhyiDUTrCfPcKLseoRIjc
 PDgxQp1zBzlpmVMcwh0BqHav93/mDey1qweGvR2S1esC2jmHvq
 q+pZBgd9VzFiV0aCwoSHXsHBC1RdqqbVGna8+QliTDxpVpbf/H
 /EdYzKANOeHCQ45cQ18Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2012, Chao Xie wrote:
> +void __init pxa168_clk_init(void)
> +{
> +       struct clk *clk;
> +       struct clk *uart_pll;
> +       void __iomem *mpmu_base;
> +       void __iomem *apmu_base;
> +       void __iomem *apbc_base;
> +
> +       mpmu_base = ioremap(APB_PHYS_BASE + 0x50000, SZ_4K);
> +       if (mpmu_base == NULL) {
> +               pr_err("error to ioremap MPMU base\n");
> +               return;
> +       }
> +
> +       apmu_base = ioremap(AXI_PHYS_BASE + 0x82800, SZ_4K);
> +       if (apmu_base == NULL) {
> +               pr_err("error to ioremap APMU base\n");
> +               return;
> +       }
> +
> +       apbc_base = ioremap(APB_PHYS_BASE + 0x15000, SZ_4K);
> +       if (apbc_base == NULL) {
> +               pr_err("error to ioremap APBC base\n");
> +               return;
> +       }

I hadn't noticed this before, but you are hardcoded physical address locations
in the driver, which is not so good since we're trying to move all those
locations to device tree. Maybe someone else has an idea to do this better.

> +       clk = clk_register_fixed_rate(NULL, "clk32", NULL, CLK_IS_ROOT, 3200);
> +       clk_register_clkdev(clk, "clk32", NULL);
> +
> +       clk =
> +           clk_register_fixed_rate(NULL, "vctcxo", NULL, CLK_IS_ROOT,
> +                                   26000000);
> +       clk_register_clkdev(clk, "vctcxo", NULL);
> +
> +       clk =
> +           clk_register_fixed_rate(NULL, "pll1", NULL, CLK_IS_ROOT, 624000000);
> +       clk_register_clkdev(clk, "pll1", NULL);

Ok, so you've managed to remove the array, good!

I'm still not overly happy with the style of newline after "=", that is
very unusual, and only saves you two characters per line. I'd say just move
them each into one line as you did in the first one here. It's less important
to align the arguments to the opening braces if you are trying to stay in the
80 character limit. Another option would be to rename the variable to just
'c' instead of 'clk' ;-)

	Arnd


	Arnd
