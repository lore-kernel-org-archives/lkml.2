Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0GaVZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:25:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50965 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab0GaVZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:25:31 -0400
Date: Sat, 31 Jul 2010 22:25:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cyber2000fb: fix machine hang on module load
Message-ID: <20100731212509.GA3633@n2100.arm.linux.org.uk>
References: <201007312255.30729.linux@rainbow-software.org> <4C5493DD.7010402@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5493DD.7010402@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 05:21:33PM -0400, Jeff Garzik wrote:
> On 07/31/2010 04:55 PM, Ondrej Zary wrote:
>> I was testing two CyberPro 2000 based PCI cards on x86 and the machine always
>> hanged completely when the cyber2000fb module was loaded. It seems that the
>> card hangs when some registers are accessed too quickly after writing RAMDAC
>> control register. With this patch, both card work.
>>
>> Add delay after RAMDAC control register write to prevent hangs on module load.
>>
>> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>>
>> --- linux-2.6.35-rc2-orig/drivers/video/cyber2000fb.c	2010-06-06 05:43:24.000000000 +0200
>> +++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-27 23:12:37.000000000 +0200
>> @@ -436,6 +436,8 @@ static void cyber2000fb_write_ramdac_ctr
>>   	cyber2000fb_writeb(i | 4, 0x3cf, cfb);
>>   	cyber2000fb_writeb(val, 0x3c6, cfb);
>>   	cyber2000fb_writeb(i, 0x3cf, cfb);
>> +	/* prevent card lock-up observed on x86 with CyberPro 2000 */
>> +	cyber2000fb_readb(0x3cf, cfb);
>>   }
>
> IIRC, cyber2000 is basically an S3 graphics chip.

No such luck.  It's a proprietary Integraphics chip, mainly used in
ARM Netwinders some 10 years ago.  It's completely different from the
S3 chips such as Trio64.
