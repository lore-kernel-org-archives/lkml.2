Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1EDPAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:00:06 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53417 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab1EDPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:00:04 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k/atari: Do not use "/" in interrupt names
References: <alpine.DEB.2.00.1105041629390.2629@ayla.of.borg>
X-Yow: I've got to get these SNACK CAKES to NEWARK by DAWN!!
Date: Wed, 04 May 2011 17:00:00 +0200
In-Reply-To: <alpine.DEB.2.00.1105041629390.2629@ayla.of.borg> (Geert
	Uytterhoeven's message of "Wed, 4 May 2011 16:30:03 +0200 (CEST)")
Message-ID: <m3d3jybjf3.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
> index e1ada31..779efdc 100644
> --- a/arch/m68k/atari/atakeyb.c
> +++ b/arch/m68k/atari/atakeyb.c
> @@ -572,7 +572,7 @@ int atari_keyb_init(void)
>  	kb_state.len = 0;
>  
>  	error = request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt,
> -			    IRQ_TYPE_SLOW, "keyboard/mouse/MIDI",
> +			    IRQ_TYPE_SLOW, "keyboard:mouse:MIDI",

The name is not a path, but an enumeration, so the slash should probably
be changed to a comma instead.

> diff --git a/arch/m68k/atari/stdma.c b/arch/m68k/atari/stdma.c
> index 604329f..ad68fe9 100644
> --- a/arch/m68k/atari/stdma.c
> +++ b/arch/m68k/atari/stdma.c
> @@ -180,7 +180,7 @@ void __init stdma_init(void)
>  {
>  	stdma_isr = NULL;
>  	if (request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW | IRQF_SHARED,
> -			"ST-DMA: floppy/ACSI/IDE/Falcon-SCSI", stdma_int))
> +			"ST-DMA floppy:ACSI:IDE:Falcon-SCSI", stdma_int))

Likewise.

> diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
> index ce0091e..1833b12 100644
> --- a/drivers/net/atarilance.c
> +++ b/drivers/net/atarilance.c
> @@ -554,7 +554,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
>  		memaddr == (unsigned short *)0xffe00000) {
>  		/* PAMs card and Riebl on ST use level 5 autovector */
>  		if (request_irq(IRQ_AUTO_5, lance_interrupt, IRQ_TYPE_PRIO,
> -		            "PAM/Riebl-ST Ethernet", dev)) {
> +		            "PAM:Riebl-ST Ethernet", dev)) {

Likewise.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
