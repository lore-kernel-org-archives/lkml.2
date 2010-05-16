Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0EPWs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:48:27 -0400
Received: from www.tglx.de ([62.245.132.106]:34541 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab0EPWsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:48:25 -0400
Date: Mon, 17 May 2010 00:48:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/8] input: do not select i8042 for x86 mid
In-Reply-To: <1273873281-17489-9-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170045160.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-9-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:

> From: Jacob Pan <jacob.jun.pan@intel.com>
> 
> Moorestown does not have i8042 based keyboard controller, so give
> an option to deselect i8042 for non-pc mid
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Still sending patches to your other self ? :)

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Though this patch should go via Dmitry (Cc'ed).

> ---
>  drivers/input/keyboard/Kconfig |    2 +-
>  drivers/input/mouse/Kconfig    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 64c1023..42aa650 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -73,7 +73,7 @@ config KEYBOARD_ATKBD
>  	default y
>  	select SERIO
>  	select SERIO_LIBPS2
> -	select SERIO_I8042 if X86
> +	select SERIO_I8042 if X86 && !X86_MRST
>  	select SERIO_GSCPS2 if GSC
>  	help
>  	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index c714ca2..eeb58c1 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -17,7 +17,7 @@ config MOUSE_PS2
>  	default y
>  	select SERIO
>  	select SERIO_LIBPS2
> -	select SERIO_I8042 if X86
> +	select SERIO_I8042 if X86 && !X86_MRST
>  	select SERIO_GSCPS2 if GSC
>  	help
>  	  Say Y here if you have a PS/2 mouse connected to your system. This
> -- 
> 1.6.3.3
> 
