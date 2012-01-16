Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2APQQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:16:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49289 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2APQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:16:06 -0500
Date: Mon, 16 Jan 2012 09:16:03 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: convert to generic irq_domain
Message-ID: <20120116161603.GD4223@ponder.secretlab.ca>
References: <1324099129-28832-1-git-send-email-robherring2@gmail.com>
 <20120115163538.GA19026@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115163538.GA19026@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 05:35:38PM +0100, Sebastian Andrzej Siewior wrote:
> * Rob Herring | 2011-12-16 23:18:49 [-0600]:
> 
> >From: Grant Likely <grant.likely@secretlab.ca>
> >
> >This is needed to avoid struct collisions with the generic irq_domain
> >support being added to kernel/irq/generic-chip.c.
> >
> >Boot tested, but not on a DT enabled platform.
> 
> If you add this piece into your patch:
> 
> From 34d9bb9b582136c8412e14ad870c8aaaa28c9e15 Mon Sep 17 00:00:00 2001
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date: Sun, 15 Jan 2012 16:52:13 +0100
> Subject: [PATCH] fixup of "x86: convert to generic irq_domain"
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

It's a little late for 3.3, and I've got a major rework to irq_domain
almost ready which will get merged in 3.4.  I'll rework the patch on
top of that series and get you to retest.

g.

> ---
>  arch/x86/Kconfig             |    1 +
>  arch/x86/kernel/devicetree.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d6f1e91..0d74f88 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -397,6 +397,7 @@ config X86_INTEL_CE
>  	select X86_REBOOTFIXUPS
>  	select OF
>  	select OF_EARLY_FLATTREE
> +	select IRQ_DOMAIN
>  	---help---
>  	  Select for the Intel CE media processor (CE4100) SOC.
>  	  This option compiles in support for the CE4100 SOC for settop
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> index 5632e5b..41eb2a7 100644
> --- a/arch/x86/kernel/devicetree.c
> +++ b/arch/x86/kernel/devicetree.c
> @@ -4,6 +4,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/export.h>
>  #include <linux/io.h>
> +#include <linux/irqdomain.h>
>  #include <linux/interrupt.h>
>  #include <linux/list.h>
>  #include <linux/of.h>
> -- 
> 
> you add my acked-by to it.
> 
> Sebastian
