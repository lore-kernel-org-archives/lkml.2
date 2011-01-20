Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1ATSyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:54:32 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:44218 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1ATSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:54:29 -0500
Message-ID: <4D3884E3.8050009@tilera.com>
Date: Thu, 20 Jan 2011 13:54:27 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 36/37] tile: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de> <20110119210840.631350392@linutronix.de>
In-Reply-To: <20110119210840.631350392@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2011 4:50 PM, Thomas Gleixner wrote:
> No functional change.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/Kconfig |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> Index: linux-2.6/arch/tile/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/tile/Kconfig
> +++ linux-2.6/arch/tile/Kconfig
> @@ -1,22 +1,18 @@
>  # For a description of the syntax of this configuration file,
>  # see Documentation/kbuild/config-language.txt.
>  
> +config TILE
> +       def_bool y
> +       select HAVE_GENERIC_HARDIRQS
> +       select GENERIC_IRQ_PROBE
> +       select GENERIC_PENDING_IRQ if SMP
> +
>  [...]

I'm not sure it's legal to have two "config TILE" blocks in this Kconfig
file; there's already one further down.

Looking at other top-level arch Kconfigs, it does seem common to have the
"config $ARCH" block at the top, though, so if you want to move the
existing "config TILE" block to the top of the Kconfig as part of this
change, that's fine too.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

