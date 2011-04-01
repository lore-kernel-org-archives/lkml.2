Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1DAUjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:39:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43043 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1DAUjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dqoVGkLUkNje6madXuVFP2NJblNT3LvcV3wv8jmX5I+F/BxQf3CHffoTm5vz4fJLcH
         a+Ni+HqCxke2Phak8HZw==
MIME-Version: 1.0
In-Reply-To: <20110330155911.6dc0ef63@absol.kitzblitz>
References: <20110330155911.6dc0ef63@absol.kitzblitz>
Date: Fri, 1 Apr 2011 13:39:27 -0700
X-Google-Sender-Auth: 8Gp6VbQ7Xia46Pq7fMIdmCAMkQQ
Message-ID: <BANLkTimxRd6X2JhchrVw45MpbdpQw8Zpeg@mail.gmail.com>
Subject: Re: [PATCH] arm: tegra: fix error check in tegra2_clocks.c
From: Colin Cross <ccross@android.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 6:59 AM, Nicolas Kaiser <nikai@nikai.net> wrote:
> Checking 'rate < 0' doesn't work because 'rate' is unsigned.
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> Untested.
>
>  arch/arm/mach-tegra/tegra2_clocks.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
> index 6d7c4ee..4459470 100644
> --- a/arch/arm/mach-tegra/tegra2_clocks.c
> +++ b/arch/arm/mach-tegra/tegra2_clocks.c
> @@ -1362,14 +1362,15 @@ static int tegra_clk_shared_bus_set_rate(struct clk *c, unsigned long rate)
>  {
>        unsigned long flags;
>        int ret;
> +       long new_rate = rate;
>
> -       rate = clk_round_rate(c->parent, rate);
> -       if (rate < 0)
> -               return rate;
> +       new_rate = clk_round_rate(c->parent, new_rate);
> +       if (new_rate < 0)
> +               return new_rate;
>
>        spin_lock_irqsave(&c->parent->spinlock, flags);
>
> -       c->u.shared_bus_user.rate = rate;
> +       c->u.shared_bus_user.rate = new_rate;
>        ret = tegra_clk_shared_bus_update(c->parent);
>
>        spin_unlock_irqrestore(&c->parent->spinlock, flags);
> --
> 1.7.3.4
>

Acked-by: Colin Cross <ccross@android.com>
