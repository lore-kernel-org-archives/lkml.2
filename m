Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2HVRWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:22:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2HVRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:22:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 2/6] ARM: omap: allow building omap44xx without SMP
Date: Wed, 22 Aug 2012 17:22:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de> <1345648390-4234-3-git-send-email-arnd@arndb.de> <CAMQu2gw0x6saWrK-M3teu49tJDGvS8RhGrVSh6JTs5DEy+22pA@mail.gmail.com>
In-Reply-To: <CAMQu2gw0x6saWrK-M3teu49tJDGvS8RhGrVSh6JTs5DEy+22pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221722.06775.arnd@arndb.de>
X-Provags-ID: V02:K0:GpUlaN2hg1Ab0hLqzmSwqk7kNqfaOkO6leGgaZwHKrp
 SsyrIjzIMLw9+uRe2n77YQxt6o3bqQUXbQn2XuZWLvEXMQwMTC
 eMULj2tkt6zUEO5oP9yjcInRJX1lUx3gS2/GlNMWFWDXGTTjWC
 gZRhKBdcTFOeISV9u82/Mi9edXCzZwX0FM7362NCA+kTfO+JZq
 NIfN8Dp8v3gv6LgI40dV7honh2wIbqyNclD7BOi5ENtPBa94ZO
 NQhUg9tSXP+ziQ5q/z/ktUA6R4xhB27jB8u2E6r15IhnXYOMJM
 zYWe14LEYFA2WPKiO+LCUvCTarMDWczHTdM33324hMoDrfD8wJ
 aAfuXwe5lkBxlh5mr07E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Shilimkar, Santosh wrote:

> Was just thinking whether we should just take care of it at
> core cpuidle level itself. Will below be enough to kill the build
> error what you mentioned in the change log ?
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2c9bf26..df34534 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -314,7 +314,9 @@ static void cpuidle_coupled_poke(int cpu)
>         struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
> 
>         if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
> +#ifdef CONFIG_SMP
>                 __smp_call_function_single(cpu, csd, 0);
> +#endif
>  }
> 

That would work, but isn't the entire concept of the cpuidle-coupled driver
dependent on SMP? If this driver makes no sense on UP, I think we should
not attempt to build it.

	Arnd
