Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1IBCTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:19:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:30017 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059Ab1IBCTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:19:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,316,1312182000"; 
   d="scan'208";a="13394646"
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of
 an ioremapped memory range
From: Zhang Rui <rui.zhang@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314860114.32522.3.camel@rui>  <1314864889.13161.4.camel@rui>
	 <1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 10:18:56 +0800
Message-ID: <1314929936.15006.19.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 20:28 +0800, Matt Fleming wrote:
> On Thu, 2011-09-01 at 16:14 +0800, Zhang Rui wrote:
> > On Thu, 2011-09-01 at 14:55 +0800, Zhang, Rui wrote: 
> > > From: Zhang Rui <rui.zhang@intel.com>
> > > Date: Wed, 31 Aug 2011 09:59:01 +0800
> > > Subject: Do not use __pa() to get the physical address of an ioremapped memory range.
> > > 
> > > set_memory_uc uses __pa() to translate the virtual address to the physical address.
> > > This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.
> > > 
> > oops, wrong patch was attached.
> > 
> > here is the correct patch.
> > 
> > From: Zhang Rui <rui.zhang@intel.com>
> > Date: Wed, 31 Aug 2011 09:59:01 +0800
> > Subject: Do not use __pa() to get the physical address of an ioremapped memory range.
> > 
> > set_memory_uc uses __pa() to translate the virtual address to the physical address.
> > This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.
> 
> Hmm.. does anyone know why we ioremap_cache() the memory on
> CONFIG_X86_32 instead of ioremap_nocache()? 

Perhaps this is because not all the memory range need ioremap_nocache(),
e.g. EFI_BOOT_SERVICES_CODE, EFI_BOOT_SERVICES_DATA, etc?

So the current logic is to use ioremap_cache for all of them first, and
then set all the non-write-back memory ranges to uncacheable.

> In the case of
> EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
> we've ioremap'd the memory we should skip set_memory_uc() altogether,
> no?
> 
In the beginning, I tried to fix efi_ioremap, i.e. use ioremap_nocache
for EFI_MEMORY_MAPPED_IO and ioremap_cache for others.
But I'm not sure if that is the right FIX, as I don't know if there
might be other memory ranges that also need to be set to uncached.

thanks,
rui

