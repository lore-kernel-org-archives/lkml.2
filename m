Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2H3UTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 16:19:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37169 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab2H3UTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 16:19:00 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH - 2/2] arm: disable caches based on config option
Thread-Topic: [PATCH - 2/2] arm: disable caches based on config option
Thread-Index: AQHNhr3i9cZ4a9phT0aLvKNYKf/eSZdy1yMA///0omA=
Date: Thu, 30 Aug 2012 20:18:49 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041AD7AD@DFLE12.ent.ti.com>
References: <1346337826-27232-1-git-send-email-m-karicheri2@ti.com>
 <1346337826-27232-2-git-send-email-m-karicheri2@ti.com>
 <alpine.LFD.2.02.1208301156390.1784@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208301156390.1784@xanadu.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Submitted. Thanks.

Murali Karicheri
Software Design Engineer


>> -----Original Message-----
>> From: Nicolas Pitre [mailto:nicolas.pitre@linaro.org]
>> Sent: Thursday, August 30, 2012 11:59 AM
>> To: Karicheri, Muralidharan
>> Cc: Russell King - ARM Linux; tony@atomide.com; Shilimkar, Santosh; wim@iguana.be;
>> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH - 2/2] arm: disable caches based on config option
>> 
>> On Thu, 30 Aug 2012, Murali Karicheri wrote:
>> 
>> > CONFIG_CPU_ICACHE_DISABLE and CONFIG_CPU_DCACHE_DISABLE are available
>> > to allow disabling of D-Cache and I-Cache. However the compressed version
>> > of head.S currently doesn't check these variables. This patch will fix
>> > this issue and is written similar to the uncompressed version of head.S
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> Acked-by: nicolas Pitre <nico@linaro.org>
>> 
>> You may submit your patch to http://www.arm.linux.org.uk/developer/patches/.
>> 
>> 
>> > ---
>> >  arch/arm/boot/compressed/head.S |    6 ++++++
>> >  1 file changed, 6 insertions(+)
>> >
>> > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
>> > index b8c64b8..e1d2124 100644
>> > --- a/arch/arm/boot/compressed/head.S
>> > +++ b/arch/arm/boot/compressed/head.S
>> > @@ -659,6 +659,12 @@ __armv7_mmu_cache_on:
>> >  #ifdef CONFIG_CPU_ENDIAN_BE8
>> >  		orr	r0, r0, #1 << 25	@ big-endian page tables
>> >  #endif
>> > +#ifdef CONFIG_CPU_DCACHE_DISABLE
>> > +		bic	r0, r0, #1 << 2
>> > +#endif
>> > +#ifdef CONFIG_CPU_ICACHE_DISABLE
>> > +		bic	r0, r0, #1 << 12
>> > +#endif
>> >  		orrne	r0, r0, #1		@ MMU enabled
>> >  		movne	r1, #0xfffffffd		@ domain 0 = client
>> >  		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
>> > --
>> > 1.7.9.5
>> >
