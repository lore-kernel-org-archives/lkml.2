Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab1IAM31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:29:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35742 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370Ab1IAM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:29:26 -0400
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of
 an ioremapped memory range
From: Matt Fleming <matt@console-pimps.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1314864889.13161.4.camel@rui>
References: <1314860114.32522.3.camel@rui>  <1314864889.13161.4.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 13:28:45 +0100
Message-ID: <1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 16:14 +0800, Zhang Rui wrote:
> On Thu, 2011-09-01 at 14:55 +0800, Zhang, Rui wrote: 
> > From: Zhang Rui <rui.zhang@intel.com>
> > Date: Wed, 31 Aug 2011 09:59:01 +0800
> > Subject: Do not use __pa() to get the physical address of an ioremapped memory range.
> > 
> > set_memory_uc uses __pa() to translate the virtual address to the physical address.
> > This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.
> > 
> oops, wrong patch was attached.
> 
> here is the correct patch.
> 
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Wed, 31 Aug 2011 09:59:01 +0800
> Subject: Do not use __pa() to get the physical address of an ioremapped memory range.
> 
> set_memory_uc uses __pa() to translate the virtual address to the physical address.
> This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.

Hmm.. does anyone know why we ioremap_cache() the memory on
CONFIG_X86_32 instead of ioremap_nocache()? In the case of
EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
we've ioremap'd the memory we should skip set_memory_uc() altogether,
no?

-- 
Matt Fleming, Intel Open Source Technology Center

