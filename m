Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2E1UaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:30:18 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:35639 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2E1UaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:30:17 -0400
Date: Mon, 28 May 2012 22:30:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Vincent Sanders <vince@collabora.co.uk>
Subject: Re: [PATCH 1/2] Allow constructor name selection by architecture.
Message-ID: <20120528203005.GA20560@merkur.ravnborg.org>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk> <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 07:33:37PM +0100, Vincent Sanders wrote:
> From: Vincent Sanders <vince@collabora.co.uk>
> 
> The constructor symbol name is different between platforms. Allow this
> to be selected by configuration and set suitable default values.
> 
> Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
> ---
>  include/asm-generic/vmlinux.lds.h |    6 +++---
>  init/Kconfig                      |    6 ++++++
>  kernel/module.c                   |    2 +-
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 8aeadf6..fd34808 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -471,9 +471,9 @@
>  	}
>  
>  #ifdef CONFIG_CONSTRUCTORS
> -#define KERNEL_CTORS()	. = ALIGN(8);			   \
> -			VMLINUX_SYMBOL(__ctors_start) = .; \
> -			*(.ctors)			   \
> +#define KERNEL_CTORS()	. = ALIGN(8);					\
> +			VMLINUX_SYMBOL(__ctors_start) = .;		\
> +			*(CONFIG_CONSTRUCTORS_NAME)			\
>  			VMLINUX_SYMBOL(__ctors_end) = .;

What is wrong with adding both "standard" names for ctors uncnditionally?
Like this:
> 			*(.ctors)			   \
> +			*(.init_array)			   \


	Sam
