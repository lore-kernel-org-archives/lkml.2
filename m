Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2BVOjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:39:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2BVOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:39:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2 02/19] ARM: at91/at91x40: remove use of at91_sys_read/write
Date: Wed, 22 Feb 2012 14:36:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rmallon@gmail.com,
        linux@arm.linux.org.uk
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com>
In-Reply-To: <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221436.29474.arnd@arndb.de>
X-Provags-ID: V02:K0:o2uBctQFBHw20BTqloe/fbYqEh/F0W1eWGN7oLOUcGR
 ArnBb+01Ajaf6t08UsRR0KqTJVFyg5cRhy+d8mwdbyy2uYeuww
 dV8nSLG31G2MaoyK67tnJ7BlydosAt6m0k8/W8bSLlwrtZR9X5
 5ZGL6XdQZld41vPeFQF9GQ9Av3Avnd1Eo2toc6pQ53M3v343jl
 cSUdCo+m9lQJxVfer+NGAVzW6Ddd+dWkpn/R6IUvEnG1NGRnlu
 xRQgwjfzQOl5sYh6YBZMY7Gs+oQaSg8a9zZUwEjPzBEVC2UGC8
 zp003hbDvbUVfkn6TSP2awLHygV1dThndNReGGd6aSeco7QtD7
 UVzZXpQEdM3cUvICE2vk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas and Jean-Christophe,

On Wednesday 22 February 2012, Nicolas Ferre wrote:
> --- a/arch/arm/mach-at91/at91x40.c
> +++ b/arch/arm/mach-at91/at91x40.c
> @@ -44,7 +44,7 @@ static void at91x40_idle(void)
>          * Disable the processor clock.  The processor will be automatically
>          * re-enabled by an interrupt or by a reset.
>          */
> -       at91_sys_write(AT91_PS_CR, AT91_PS_CR_CPU);
> +       __raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
>         cpu_do_idle();
>  }

How about making this writel_relaxed in the process?
I would like to see the use of __raw_*() get reduced in code that gets
touched. In most cases writel_relaxed/readl_relaxed is the correct
accessor function instead.

	Arnd
