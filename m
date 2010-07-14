Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0GNSVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:21:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1878 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab0GNSVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:21:48 -0400
Subject: Re: [PATCH 09/11] staging: msm: formatting of pointers in printk()
From: Joe Perches <joe@perches.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>, Jiri Kosina <jkosina@suse.cz>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1279130717-15755-1-git-send-email-segooon@gmail.com>
References: <1279130717-15755-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 11:21:44 -0700
Message-ID: <1279131704.5816.3.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 22:05 +0400, Kulikov Vasiliy wrote:
> Use %p instead of %08x in printk().
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> index 8d16380..8b49cb1 100644
> --- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> +++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> @@ -208,7 +208,7 @@ static void hex_dump(char *str, void *ptr, int len)
>  
>  	for (i = 0; i < len; i++) {
>  		if (i % 16 == 0)
> -			printk("\n0x%08x:", (unsigned int)cptr);
> +			printk("\n%p:", cptr);
>  
>  		printk(" %02x", *(cptr++));
>  	}

I was originally going to suggest a conversion
to print_hex_dump, but this function isn't used
and it and daqp_dump might as well be removed.


