Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0GGVpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:45:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756819Ab0GGVpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:45:43 -0400
Date: Wed, 7 Jul 2010 14:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
       Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] edac: mpc85xx: Fix MPC85xx dependency
Message-Id: <20100707144502.22b91374.akpm@linux-foundation.org>
In-Reply-To: <20100702124111.GA23320@oksana.dev.rtsoft.ru>
References: <20100702124111.GA23320@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010 16:41:11 +0400
Anton Vorontsov <avorontsov@mvista.com> wrote:

> Since commit 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx:
> Kconfig cleanup"), there is no MPC85xx Kconfig symbol anymore, so the
> driver became non-selectable.

hm.  5753c082f66eca5be81f6bda85c1718c5eea6ada got merged into mainline
six months ago.  How come nobody noticed?

> This patch fixes the issue by switching to PPC_85xx symbol.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> ---
>  drivers/edac/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index aedef79..0d2f9db 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -209,7 +209,7 @@ config EDAC_I5100
>  
>  config EDAC_MPC85XX
>  	tristate "Freescale MPC83xx / MPC85xx"
> -	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
> +	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
>  	help
>  	  Support for error detection and correction on the Freescale
>  	  MPC8349, MPC8560, MPC8540, MPC8548

I suppose we shold scoot this into 2.6.35 and mark it for -stable
backporting.  All very odd.

