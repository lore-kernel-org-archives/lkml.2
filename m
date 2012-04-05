Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2DEKvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:51:37 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46011 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2DEKvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:51:36 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	<1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	<m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	<20120402202848.1EB833E02A7@localhost> <m2y5qdow0v.fsf@igel.home>
	<20120404154020.40C513E09D5@localhost>
X-Yow: Hello, GORRY-O!!  I'm a GENIUS from HARVARD!!
Date: Thu, 05 Apr 2012 12:51:27 +0200
In-Reply-To: <20120404154020.40C513E09D5@localhost> (Grant Likely's message of
	"Wed, 04 Apr 2012 08:40:20 -0700")
Message-ID: <m21uo2v4cw.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> I bet it is NR_IRQS related.  You have SPARSE_IRQ enabled, which means
> the maximum number of irq_descs is IRQ_BITMAP_BITS (NR_IRQS + 8192).

The actual definition uses NR_IRQS + 8196.  Guess that's a typo.  (Does
it really make sense to add NR_IRQS here?)

> diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
> index cf417e51..9edf499 100644
> --- a/arch/powerpc/include/asm/irq.h
> +++ b/arch/powerpc/include/asm/irq.h
> @@ -20,7 +20,7 @@
>  
>  /* Define a way to iterate across irqs. */
>  #define for_each_irq(i) \
> -       for ((i) = 0; (i) < NR_IRQS; ++(i))
> +       for ((i) = 0; (i) < nr_irqs; ++(i))

There are exactly two uses of for_each_irq, one is related to cpu
hotplug, the other to kexec, so that cannot make any difference.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
