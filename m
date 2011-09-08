Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1IHISi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:18:38 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40208 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab1IHISe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <1315383059-3673-7-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	<1315383059-3673-7-git-send-email-yong.zhang0@gmail.com>
Date: Thu, 8 Sep 2011 16:12:06 +0800
Message-ID: <CAA_GA1d2OEQYDcn8Jj975rK7oAqZC3nTcbkx4LurJPGc0J3_jQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 06/62] Blackfin: irq: Remove IRQF_DISABLED
From: Bob Liu <lliubbo@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Graf Yang <graf.yang@analog.com>,
        Torben Hohn <torbenh@gmx.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        uclinux-dist-devel@blackfin.uclinux.org, tglx@linutronix.de,
        Barry Song <barry.song@analog.com>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 4:10 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Looks good, I'll apply it to arch tree of blackfin.

Acked-by: Bob Liu <lliubbo@kernel.org>

Thanks
-Bob

> ---
>  arch/blackfin/kernel/time-ts.c              |    4 ++--
>  arch/blackfin/kernel/time.c                 |    1 -
>  arch/blackfin/mach-bf537/boards/cm_bf537e.c |    2 +-
>  arch/blackfin/mach-bf537/boards/cm_bf537u.c |    2 +-
>  arch/blackfin/mach-bf537/boards/stamp.c     |    2 +-
>  arch/blackfin/mach-bf537/boards/tcm_bf537.c |    2 +-
>  arch/blackfin/mach-bf561/boards/cm_bf561.c  |    2 +-
>  arch/blackfin/mach-bf561/smp.c              |    2 +-
>  8 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
> index 9e9b60d..73940b7 100644
> --- a/arch/blackfin/kernel/time-ts.c
> +++ b/arch/blackfin/kernel/time-ts.c
> @@ -188,7 +188,7 @@ irqreturn_t bfin_gptmr0_interrupt(int irq, void *dev_id)
>
>  static struct irqaction gptmr0_irq = {
>        .name           = "Blackfin GPTimer0",
> -       .flags          = IRQF_DISABLED | IRQF_TIMER | \
> +       .flags          = IRQF_TIMER | \
>                          IRQF_IRQPOLL | IRQF_PERCPU,
>        .handler        = bfin_gptmr0_interrupt,
>  };
> @@ -297,7 +297,7 @@ irqreturn_t bfin_coretmr_interrupt(int irq, void *dev_id)
>
>  static struct irqaction coretmr_irq = {
>        .name           = "Blackfin CoreTimer",
> -       .flags          = IRQF_DISABLED | IRQF_TIMER | \
> +       .flags          = IRQF_TIMER | \
>                          IRQF_IRQPOLL | IRQF_PERCPU,
>        .handler        = bfin_coretmr_interrupt,
>  };
> diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
> index ceb2bf6..2310b24 100644
> --- a/arch/blackfin/kernel/time.c
> +++ b/arch/blackfin/kernel/time.c
> @@ -25,7 +25,6 @@
>
>  static struct irqaction bfin_timer_irq = {
>        .name = "Blackfin Timer Tick",
> -       .flags = IRQF_DISABLED
>  };
>
>  #if defined(CONFIG_IPIPE)
> diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537e.c b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
> index 44fd840..9fb20d6 100644
> --- a/arch/blackfin/mach-bf537/boards/cm_bf537e.c
> +++ b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
> @@ -605,7 +605,7 @@ static struct platform_device bfin_mac_device = {
>
>  static struct pata_platform_info bfin_pata_platform_data = {
>        .ioport_shift = 2,
> -       .irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
> +       .irq_type = IRQF_TRIGGER_HIGH,
>  };
>
>  static struct resource bfin_pata_resources[] = {
> diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537u.c b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
> index 1b4ac5c..5ba389f 100644
> --- a/arch/blackfin/mach-bf537/boards/cm_bf537u.c
> +++ b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
> @@ -570,7 +570,7 @@ static struct platform_device bfin_mac_device = {
>
>  static struct pata_platform_info bfin_pata_platform_data = {
>        .ioport_shift = 2,
> -       .irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
> +       .irq_type = IRQF_TRIGGER_HIGH,
>  };
>
>  static struct resource bfin_pata_resources[] = {
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index b52e672..b971e58 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -2388,7 +2388,7 @@ static struct platform_device bfin_sport1_uart_device = {
>  #define PATA_INT       IRQ_PF5
>  static struct pata_platform_info bfin_pata_platform_data = {
>        .ioport_shift = 1,
> -       .irq_flags = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
> +       .irq_flags = IRQF_TRIGGER_HIGH,
>  };
>
>  static struct resource bfin_pata_resources[] = {
> diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
> index 9b7287a..2da0316 100644
> --- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
> +++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
> @@ -572,7 +572,7 @@ static struct platform_device bfin_mac_device = {
>
>  static struct pata_platform_info bfin_pata_platform_data = {
>        .ioport_shift = 2,
> -       .irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
> +       .irq_type = IRQF_TRIGGER_HIGH,
>  };
>
>  static struct resource bfin_pata_resources[] = {
> diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
> index e4f397d..c1b72f2 100644
> --- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
> +++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
> @@ -348,7 +348,7 @@ static struct platform_device bfin_sir0_device = {
>
>  static struct pata_platform_info bfin_pata_platform_data = {
>        .ioport_shift = 2,
> -       .irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
> +       .irq_type = IRQF_TRIGGER_HIGH,
>  };
>
>  static struct resource bfin_pata_resources[] = {
> diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
> index 85abd8b..db22401 100644
> --- a/arch/blackfin/mach-bf561/smp.c
> +++ b/arch/blackfin/mach-bf561/smp.c
> @@ -114,7 +114,7 @@ void __init platform_request_ipi(int irq, void *handler)
>        int ret;
>        const char *name = (irq == IRQ_SUPPLE_0) ? supple0 : supple1;
>
> -       ret = request_irq(irq, handler, IRQF_DISABLED | IRQF_PERCPU, name, handler);
> +       ret = request_irq(irq, handler, IRQF_PERCPU, name, handler);
>        if (ret)
>                panic("Cannot request %s for IPI service", name);
>  }
> --
> 1.7.4.1
>
> _______________________________________________
> Uclinux-dist-devel mailing list
> Uclinux-dist-devel@blackfin.uclinux.org
> https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
>
