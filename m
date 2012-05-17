Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596Ab2EQKzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:55:19 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:30606
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761649Ab2EQKzL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:55:11 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Thu, 17 May 2012 06:55:36 -0400
Subject: RE: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver
 for BF60x family processors.
Thread-Topic: [PATCH] driver: char: bfin_crc: CRC hardware accelerator
 driver for BF60x family processors.
Thread-Index: Ac0zXU3gjTIWydb7RvulM112Hn+a/QAvVGIQ
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F64F85057@NWD2CMBX1.ad.analog.com>
References: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com>
 <20120516121237.GC31261@kroah.com>
In-Reply-To: <20120516121237.GC31261@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>-----Original Message-----
>From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
>Sent: Wednesday, May 16, 2012 8:13 PM
>To: Zhang, Sonic
>Cc: Arnd Bergmann; LKML; uclinux-dist-devel@blackfin.uclinux.org
>Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver for
>BF60x family processors.
>
>On Wed, May 16, 2012 at 04:26:07PM +0800, sonic.zhang@analog.com wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> The CRC peripheral is a hardware block used to compute the CRC of the block
>> of data. This is based on a CRC32 engine which computes the CRC value of 32b
>> data words presented to it. For data words of < 32b in size, it is the
>> responsibility of the application to pack the data into 32b data units.
>>
>> This driver defines data strcture crc_info and 4 IOCTL interfaces for applciations.
>> 1) CRC Memory Scan
>> 2) CRC Memory Transfer
>> 3) CRC Data Verify
>> 4) CRC Data Fill
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> ---
>>  drivers/char/Kconfig    |    8 +
>>  drivers/char/Makefile   |    1 +
>>  drivers/char/bfin_crc.c |  537
>+++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 546 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/char/bfin_crc.c
>
>Why is this a char driver, and not a crypto driver, using the existing
>crypto userspace api for things like this?
>

It looks only the CRC memory scan mode can be implemented as a crypto ahash driver. The other 3 functions are not supported in the crypto framework.
I will post a crypto driver for the CRC memory scan mode later.

Sonic


>> diff --git a/drivers/char/bfin_crc.c b/drivers/char/bfin_crc.c
>> new file mode 100644
>> index 0000000..3f7d1d8
>> --- /dev/null
>> +++ b/drivers/char/bfin_crc.c
>> @@ -0,0 +1,537 @@
>> +/*
>> + * Blackfin On-Chip hardware CRC Driver
>> + *
>> + * Copyright 2011 Analog Devices Inc.
>> + *
>> + * Licensed under the GPL-2 or later.
>
>Do you really mean "or later"?  It's fine if you do, just checking.
>
>thanks,
>
>greg k-h


