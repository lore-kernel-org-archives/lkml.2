Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2F1Pr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:47:59 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43384 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2F1Pr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-2-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-2-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 17:47:57 +0200
Message-ID: <CACRpkdYaOLi7Xrt0MsB1onXCUbb91ZaqngFmFGf3eitrL4Qakg@mail.gmail.com>
Subject: Re: [PATCH 01/15] ARM: etm: Don't require clock control
From: Linus Walleij <linus.walleij@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:47 AM, John Stultz <john.stultz@linaro.org> wrote:

> -       clk_enable(t->emu_clk);
> +       else
> +               clk_enable(t->emu_clk);

Take this opportunity to use clk_prepare_enable();

>        etb_unlock(t);
>        t->etb_bufsz = etb_readl(t, ETBR_DEPTH);
> @@ -403,8 +402,10 @@ static int etb_remove(struct amba_device *dev)
>        iounmap(t->etb_regs);
>        t->etb_regs = NULL;
>
> -       clk_disable(t->emu_clk);
> -       clk_put(t->emu_clk);
> +       if (!IS_ERR(t->emu_clk)) {
> +               clk_disable(t->emu_clk);

And clk_disable_uprepare() here.

> +               clk_put(t->emu_clk);
> +       }

After that it's
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
