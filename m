Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1BUETz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:19:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44996 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1BUETy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:19:54 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-17-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-17-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:19:53 -0800
Message-ID: <AANLkTi=jJRhyMZXbs3Unr-U+J59rt4SxMQtT4KtCqWbe@mail.gmail.com>
Subject: Re: [PATCH v2 15/21] ARM: tegra: clock: Round rate before setting rate
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:

> diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
> index 8d01a49..9798585 100644
> --- a/arch/arm/mach-tegra/clock.c
> +++ b/arch/arm/mach-tegra/clock.c
> @@ -86,6 +86,7 @@ static unsigned long clk_predict_rate_from_parent(struct clk *c, struct clk *p)
>
>        if (c->mul != 0 && c->div != 0) {
>                rate *= c->mul;
> +               rate += c->div / 2; /* round up */

Shouldn't this be "rate += c->div - 1;"?



-Olof
