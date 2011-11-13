Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1KMLDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 06:03:04 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:40744 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1KMLDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 06:03:03 -0500
Subject: Re: [PATCH] m68k: Remove references to obsolete CONFIG_SERIAL167
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
References: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 12:02:56 +0100
Message-ID: <1321182176.20271.43.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 11:31 +0100, Geert Uytterhoeven wrote:
> commit 51c9d654c2def97827395a7fbfd0c6f865c26544 ("Staging: delete tty
> drivers") removed the MVME167 serial driver, but forgot to remove these
> references.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/Kconfig.devices           |    2 +-
>  arch/m68k/configs/multi_defconfig   |    1 -
>  arch/m68k/configs/mvme16x_defconfig |    1 -
>  3 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
> index 6033f5d..e01eeb2 100644
> --- a/arch/m68k/Kconfig.devices
> +++ b/arch/m68k/Kconfig.devices
> @@ -128,7 +128,7 @@ config DN_SERIAL
>  
>  config SERIAL_CONSOLE
>  	bool "Support for serial port console"
> -	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || SERIAL167 || DN_SERIAL)
> +	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || DN_SERIAL)

0) The SERIAL=y part can also be dropped. There's no Kconfig symbol
SERIAL.

1) I've been looking at this impressive dependency list a few days back.
My impression was that it can be reduced to only AMIGA_BUILTIN_SERIAL=y.
(After that this Kconfig symbol might better be renamed to
AMIGA_BUILTIN_SERIAL_CONSOLE.)

I might have a draft patch to drop the dependencies somewhere. I need to
have another look at that (draft) patch before I can submit it.

>  	---help---
>  	  If you say Y here, it will be possible to use a serial port as the
>  	  system console (the system console is the device which receives all


Paul Bolle

