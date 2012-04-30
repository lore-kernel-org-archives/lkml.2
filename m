Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2D3Ufm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:35:42 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:31333 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab2D3Ufl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:35:41 -0400
Date: Mon, 30 Apr 2012 22:35:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 23/29] sparc: Use generic init_task
Message-ID: <20120430203538.GA8876@merkur.ravnborg.org>
References: <20120430194725.763322463@linutronix.de> <20120430194846.989528598@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430194846.989528598@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:16:03PM -0000, Thomas Gleixner wrote:
> Same code. Use the generic version.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  arch/sparc/Kconfig            |    1 +
>  arch/sparc/kernel/init_task.c |   22 ----------------------
>  2 files changed, 1 insertion(+), 22 deletions(-)
> 
> Index: tip/arch/sparc/Kconfig
> ===================================================================
> --- tip.orig/arch/sparc/Kconfig
> +++ tip/arch/sparc/Kconfig
> @@ -31,6 +31,7 @@ config SPARC
>  	select GENERIC_PCI_IOMAP
>  	select HAVE_NMI_WATCHDOG if SPARC64
>  	select GENERIC_SMP_IDLE_THREAD
> +	select HAVE_GENERIC_INIT_TASK
>  
>  config SPARC32
>  	def_bool !64BIT
> Index: tip/arch/sparc/kernel/init_task.c
> ===================================================================
> --- tip.orig/arch/sparc/kernel/init_task.c
> +++ /dev/null

This breaks sparc build as it has the following in arch/sparc/Makefile:

    head-y                 += arch/sparc/kernel/init_task.o

And this patch deletes that file.
So at least you need to delete said line in this patch too.

	Sam
