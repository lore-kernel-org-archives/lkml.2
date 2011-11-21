Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1KUVXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:23:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64715 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUVXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:23:11 -0500
MIME-Version: 1.0
In-Reply-To: <1321907436.32195.25.camel@x61.thuisdomein>
References: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
	<1321883764-1958-9-git-send-email-sjur.brandeland@stericsson.com>
	<1321907436.32195.25.camel@x61.thuisdomein>
Date: Mon, 21 Nov 2011 22:15:47 +0100
Message-ID: <CAJK669Yfct+-JE3OHBO_=CGuyLfrsyZz-Srm9tjBCajFmvQQEg@mail.gmail.com>
Subject: Re: [RFCv1 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> A few minor comments follow.
>
>> +++ b/drivers/xshm/Kconfig
>> @@ -0,0 +1,10 @@
>> +config XSHM
>> +     tristate "External Shared Memory Protocol (XSHM)"
>> +#    depends on GENIO
>
> Why is this added commented out?

A proper GENIO driver is not yet submitted, but will be later on (see
patch 5/9).
When this driver is contributed I'm expecting a Kconfig with "config GENIO"
to show up, that XSHM should depend upon. This comment serves as
a reminder.

>> +     default n
>> +     ---help---
>> +     Say "yes" if you want to support External Shared Memory (XSHM)
>
> "Say Y"?
>
>> +     IPC mechanism. XSHM is an IPC protocol used to talk to external
>> +     device such as modem over a shared memory (e.g. Chip to Chip).
>> +     This will normally be built-in, loadable module is used for testing.
>
> Perhaps something like: "Only say M here if you want to test XSHM and
> need to load and unload its module."?

OK, thanks I'll update these things in the next patch-set.

>> +obj-$(CONFIG_XSHM) +=  xshmchr.o
>> +xshmchr-objs := xshm_chr.o
>
> A quick scan of the other patches didn't show a file named xshmchr.c. If
> that's correct, can't you rename either the object or the source file?
Yes, you're right. I'll fix this.

>
>> +obj-$(CONFIG_XSHM) += xshm.o
>> +xshm-objs := xshm_boot.o xshm_pdev.o genio_dummy.o
>
> Are these two separate drivers (modules) that both are built if one
> Kconfig symbol is set?

Yes, that was the idea.

>If so, is there a reason why you can't use either
> one combined driver or two Kconfig symbols?

xshm exposes devices that can be of type stream or packet,
while xshm_chr and caif_xshm are drivers for stream and
packet devices. It looked as a good idea to keep these separate,
but I'm open for other opinions here. In a real life deployment
they will all be build-in anyway.

Regards,
Sjur
