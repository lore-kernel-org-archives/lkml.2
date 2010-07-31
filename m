Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0GaVVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:21:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61588 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab0GaVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qlqgrUTRs1jDuNWz8Y3DNv37jiAvsvo64iNqgke6Rka5OEXyTsx8zGDiKcjuY8aLbV
         dOvFgAsq5Rez5B6D22A1/3UD7zjAmzoz9wlywjh+cuJj9by2vcDgtoQbjHnOrv8aKbkD
         KXPaRa1FS8ATncRAow1dCC+eUKrNPHcWEXzyQ=
Message-ID: <4C5493DD.7010402@garzik.org>
Date: Sat, 31 Jul 2010 17:21:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cyber2000fb: fix machine hang on module load
References: <201007312255.30729.linux@rainbow-software.org>
In-Reply-To: <201007312255.30729.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 04:55 PM, Ondrej Zary wrote:
> I was testing two CyberPro 2000 based PCI cards on x86 and the machine always
> hanged completely when the cyber2000fb module was loaded. It seems that the
> card hangs when some registers are accessed too quickly after writing RAMDAC
> control register. With this patch, both card work.
>
> Add delay after RAMDAC control register write to prevent hangs on module load.
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>
> --- linux-2.6.35-rc2-orig/drivers/video/cyber2000fb.c	2010-06-06 05:43:24.000000000 +0200
> +++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-27 23:12:37.000000000 +0200
> @@ -436,6 +436,8 @@ static void cyber2000fb_write_ramdac_ctr
>   	cyber2000fb_writeb(i | 4, 0x3cf, cfb);
>   	cyber2000fb_writeb(val, 0x3c6, cfb);
>   	cyber2000fb_writeb(i, 0x3cf, cfb);
> +	/* prevent card lock-up observed on x86 with CyberPro 2000 */
> +	cyber2000fb_readb(0x3cf, cfb);
>   }

IIRC, cyber2000 is basically an S3 graphics chip.  When working on s3fb, 
over a decade ago, ISTR needing a lot of MMIO register flushes -- dummy 
register reads -- to flush out just-written register writes.


