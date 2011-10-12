Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1JLNtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:49:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1JLNte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:49:34 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <069601cc88dc$6b9a78d0$42cf6a70$%kim@samsung.com>
References: <1317961214.16109.1.camel@phoenix> <069601cc88dc$6b9a78d0$42cf6a70$%kim@samsung.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 12 Oct 2011 21:49:13 +0800
Message-ID: <CAF+7xWmXGovD4zdst16fdX66voauhvKFTctQLEORX9tosckfkg@mail.gmail.com>
Subject: Re: [PATCH] ARM: SAMSUNG: s3c-dma-ops needs export.h for EXPORT_SYMBOL
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Boojin Kim <boojin.kim@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/12 Kukjin Kim <kgene.kim@samsung.com>:
> Kukjin Kim wrote:
>>
>> Axel Lin wrote:
>> >
>> > Fix below build warning:
>> >   CC      arch/arm/plat-samsung/s3c-dma-ops.o
>> > arch/arm/plat-samsung/s3c-dma-ops.c:130: warning: data definition has no type
>> or
>> > storage class
>> > arch/arm/plat-samsung/s3c-dma-ops.c:130: warning: type defaults to 'int' in
>> > declaration of 'EXPORT_SYMBOL'
>> > arch/arm/plat-samsung/s3c-dma-ops.c:130: warning: parameter names (without
>> > types) in function declaration
>> >
>> > And fix the build error:
>> > ERROR: "s3c_dma_get_ops" [drivers/spi/spi-s3c64xx.ko] undefined!
>> > make[1]: *** [__modpost] Error 1
>> > make: *** [modules] Error 2
>> >
>> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> > ---
>> > This can be reproduced by "make s3c6400_defconfig;make" on linux-next
>> > 20111006.
>> >  arch/arm/plat-samsung/s3c-dma-ops.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/arm/plat-samsung/s3c-dma-ops.c b/arch/arm/plat-samsung/s3c-
>> > dma-ops.c
>> > index 582333c..7814949 100644
>> > --- a/arch/arm/plat-samsung/s3c-dma-ops.c
>> > +++ b/arch/arm/plat-samsung/s3c-dma-ops.c
>> > @@ -14,6 +14,7 @@
>> >  #include <linux/errno.h>
>> >  #include <linux/slab.h>
>> >  #include <linux/types.h>
>> > +#include <linux/export.h>
>> >
>> >  #include <mach/dma.h>
>> >
>> > --
>> > 1.7.4.1
>> >
>> OK, will apply.
>>
>> BTW, I don't know why the build error/warning was not happened in my tree with
>> s3c6400_defconfig. Probably other file having it?...
>>
> Hi Axel,
>
> When I applied this in my tree, happened following error with s3c6400_defconfig.
>
> arch/arm/plat-samsung/s3c-dma-ops.c:17: fatal error: linux/export.h: No such file or directory
>
> Probably the <linux/export.h> file has been added from other tree.
> So if required, will fix with this during upcoming merge window maybe at end of.
>
Cc Paul Gortmaker,
Maybe it is only in Paul's tree now.

Regards,
Axel
