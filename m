Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0IWR3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:29:09 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:57150 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0IWR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:29:08 -0400
Message-ID: <4C9B8E61.10805@tilera.com>
Date: Thu, 23 Sep 2010 13:29:05 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
        <jdike@addtoit.com>, <leochen@broadcom.com>, <cmetcalf@tilera.com>,
        <chris@zankel.net>, <tglx@linutronix.de>, <takata@linux-m32r.org>
Subject: Re: [tip:irq/core] genirq: Cleanup irq_chip->typename leftovers
References: <tip-d1ea13c6e2cce0106531852daaa93dd97aec9580@git.kernel.org>
In-Reply-To: <tip-d1ea13c6e2cce0106531852daaa93dd97aec9580@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Acked-by: Chris Metcalf <cmetcalf@tilera.com> (for arch/tile)

On 9/23/2010 1:16 PM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  d1ea13c6e2cce0106531852daaa93dd97aec9580
> Gitweb:     http://git.kernel.org/tip/d1ea13c6e2cce0106531852daaa93dd97aec9580
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Thu, 23 Sep 2010 18:40:07 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 23 Sep 2010 19:12:26 +0200
>
> genirq: Cleanup irq_chip->typename leftovers
>
> 3 years transition phase is enough. Cleanup the last users and remove
> the cruft.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Leo Chen <leochen@broadcom.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Chris Zankel <chris@zankel.net>
> ---
>  arch/arm/mach-bcmring/irq.c          |    6 +++---
>  arch/m32r/kernel/irq.c               |    2 +-
>  arch/m32r/platforms/m32104ut/setup.c |    2 +-
>  arch/m32r/platforms/m32700ut/setup.c |    8 ++++----
>  arch/m32r/platforms/mappi/setup.c    |    2 +-
>  arch/m32r/platforms/mappi2/setup.c   |    2 +-
>  arch/m32r/platforms/mappi3/setup.c   |    2 +-
>  arch/m32r/platforms/oaks32r/setup.c  |    2 +-
>  arch/m32r/platforms/opsput/setup.c   |    6 +++---
>  arch/m32r/platforms/usrv/setup.c     |    4 ++--
>  arch/tile/kernel/irq.c               |    4 ++--
>  arch/um/kernel/irq.c                 |    6 +++---
>  arch/xtensa/kernel/irq.c             |    2 +-
>  include/linux/irq.h                  |    6 ------
>  kernel/irq/chip.c                    |    2 --
>  15 files changed, 24 insertions(+), 32 deletions(-)
>
> diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
> index dc1c493..e315263 100644
> --- a/arch/arm/mach-bcmring/irq.c
> +++ b/arch/arm/mach-bcmring/irq.c
> @@ -67,21 +67,21 @@ static void bcmring_unmask_irq2(unsigned int irq)
>  }
>
>  static struct irq_chip bcmring_irq0_chip = {
> -       .typename = "ARM-INTC0",
> +       .name = "ARM-INTC0",
>         .ack = bcmring_mask_irq0,
>         .mask = bcmring_mask_irq0,      /* mask a specific interrupt, blocking its delivery. */
>         .unmask = bcmring_unmask_irq0,  /* unmaks an interrupt */
>  };
>
>  static struct irq_chip bcmring_irq1_chip = {
> -       .typename = "ARM-INTC1",
> +       .name = "ARM-INTC1",
>         .ack = bcmring_mask_irq1,
>         .mask = bcmring_mask_irq1,
>         .unmask = bcmring_unmask_irq1,
>  };
>
>  static struct irq_chip bcmring_irq2_chip = {
> -       .typename = "ARM-SINTC",
> +       .name = "ARM-SINTC",
>         .ack = bcmring_mask_irq2,
>         .mask = bcmring_mask_irq2,
>         .unmask = bcmring_unmask_irq2,
> diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
> index 3c71f77..7db26f1 100644
> --- a/arch/m32r/kernel/irq.c
> +++ b/arch/m32r/kernel/irq.c
> @@ -51,7 +51,7 @@ int show_interrupts(struct seq_file *p, void *v)
>                 for_each_online_cpu(j)
>                         seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
>  #endif
> -               seq_printf(p, " %14s", irq_desc[i].chip->typename);
> +               seq_printf(p, " %14s", irq_desc[i].chip->name);
>                 seq_printf(p, "  %s", action->name);
>
>                 for (action=action->next; action; action = action->next)
> diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
> index 922fdfd..402a59d 100644
> --- a/arch/m32r/platforms/m32104ut/setup.c
> +++ b/arch/m32r/platforms/m32104ut/setup.c
> @@ -65,7 +65,7 @@ static void shutdown_m32104ut_irq(unsigned int irq)
>
>  static struct irq_chip m32104ut_irq_type =
>  {
> -       .typename = "M32104UT-IRQ",
> +       .name = "M32104UT-IRQ",
>         .startup = startup_m32104ut_irq,
>         .shutdown = shutdown_m32104ut_irq,
>         .enable = enable_m32104ut_irq,
> diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
> index 9c1bc74..80b1a02 100644
> --- a/arch/m32r/platforms/m32700ut/setup.c
> +++ b/arch/m32r/platforms/m32700ut/setup.c
> @@ -71,7 +71,7 @@ static void shutdown_m32700ut_irq(unsigned int irq)
>
>  static struct irq_chip m32700ut_irq_type =
>  {
> -       .typename = "M32700UT-IRQ",
> +       .name = "M32700UT-IRQ",
>         .startup = startup_m32700ut_irq,
>         .shutdown = shutdown_m32700ut_irq,
>         .enable = enable_m32700ut_irq,
> @@ -148,7 +148,7 @@ static void shutdown_m32700ut_pld_irq(unsigned int irq)
>
>  static struct irq_chip m32700ut_pld_irq_type =
>  {
> -       .typename = "M32700UT-PLD-IRQ",
> +       .name = "M32700UT-PLD-IRQ",
>         .startup = startup_m32700ut_pld_irq,
>         .shutdown = shutdown_m32700ut_pld_irq,
>         .enable = enable_m32700ut_pld_irq,
> @@ -217,7 +217,7 @@ static void shutdown_m32700ut_lanpld_irq(unsigned int irq)
>
>  static struct irq_chip m32700ut_lanpld_irq_type =
>  {
> -       .typename = "M32700UT-PLD-LAN-IRQ",
> +       .name = "M32700UT-PLD-LAN-IRQ",
>         .startup = startup_m32700ut_lanpld_irq,
>         .shutdown = shutdown_m32700ut_lanpld_irq,
>         .enable = enable_m32700ut_lanpld_irq,
> @@ -286,7 +286,7 @@ static void shutdown_m32700ut_lcdpld_irq(unsigned int irq)
>
>  static struct irq_chip m32700ut_lcdpld_irq_type =
>  {
> -       .typename = "M32700UT-PLD-LCD-IRQ",
> +       .name = "M32700UT-PLD-LCD-IRQ",
>         .startup = startup_m32700ut_lcdpld_irq,
>         .shutdown = shutdown_m32700ut_lcdpld_irq,
>         .enable = enable_m32700ut_lcdpld_irq,
> diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
> index fb4b177..ea00c84 100644
> --- a/arch/m32r/platforms/mappi/setup.c
> +++ b/arch/m32r/platforms/mappi/setup.c
> @@ -65,7 +65,7 @@ static void shutdown_mappi_irq(unsigned int irq)
>
>  static struct irq_chip mappi_irq_type =
>  {
> -       .typename = "MAPPI-IRQ",
> +       .name = "MAPPI-IRQ",
>         .startup = startup_mappi_irq,
>         .shutdown = shutdown_mappi_irq,
>         .enable = enable_mappi_irq,
> diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
> index 6a65eda..c049376 100644
> --- a/arch/m32r/platforms/mappi2/setup.c
> +++ b/arch/m32r/platforms/mappi2/setup.c
> @@ -72,7 +72,7 @@ static void shutdown_mappi2_irq(unsigned int irq)
>
>  static struct irq_chip mappi2_irq_type =
>  {
> -       .typename = "MAPPI2-IRQ",
> +       .name = "MAPPI2-IRQ",
>         .startup = startup_mappi2_irq,
>         .shutdown = shutdown_mappi2_irq,
>         .enable = enable_mappi2_irq,
> diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
> index 9c337ae..882de25 100644
> --- a/arch/m32r/platforms/mappi3/setup.c
> +++ b/arch/m32r/platforms/mappi3/setup.c
> @@ -72,7 +72,7 @@ static void shutdown_mappi3_irq(unsigned int irq)
>
>  static struct irq_chip mappi3_irq_type =
>  {
> -       .typename = "MAPPI3-IRQ",
> +       .name = "MAPPI3-IRQ",
>         .startup = startup_mappi3_irq,
>         .shutdown = shutdown_mappi3_irq,
>         .enable = enable_mappi3_irq,
> diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
> index ed86574..d11d93b 100644
> --- a/arch/m32r/platforms/oaks32r/setup.c
> +++ b/arch/m32r/platforms/oaks32r/setup.c
> @@ -63,7 +63,7 @@ static void shutdown_oaks32r_irq(unsigned int irq)
>
>  static struct irq_chip oaks32r_irq_type =
>  {
> -       .typename = "OAKS32R-IRQ",
> +       .name = "OAKS32R-IRQ",
>         .startup = startup_oaks32r_irq,
>         .shutdown = shutdown_oaks32r_irq,
>         .enable = enable_oaks32r_irq,
> diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
> index 80d6806..5f3402a 100644
> --- a/arch/m32r/platforms/opsput/setup.c
> +++ b/arch/m32r/platforms/opsput/setup.c
> @@ -72,7 +72,7 @@ static void shutdown_opsput_irq(unsigned int irq)
>
>  static struct irq_chip opsput_irq_type =
>  {
> -       .typename = "OPSPUT-IRQ",
> +       .name = "OPSPUT-IRQ",
>         .startup = startup_opsput_irq,
>         .shutdown = shutdown_opsput_irq,
>         .enable = enable_opsput_irq,
> @@ -149,7 +149,7 @@ static void shutdown_opsput_pld_irq(unsigned int irq)
>
>  static struct irq_chip opsput_pld_irq_type =
>  {
> -       .typename = "OPSPUT-PLD-IRQ",
> +       .name = "OPSPUT-PLD-IRQ",
>         .startup = startup_opsput_pld_irq,
>         .shutdown = shutdown_opsput_pld_irq,
>         .enable = enable_opsput_pld_irq,
> @@ -218,7 +218,7 @@ static void shutdown_opsput_lanpld_irq(unsigned int irq)
>
>  static struct irq_chip opsput_lanpld_irq_type =
>  {
> -       .typename = "OPSPUT-PLD-LAN-IRQ",
> +       .name = "OPSPUT-PLD-LAN-IRQ",
>         .startup = startup_opsput_lanpld_irq,
>         .shutdown = shutdown_opsput_lanpld_irq,
>         .enable = enable_opsput_lanpld_irq,
> diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
> index 7573026..1beac7a 100644
> --- a/arch/m32r/platforms/usrv/setup.c
> +++ b/arch/m32r/platforms/usrv/setup.c
> @@ -63,7 +63,7 @@ static void shutdown_mappi_irq(unsigned int irq)
>
>  static struct irq_chip mappi_irq_type =
>  {
> -       .typename = "M32700-IRQ",
> +       .name = "M32700-IRQ",
>         .startup = startup_mappi_irq,
>         .shutdown = shutdown_mappi_irq,
>         .enable = enable_mappi_irq,
> @@ -136,7 +136,7 @@ static void shutdown_m32700ut_pld_irq(unsigned int irq)
>
>  static struct irq_chip m32700ut_pld_irq_type =
>  {
> -       .typename = "USRV-PLD-IRQ",
> +       .name = "USRV-PLD-IRQ",
>         .startup = startup_m32700ut_pld_irq,
>         .shutdown = shutdown_m32700ut_pld_irq,
>         .enable = enable_m32700ut_pld_irq,
> diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
> index 596c600..9a27d56 100644
> --- a/arch/tile/kernel/irq.c
> +++ b/arch/tile/kernel/irq.c
> @@ -208,7 +208,7 @@ static void tile_irq_chip_eoi(unsigned int irq)
>  }
>
>  static struct irq_chip tile_irq_chip = {
> -       .typename = "tile_irq_chip",
> +       .name = "tile_irq_chip",
>         .ack = tile_irq_chip_ack,
>         .eoi = tile_irq_chip_eoi,
>         .mask = tile_irq_chip_mask,
> @@ -288,7 +288,7 @@ int show_interrupts(struct seq_file *p, void *v)
>                 for_each_online_cpu(j)
>                         seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
>  #endif
> -               seq_printf(p, " %14s", irq_desc[i].chip->typename);
> +               seq_printf(p, " %14s", irq_desc[i].chip->name);
>                 seq_printf(p, "  %s", action->name);
>
>                 for (action = action->next; action; action = action->next)
> diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
> index a3f0b04..a746e30 100644
> --- a/arch/um/kernel/irq.c
> +++ b/arch/um/kernel/irq.c
> @@ -46,7 +46,7 @@ int show_interrupts(struct seq_file *p, void *v)
>                 for_each_online_cpu(j)
>                         seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
>  #endif
> -               seq_printf(p, " %14s", irq_desc[i].chip->typename);
> +               seq_printf(p, " %14s", irq_desc[i].chip->name);
>                 seq_printf(p, "  %s", action->name);
>
>                 for (action=action->next; action; action = action->next)
> @@ -369,7 +369,7 @@ static void dummy(unsigned int irq)
>
>  /* This is used for everything else than the timer. */
>  static struct irq_chip normal_irq_type = {
> -       .typename = "SIGIO",
> +       .name = "SIGIO",
>         .release = free_irq_by_irq_and_dev,
>         .disable = dummy,
>         .enable = dummy,
> @@ -378,7 +378,7 @@ static struct irq_chip normal_irq_type = {
>  };
>
>  static struct irq_chip SIGVTALRM_irq_type = {
> -       .typename = "SIGVTALRM",
> +       .name = "SIGVTALRM",
>         .release = free_irq_by_irq_and_dev,
>         .shutdown = dummy, /* never called */
>         .disable = dummy,
> diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
> index c64a5d3..8750888 100644
> --- a/arch/xtensa/kernel/irq.c
> +++ b/arch/xtensa/kernel/irq.c
> @@ -92,7 +92,7 @@ int show_interrupts(struct seq_file *p, void *v)
>                 for_each_online_cpu(j)
>                         seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
>  #endif
> -               seq_printf(p, " %14s", irq_desc[i].chip->typename);
> +               seq_printf(p, " %14s", irq_desc[i].chip->name);
>                 seq_printf(p, "  %s", action->name);
>
>                 for (action=action->next; action; action = action->next)
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index c03243a..06273a2 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -106,7 +106,6 @@ struct msi_desc;
>   * @bus_sync_unlock:   function to sync and unlock slow bus (i2c) chips
>   *
>   * @release:           release function solely used by UML
> - * @typename:          obsoleted by name, kept as migration helper
>   */
>  struct irq_chip {
>         const char      *name;
> @@ -135,11 +134,6 @@ struct irq_chip {
>  #ifdef CONFIG_IRQ_RELEASE_METHOD
>         void            (*release)(unsigned int irq, void *dev_id);
>  #endif
> -       /*
> -        * For compatibility, ->typename is copied into ->name.
> -        * Will disappear.
> -        */
> -       const char      *typename;
>  };
>
>  struct timer_rand_state;
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index b7091d5..4ea775c 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -344,8 +344,6 @@ void irq_chip_set_defaults(struct irq_chip *chip)
>         if (!chip->shutdown)
>                 chip->shutdown = chip->disable != default_disable ?
>                         chip->disable : default_shutdown;
> -       if (!chip->name)
> -               chip->name = chip->typename;
>         if (!chip->end)
>                 chip->end = dummy_irq_chip.end;
>  }

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

