Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1LMKxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:53:11 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48269 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751372Ab1LMKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:53:06 -0500
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.100.10070, virus records: 2434158, updated: 13.12.2011]
Message-ID: <4EE72E57.6080400@ru.mvista.com>
Date: Tue, 13 Dec 2011 14:52:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Liu <jason.hui@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 09/19] clock-imx35: fix reboot in internal boot mode
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-9-git-send-email-eric@eukrea.com>
In-Reply-To: <1323757911-25217-9-git-send-email-eric@eukrea.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-12-2011 10:31, Eric Bénard wrote:

> commit 8d75a2620dc3e33ce504044c375c443ed7ed4128

    Please also specify that commit's summary in parens.

 > disable IIM

    Disables?

> clock after reading silicon revision which will prevent
> reboot in internal boot mode (see comment a few line before)

> Signed-off-by: Eric Bénard<eric@eukrea.com>
> Cc: Jason Liu<jason.hui@linaro.org>
> Cc: Sascha Hauer<kernel@pengutronix.de>
> ---
>   arch/arm/mach-imx/clock-imx35.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)

> diff --git a/arch/arm/mach-imx/clock-imx35.c b/arch/arm/mach-imx/clock-imx35.c
> index 8116f11..b49a732 100644
> --- a/arch/arm/mach-imx/clock-imx35.c
> +++ b/arch/arm/mach-imx/clock-imx35.c
> @@ -538,7 +538,10 @@ int __init mx35_clocks_init()
>
>   	clk_enable(&iim_clk);
>   	imx_print_silicon_rev("i.MX35", mx35_revision());
> -	clk_disable(&iim_clk);
> +	/* Don't disable IIM clock if we came up in internal boot mode */
> +	if (__raw_readl(CCM_BASE + CCM_RCSR) & (3 << 10)) {
> +		clk_disable(&iim_clk);
> +	}

    {} not needed -- scripts/checkpatch.pl should have warned you.

WBR, Sergei
