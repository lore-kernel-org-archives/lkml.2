Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1GNLfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:35:21 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:63925 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1GNLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:35:20 -0400
Message-ID: <19998.54360.684936.674009@ipc1.ka-ro>
Date: Thu, 14 Jul 2011 13:34:48 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        thierry.nolf.barco@gmail.com, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] new helper to define common struct resource constructs
In-Reply-To: <1310631065-4271-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110713141849.b8cbf675.akpm@linux-foundation.org>
	<1310631065-4271-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Uwe Kleine-König writes:
> resource definitions that just define start, end and flags =
> IORESOURCE_MEM or IORESOURCE_IRQ (with start=end) are quite common. So
> introduce a shortcut for them. For completeness add macros for
> IORESOURCE_DMA and IORESOURCE_IO, too and also make available a set of
> macros to specify named resources of all types which are less common.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> changes since v2:
> - add parentheses around macro parameter usages
> 
> changes since v1:                                                               
> - also add _IO and _DMA variants                                                
> 
>  include/linux/ioport.h |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 63eb429..9d57a71 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -109,6 +109,36 @@ struct resource_list {
>  /* PCI control bits.  Shares IORESOURCE_BITS with above PCI ROM.  */
>  #define IORESOURCE_PCI_FIXED		(1<<4)	/* Do not move resource */
>  
> +
> +/* helpers to define resources */
> +#define DEFINE_RES_NAMED(_start, _size, _name, _flags)			\
> +	{								\
> +		.start = (_start),					\
> +		.end = (_start) + (_size) - 1,				\
> +		.name = (_name),					\
> +		.flags = (_flags),					\
> +	}
> +
> +#define DEFINE_RES_IO_NAMED(_start, _size, _name)			\
> +	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_IO)
>
There is no need for parens around a macro argument when it is not
part of an expression...
This just looks silly.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
