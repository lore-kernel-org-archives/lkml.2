Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1IBFML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:12:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52263 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1IBFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314860114.32522.3.camel@rui>
	<1314864889.13161.4.camel@rui>
	<1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Fri, 2 Sep 2011 13:12:06 +0800
Message-ID: <CAC=cRTOzcgm+3kHGcZrHs=9Q3cs5z6vmBqb1Bn+2qcvcSZ-2Xg@mail.gmail.com>
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of an
 ioremapped memory range
From: huang ying <huang.ying.caritas@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 8:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On Thu, 2011-09-01 at 16:14 +0800, Zhang Rui wrote:
>> On Thu, 2011-09-01 at 14:55 +0800, Zhang, Rui wrote:
>> > From: Zhang Rui <rui.zhang@intel.com>
>> > Date: Wed, 31 Aug 2011 09:59:01 +0800
>> > Subject: Do not use __pa() to get the physical address of an ioremapped memory range.
>> >
>> > set_memory_uc uses __pa() to translate the virtual address to the physical address.
>> > This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.
>> >
>> oops, wrong patch was attached.
>>
>> here is the correct patch.
>>
>> From: Zhang Rui <rui.zhang@intel.com>
>> Date: Wed, 31 Aug 2011 09:59:01 +0800
>> Subject: Do not use __pa() to get the physical address of an ioremapped memory range.
>>
>> set_memory_uc uses __pa() to translate the virtual address to the physical address.
>> This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.
>
> Hmm.. does anyone know why we ioremap_cache() the memory on
> CONFIG_X86_32 instead of ioremap_nocache()? In the case of
> EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
> we've ioremap'd the memory we should skip set_memory_uc() altogether,
> no?

Because whether the mapping should be cached is determined by md->attr
instead of md->type.  And besides UC, we may add WC, etc support.

Best Regards,
Huang Ying
