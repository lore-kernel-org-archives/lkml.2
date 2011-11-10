Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1KJKWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:22:36 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:35624 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1KJKWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:22:34 -0500
Subject: Re: [PATCH] [TRIVIAL] 8250_hp300: Fix warning typo 'CONFIG_8250'
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Philip Blundell <philb@gnu.org>
In-Reply-To: <CAMuHMdVMkLgqjwb7yvFR-tLR2pHcckxkTLDkjNSNjAat9NZ1Mg@mail.gmail.com>
References: <1320673476.14409.367.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111081025470.1964@pobox.suse.cz>
	 <1320744887.14409.379.camel@x61.thuisdomein>
	 <CAMuHMdVMkLgqjwb7yvFR-tLR2pHcckxkTLDkjNSNjAat9NZ1Mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 11:22:13 +0100
Message-ID: <1320920533.27598.67.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 20:52 +0100, Geert Uytterhoeven wrote:
> I have this reminder in my local tree:
> 
> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
> index 6033f5d..354ce91 100644
> --- a/arch/m68k/Kconfig.devices
> +++ b/arch/m68k/Kconfig.devices
> @@ -109,6 +109,7 @@ config MULTIFACE_III_TTY
>           To compile this driver as a module, choose M here.
> 
>  config HPDCA
> +       # FIXME Should be bool and select SERIAL_8250_HP300?
>         tristate "HP DCA serial support"
>         depends on DIO && SERIAL_8250
>         help
> @@ -116,6 +117,7 @@ config HPDCA
>           machine, say Y here.
> 
>  config HPAPCI
> +       # FIXME Should be bool and select SERIAL_8250_HP300?
>         tristate "HP APCI serial support"
>         depends on HP300 && SERIAL_8250 && EXPERIMENTAL
>         help
> 
> However, if these two options are bool, SERIAL_8250_HP300 can never
> be m anymore.

0) This might turn out not to be relevant, but are HPDCA and HPAPCI
exclusive?

> Ah, if we just kill SERIAL_8250_HP300, we can put in the Makefile:
> 
> obj-$(CONFIG_HPDCA) += 8250_hp300.o
> obj-$(CONFIG_HPAPCI) += 8250_hp300.o
> 
> Does that make sense?

1) Makefiles always make me nervous. What happens if both CONFIG_HPDCA
and CONFIG_HPAPCI are set?

2) This means upgrading both symbols to tristate, doesn't it? It seems
that someone could then end up with this driver builtin instead of as a
module on upgrade (eg, SERIAL_8250_HP300=m and HPDCA=y becomes just
HPDCA=y on upgrade). But I'm not sure whether that is how the config
tools handle symbol upgrades.

3) Does changing the SERIAL_8250_HP300 entry to
    config SERIAL_8250_HP300
            tristate
            depends on HP300 && (HPDCA || HPAPCI)
            default SERIAL_8250

work for you? That only changes the "depends on" line.

(If you make HPDCA depend on HP300, which it seems to do in practice,
the dependency on HP300 could also be dropped here.)


Paul Bolle

