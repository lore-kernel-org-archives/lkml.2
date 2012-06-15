Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2FORv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:51:28 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34572 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430Ab2FORv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:51:26 -0400
Message-ID: <4FDB7617.8090500@mev.co.uk>
Date: Fri, 15 Jun 2012 18:51:19 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120601 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: fix Kconfig for COMEDI_PCMCIA_DRIVERS
References: <201206150918.55593.hartleys@visionengravers.com>
In-Reply-To: <201206150918.55593.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-15 17:18, H Hartley Sweeten wrote:
> The depends on PCCARD is redundant. All of the comedi PCMCIA
> drivers depend on PCMCIA which can only be enabled if PCCARD
> is enabled. Remove the extra depends check.
>
> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
> Cc: Ian Abbott<abbotti@mev.co.uk>
> Cc: Frank Mori Hess<fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman<gregkh@linuxfondation.org>

I tested it with Randy's config from

   Subject: Re: linux-next: Tree for Jun 14 (staging/comedi)
   Message-ID: <4FDA59D7.3050200@xenotime.net>

and `make oldconfig` no longer leaves CONFIG_COMEDI_NI_LABPC_CS, etc. 
defined, so it seems to work!

Thanks.

Tested-by: Ian Abbott <abbotti@mev.co.uk>

> ---
>   drivers/staging/comedi/Kconfig |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index 848cf7e..2ca7f08 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig
> @@ -1097,7 +1097,7 @@ endif # COMEDI_PCI_DRIVERS
>
>   menuconfig COMEDI_PCMCIA_DRIVERS
>   	tristate "Comedi PCMCIA drivers"
> -	depends on (PCMCIA || PCCARD)
> +	depends on PCMCIA
>   	---help---
>   	  Enable comedi PCMCIA and PCCARD drivers to be built
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
