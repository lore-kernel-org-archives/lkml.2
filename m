Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2D0DCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:02:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60698 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab2D0DCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <1334384779-532-1-git-send-email-mad_soft@inbox.ru>
References: <1334384779-532-1-git-send-email-mad_soft@inbox.ru>
Date: Fri, 27 Apr 2012 11:02:05 +0800
Message-ID: <CAN1soZwQ9BBp+=mZZm6tL+r2j5-wX-mFkeBPCOuqCGkibZ0R1g@mail.gmail.com>
Subject: Re: [PATCH] arm/sa1100: fix sa1100-rtc memory resource
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 2:26 PM, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> DEFINE_RES_MEM() takes the size of resource as a second argument,
> not the end address. Passing end address leads to following error
> in runtime during device registration:
> sa1100-rtc: failed to claim resource 0
>
> Fix it.
>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
>  arch/arm/mach-sa1100/generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> For reference: bug was introduced by commit 3888c09074
> ("rtc: sa1100: declare irq in resource")
>
> diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
> index 7c524b4..16be4c5 100644
> --- a/arch/arm/mach-sa1100/generic.c
> +++ b/arch/arm/mach-sa1100/generic.c
> @@ -306,7 +306,7 @@ void sa11x0_register_irda(struct irda_platform_data *irda)
>  }
>
>  static struct resource sa1100_rtc_resources[] = {
> -       DEFINE_RES_MEM(0x90010000, 0x9001003f),
> +       DEFINE_RES_MEM(0x90010000, 0x40),
>        DEFINE_RES_IRQ_NAMED(IRQ_RTC1Hz, "rtc 1Hz"),
>        DEFINE_RES_IRQ_NAMED(IRQ_RTCAlrm, "rtc alarm"),
>  };
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Applied

Regards
Haojian
