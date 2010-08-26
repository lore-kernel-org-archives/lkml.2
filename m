Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0HZOOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:14:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41012 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab0HZOOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:14:52 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 26 Aug 2010 09:13:16 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActFJ29is6oB/tQ5RGOIv/ZsjaVfHAAAWRLC
Message-ID: <496565EC904933469F292DDA3F1663E602F10ED4B4@dlee06.ent.ti.com>
References: <496565EC904933469F292DDA3F1663E602F10ED4B1@dlee06.ent.ti.com>
	<20100826215554N.fujita.tomonori@lab.ntt.co.jp>
	<496565EC904933469F292DDA3F1663E602F10ED4B3@dlee06.ent.ti.com>,<20100826230139Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826230139Y.fujita.tomonori@lab.ntt.co.jp>
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

________________________________________
>From: FUJITA Tomonori [fujita.tomonori@lab.ntt.co.jp]
>Sent: Thursday, August 26, 2010 9:03 AM
>To: Guzman Lugo, Fernando
>Cc: fujita.tomonori@lab.ntt.co.jp; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; ohad@wizery.com; hiroshi.doyu@nokia.com; ameya.palande@nokia.com; >felipe.contreras@nokia.com
>Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
>
>On Thu, 26 Aug 2010 08:16:24 -0500
>"Guzman Lugo, Fernando" <fernando.lugo@ti.com> wrote:
>
>> >From a quick look, arch/arm/plat-omap/iovmm.c does nothing wrong about
>> >scatter gather chaining. arm/arm/mm/dma-mapping.c looks fine too about
>> >it. Maybe just defining ARCH_HAS_SG_CHAIN works?
>>
>> I can try, but it looks tricky for me. Maybe someone else can tell us why
>> SG chain is not supported for ARM or if there is a problem just defining
>> ARCH_HAS_SG_CHAIN.
>
>I suppose that nobody in ARM has been interested in the feature. It
>was invented to improve I/O performance with large I/O requests. No
>wonder embeded people aren't interested in it.
>
>fujita@rose:~/git/linux-2.6$ find arch -name 'scatterlist.h'|xargs grep HAS_SG
>arch/x86/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
>arch/ia64/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
>arch/sparc/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
>arch/powerpc/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN

Ok, so let me try SG chain, that should be the correct fix.

Thanks a lot,
Fernando.
