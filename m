Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0KCVsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:48:05 -0400
Received: from mail.perches.com ([173.55.12.10]:3967 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab0KCVsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:48:04 -0400
Subject: Re: [PATCH 1/3] Staging: comedi: fix brace coding style issue in
 ni_tio.c This is a patch to the ni_tio.c file that fixes up a brace,
 indentation and overlines warning found by the checkpatch.pl tool
 Signed-off-by: Varayud Damian Alfredo <davarayud@gmail.com>
From: Joe Perches <joe@perches.com>
To: Damian Varayud <davarayud@gmail.com>
Cc: gregkh@suse.de, harmonco@engr.orst.edu, sam.j.richardson@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288819162-6330-1-git-send-email-user@netbu>
References: <1288819162-6330-1-git-send-email-user@netbu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:48:02 -0700
Message-ID: <1288820882.10236.35.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 18:19 -0300, Damian Varayud wrote:
> ---
>  drivers/staging/comedi/drivers/ni_tio.c |  154 ++++++++++++++++++-------------
>  1 files changed, 89 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
> index a9bb6b1..dd3db48 100644
> --- a/drivers/staging/comedi/drivers/ni_tio.c
> +++ b/drivers/staging/comedi/drivers/ni_tio.c
> @@ -59,8 +59,8 @@ MODULE_DESCRIPTION("Comedi support for NI general-purpose counters");
>  MODULE_LICENSE("GPL");
>  
>  static inline enum Gi_Counting_Mode_Reg_Bits Gi_Alternate_Sync_Bit(enum
> -								   ni_gpct_variant
> -								   variant)
> +								ni_gpct_variant
> +								variant)

Hi Damian.

This isn't an improvement.

It'd be better as:

static inline enum Gi_Counting_Mode_Reg_Bits
Gi_Alternate_Sync_Bit(enum ni_gpct_variant variant)

> @@ -122,8 +122,8 @@ static inline enum Gi_Counting_Mode_Reg_Bits Gi_Prescale_X8_Bit(enum
>  }
>  
>  static inline enum Gi_Counting_Mode_Reg_Bits Gi_HW_Arm_Select_Mask(enum
> -								   ni_gpct_variant
> -								   variant)
> +								ni_gpct_variant
> +								variant)

here too

[]

> @@ -291,21 +296,22 @@ static void __exit ni_tio_cleanup_module(void)
>  
>  module_exit(ni_tio_cleanup_module);
>  
> -struct ni_gpct_device *ni_gpct_device_construct(struct comedi_device *dev,
> -						void (*write_register) (struct
> -									ni_gpct
> -									*
> -									counter,
> -									unsigned
> -									bits,
> -									enum
> -									ni_gpct_register
> -									reg),
> -						unsigned (*read_register)
> -						(struct ni_gpct *counter,
> -						 enum ni_gpct_register reg),
> -						enum ni_gpct_variant variant,
> -						unsigned num_counters)
> +struct ni_gpct_device *ni_gpct_device_construct
> +				(struct comedi_device *dev,
> +				void (*write_register) (struct
> +							ni_gpct
> +							*
> +							counter,
> +							unsigned
> +							bits,
> +							enum
> +							ni_gpct_register
> +							reg),
> +				unsigned (*read_register)
> +				(struct ni_gpct *counter,
> +					enum ni_gpct_register reg),
> +				enum ni_gpct_variant variant,
> +				unsigned num_counters)

And this is just plain ugly.

How about:

struct ni_gpct_device *
ni_gpct_device_construct(struct comedi_device *dev,
			 void (*write_register)(struct ni_gpct *counter,
						unsigned bit,
						enum ni_gpct_register reg),
			 unsigned (*read__register)(struct ni_gpct *counter,
						    enum ni_gpct_variant variant,
						    unsigned num_counters))

Please try to use some taste in ignoring checkpatch output
when appropriate.  80 columns isn't dicta.

cheers, Joe

