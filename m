Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2FFKQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:16:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39406 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2FFKQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:16:44 -0400
Message-ID: <4FCF2E07.1090401@mev.co.uk>
Date: Wed, 6 Jun 2012 11:16:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120601 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: ni_mio_common.c: local functions should
 be static
References: <201206051120.22177.hartleys@visionengravers.com>
In-Reply-To: <201206051120.22177.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-05 19:20, H Hartley Sweeten wrote:
> Local functions should be marked static to prevent them from
> being exposed globally.
>
> This quiets the following sparse warnings:
>
> warning: symbol 'ni_release_gpct_mite_channel' was not declared. Should it be static?
> warning: symbol 'ni_prime_channelgain_list' was not declared. Should it be static?
>
> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
> Cc: Ian Abbott<abbotti@mev.co.uk>
> Cc: Mori Hess<fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>
> ---
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index fd232bc..3b3a0b1 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -644,7 +644,7 @@ static void ni_release_ao_mite_channel(struct comedi_device *dev)
>   #endif /*  PCIDMA */
>   }
>
> -void ni_release_gpct_mite_channel(struct comedi_device *dev,
> +static void ni_release_gpct_mite_channel(struct comedi_device *dev,
>   				  unsigned gpct_index)
>   {
>   #ifdef PCIDMA
> @@ -1880,7 +1880,7 @@ static int ni_ai_insn_read(struct comedi_device *dev,
>   	return insn->n;
>   }

This results in a compiler warning about the unused function 
ni_release_gpct_mite_channel when compiling ni_atmio.c.  It was unused 
before of course, but now it is static, the compiler realizes it!

It could be fixed for now by moving the '#ifdef PCIDMA' and matching 
'#endif' to surround the whole function, though I guess we want to try 
and get rid of the #ifdef's eventually.  It's tricky because 
ni_mio_common.c isn't a standalone compilation unit, it's #include'd by 
some other .c files.  We might need to have a go at splitting it up at 
some point.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
