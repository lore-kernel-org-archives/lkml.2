Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1BUEPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:15:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63778 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1BUEPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:15:38 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-1-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:15:25 -0800
Message-ID: <AANLkTinWQRmKhorYHQ2rHCArHN89go-2mYVAe5UUZVOV@mail.gmail.com>
Subject: Re: [PATCH v2 12/21] ARM: tegra: clock: Add shared bus clock type
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, sboyd@codeaurora.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
> Some clocks may have multiple downstream users that need to request a
> higher clock rate.  Shared bus clocks provide a unique shared_bus_user
> clock to each user.  The frequency of the bus is set to the highest
> enabled shared_bus_user clock, with a minimum value set by the
> shared bus.  Drivers can use clk_enable and clk_disable to enable
> or disable their requirement, and clk_set_rate to set the minimum rate.
>
> Signed-off-by: Colin Cross <ccross@android.com>

[...]
> diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
> index a1c86d8..dd53af3 100644
> --- a/arch/arm/mach-tegra/tegra2_clocks.c
> +++ b/arch/arm/mach-tegra/tegra2_clocks.c
[...]

> +       c->u.shared_bus_user.rate = c->parent->max_rate;
> +       c->state = OFF;
> +#ifdef CONFIG_DEBUG_FS
> +       c->set = 1;
> +#endif
> +
> +       spin_lock_irqsave(&c->parent->spinlock, flags);


A later patch in the series removes the ifdef. Might as well remove it
here. Also, should be c->set = true, which that patch also does. :)

With that fixed:

Acked-by: Olof Johansson <olof@lixom.net>
