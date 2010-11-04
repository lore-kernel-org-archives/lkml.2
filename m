Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0KDTVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:21:03 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:50819
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab0KDTVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:21:00 -0400
X-SpamScore: -23
X-BigFish: VS-23(zzbb2dK542N1432N4015L9371P8c03lzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
Date: Thu, 4 Nov 2010 12:21:33 -0700
Message-ID: <86A0E76937111F4C92FABEC0A20988510523CEC2@az33exm21>
In-Reply-To: <4CD12833.8060204@eukrea.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
Thread-Index: Act7N9TRie4QQ4xUQIG4uAgv/Mx+IwBG+Xqg
References: <1288736227-800-1-git-send-email-Dinh.Nguyen@freescale.com> <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com> <4CD12833.8060204@eukrea.com>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
CC: <linux-kernel@vger.kernel.org>, <amit.kucheria@canonical.com>,
        <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
        <grant.likely@secretlab.ca>, <linux-arm-kernel@lists.infradead.org>,
        <daniel@caiaq.de>, <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>, <valentin.longchamp@epfl.ch>
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

>-----Original Message-----
>From: Eric Bénard [mailto:eric@eukrea.com]
>Sent: Wednesday, November 03, 2010 4:16 AM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; amit.kucheria@canonical.com; linux@arm.linux.org.uk;
>s.hauer@pengutronix.de; grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
>daniel@caiaq.de; u.kleine-koenig@pengutronix.de; Zhang Lily-R58066; valentin.longchamp@epfl.ch
>Subject: Re: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
>
>Hi Dinh,
>
>Le 02/11/2010 23:17, Dinh.Nguyen@freescale.com a écrit :
>> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>>
>> Add mx53 support to cpu.c and mm.c.
>>
>> Signed-off by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>>   static void query_silicon_parameter(void)
>>   {
>> -	void __iomem *rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
>> +	void __iomem *rom;
>>   	u32 rev;
>>
>> +	if (cpu_is_mx51())
>> +		rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
>> +	else if (cpu_is_mx53())
>> +		rom = ioremap(MX53_IROM_BASE_ADDR, MX53_IROM_SIZE);
>> +
>isn't the correct way to get the silicon revision to read the "Product
>Revision register" and "Silicon Revision register" of the IIM and not from the
>internal ROM ? (page 41-11 of the i.MX51 reference manual).
>
>Eric

Reading the ROM code is probably the most reliable way to get the correct silicon revision. Because the ROM that is on the chip is "most likely" up-to-date with the silicon. "Most likely" means that 95% of the time, when you get a new silicon, the ROM code will get updated. There is still a chance that a new silicon will not require a ROM update.

Also the other reason is that sometimes the fuses that identify the silicon revision that are used by the IIM are sometimes not blown to reflect the correct revision in pre-production parts. MX51 is a post production part, so in theory, the fuses are blown correctly. But since we made MX51 boards available prior to going into production, reading from the IIM is not as reliable as reading the ROM.

Thanks,
Dinh

