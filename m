Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab0HZNQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:16:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33506 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0HZNQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:16:29 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 26 Aug 2010 08:16:24 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActFHippVrzaXIdfS9uiXGfAlr+Y9AAAVY4s
Message-ID: <496565EC904933469F292DDA3F1663E602F10ED4B3@dlee06.ent.ti.com>
References: <1277943660-4112-9-git-send-email-x0095840@ti.com>
	<20100826155416J.fujita.tomonori@lab.ntt.co.jp>
	<496565EC904933469F292DDA3F1663E602F10ED4B1@dlee06.ent.ti.com>,<20100826215554N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826215554N.fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>________________________________________
>From: FUJITA Tomonori [fujita.tomonori@lab.ntt.co.jp]
>Sent: Thursday, August 26, 2010 7:56 AM
>To: Guzman Lugo, Fernando
>Cc: fujita.tomonori@lab.ntt.co.jp; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; ohad@wizery.com; hiroshi.doyu@nokia.com; ameya.palande@nokia.com; >felipe.contreras@nokia.com
>Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
>
>On Thu, 26 Aug 2010 07:38:26 -0500
>"Guzman Lugo, Fernando" <fernando.lugo@ti.com> wrote:
>
>> >> due to a restriction in scatter gather lists, it can
>> >> not be created a list for a buffer bigger than 1MB.
>> >> This patch is spliting big mappings into 1MB mappings.
>> >
>> >I don't read the whole thread but the above description is incorrect.
>> >
>> >Why can't you use scatter gather chaining? You can create a scatter
>> >list for a buffer larger than 1MB.
>>
>> The thing is that ARM architecture does not support SG chaining. This patch should be
>> seen like a workaround until it is fixed in iovmm module.
>
>Fix iovmm module is easier than the workaround?

I have not thought about possible fixes inside iovmm, but now I am reviewing the
patches I will figure out how to fix this inside iovmm. Since he workaround still
can fail to allocate big buffers even though there is space to allocate it.

>
>From a quick look, arch/arm/plat-omap/iovmm.c does nothing wrong about
>scatter gather chaining. arm/arm/mm/dma-mapping.c looks fine too about
>it. Maybe just defining ARCH_HAS_SG_CHAIN works?

I can try, but it looks tricky for me. Maybe someone else can tell us why
SG chain is not supported for ARM or if there is a problem just defining 
ARCH_HAS_SG_CHAIN.

Regards,
Fernando.



