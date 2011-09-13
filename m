Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1IMIsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:48:51 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:59049 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab1IMIsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314860114.32522.3.camel@rui>
	<1314864889.13161.4.camel@rui>
	<1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAC=cRTOzcgm+3kHGcZrHs=9Q3cs5z6vmBqb1Bn+2qcvcSZ-2Xg@mail.gmail.com>
	<1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Tue, 13 Sep 2011 16:48:47 +0800
Message-ID: <CAC=cRTPb17tnRqDtwFMkUV7wM9=uoayerK-nj_T25EkXuWgyMg@mail.gmail.com>
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of an
 ioremapped memory range
From: huang ying <huang.ying.caritas@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:52 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 2011-09-02 at 13:12 +0800, huang ying wrote:
>> On Thu, Sep 1, 2011 at 8:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
>> >
>> > Hmm.. does anyone know why we ioremap_cache() the memory on
>> > CONFIG_X86_32 instead of ioremap_nocache()? In the case of
>> > EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
>> > we've ioremap'd the memory we should skip set_memory_uc() altogether,
>> > no?
>>
>> Because whether the mapping should be cached is determined by md->attr
>> instead of md->type.  And besides UC, we may add WC, etc support.
>
> Confused.
>
> The CONFIG_X86_64 version of efi_ioremap() looks like this,
>
> void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>                                 u32 type)
> {
>        unsigned long last_map_pfn;
>
>        if (type == EFI_MEMORY_MAPPED_IO)
>                return ioremap(phys_addr, size);
>
> Which uses md->type to figure out if we should call ioremap(), which on
> x86 is #define'd to ioremap_nocache(). CONFIG_X86_32 doesn't do this,
> but it looks to me like it should.

I don't think this type based solution is the perfect one.

Best Regards,
Huang Ying
