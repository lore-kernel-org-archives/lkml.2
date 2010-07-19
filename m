Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab0GSLXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:23:34 -0400
Received: from mail4.comsite.net ([205.238.176.238]:19591 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557Ab0GSLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:23:33 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=129.33.192.138;
From: Milton Miller <miltonm@bga.com>
To: Alexander Graf <agraf@suse.de>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <8C4BCF61-7F5D-4C80-A311-93CF8521FBF5@suse.de>
Message-ID: <reloc-2010-07-19@mdm.bga.com>
References: <8C4BCF61-7F5D-4C80-A311-93CF8521FBF5@suse.de>
	<1273060251.13463.8.camel@subratamodak.linux.ibm.com>
	<20100507054034.GB25173@drongo>
	<1279193743.10707.5.camel@subratamodak.linux.ibm.com>
	<1279501889.10390.1834.camel@pasglop>
Subject: Re: [PPC64/Power7 - 2.6.35-rc5] Bad relocation warnings whileBuilding a CONFIG_RELOCATABLE kernel with CONFIG_ISERIES enabled
Date: Mon, 19 Jul 2010 06:23:32 -0500
X-Originating-IP: 129.33.192.138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Jul 19 2010 at about 03:36:51 EST, Alexander Graf wrote:
> On 19.07.2010, at 03:11, Benjamin Herrenschmidt wrote:
> 
> > On Thu, 2010-07-15 at 17:05 +0530, Subrata Modak wrote:
> > > commit e62cee42e66dcca83aae02748535f62e0f564a0c solved the problem for
> > > 2.6.34-rc6. However some other bad relocation warnings generated against
> > > 2.6.35-rc5 on Power7/ppc64 below:
> > >
> > > MODPOST 2004 modules^M
> > > WARNING: 2 bad relocations^M
> > > c000000000008590 R_PPC64_ADDR32 .text+0x4000000000008460^M
> > > c000000000008594 R_PPC64_ADDR32 .text+0x4000000000008598^M
> >
> > I think this is KVM + CONFIG_RELOCATABLE. Caused by:
> >
> > .global kvmppc_trampoline_lowmem
> > kvmppc_trampoline_lowmem:
> > .long kvmppc_handler_lowmem_trampoline - CONFIG_KERNEL_START
> >
> > .global kvmppc_trampoline_enter
> > kvmppc_trampoline_enter:
> > .long kvmppc_handler_trampoline_enter - CONFIG_KERNEL_START
> >
> > Alex, can you turn these into 64-bit on ppc64 so the relocator
> > can grok them ?
> 
> If I turn them into 64-bit, will the values be > RMA? In that case
> things would break anyways. How does relocation work on PPC? Are the
> first few megs copied over to low memory? Would I have to mask anything
> in the above code to make sure I use the real values? 
>
> Alex
>

You can still do the subtraction, but you have to allocate 64 bits for
storage.  Relocatable ppc64 kernels work by adjusting PPC64_RELOC_RELATIVE
entries during early boot (reloc in reloc_64.S called from head_64.S).

The code purposely only supports 64 bit relative addressing.

milton
