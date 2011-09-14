Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1INTRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:17:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46885 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757306Ab1INTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:16:59 -0400
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of
 an ioremapped memory range
From: Matt Fleming <matt@console-pimps.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org
In-Reply-To: <CAC=cRTPb17tnRqDtwFMkUV7wM9=uoayerK-nj_T25EkXuWgyMg@mail.gmail.com>
References: <1314860114.32522.3.camel@rui> <1314864889.13161.4.camel@rui>
	 <1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAC=cRTOzcgm+3kHGcZrHs=9Q3cs5z6vmBqb1Bn+2qcvcSZ-2Xg@mail.gmail.com>
	 <1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAC=cRTPb17tnRqDtwFMkUV7wM9=uoayerK-nj_T25EkXuWgyMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 20:16:50 +0100
Message-ID: <1316027810.3466.78.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 16:48 +0800, huang ying wrote:
> On Mon, Sep 12, 2011 at 10:52 PM, Matt Fleming <matt@console-pimps.org> wrote:
> > On Fri, 2011-09-02 at 13:12 +0800, huang ying wrote:
> >> On Thu, Sep 1, 2011 at 8:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> >> >
> >> > Hmm.. does anyone know why we ioremap_cache() the memory on
> >> > CONFIG_X86_32 instead of ioremap_nocache()? In the case of
> >> > EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
> >> > we've ioremap'd the memory we should skip set_memory_uc() altogether,
> >> > no?
> >>
> >> Because whether the mapping should be cached is determined by md->attr
> >> instead of md->type.  And besides UC, we may add WC, etc support.
> >
> > Confused.
> >
> > The CONFIG_X86_64 version of efi_ioremap() looks like this,
> >
> > void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
> >                                 u32 type)
> > {
> >        unsigned long last_map_pfn;
> >
> >        if (type == EFI_MEMORY_MAPPED_IO)
> >                return ioremap(phys_addr, size);
> >
> > Which uses md->type to figure out if we should call ioremap(), which on
> > x86 is #define'd to ioremap_nocache(). CONFIG_X86_32 doesn't do this,
> > but it looks to me like it should.
> 
> I don't think this type based solution is the perfect one.

Why? What else would you suggest?

-- 
Matt Fleming, Intel Open Source Technology Center

