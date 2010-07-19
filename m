Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0GSHgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 03:36:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab0GSHgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 03:36:46 -0400
Subject: Re: [PPC64/Power7 - 2.6.35-rc5] Bad relocation warnings while Building a CONFIG_RELOCATABLE kernel with CONFIG_ISERIES enabled
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1279501889.10390.1834.camel@pasglop>
Date: Mon, 19 Jul 2010 09:36:39 +0200
Cc: subrata@linux.vnet.ibm.com, Paul Mackerras <paulus@samba.org>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Paul Mackerras <paulus@au1.ibm.com>, divya.vikas@in.ibm.com
Content-Transfer-Encoding: 8BIT
Message-Id: <8C4BCF61-7F5D-4C80-A311-93CF8521FBF5@suse.de>
References: <1273060251.13463.8.camel@subratamodak.linux.ibm.com> <20100507054034.GB25173@drongo> <1279193743.10707.5.camel@subratamodak.linux.ibm.com> <1279501889.10390.1834.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19.07.2010, at 03:11, Benjamin Herrenschmidt wrote:

> On Thu, 2010-07-15 at 17:05 +0530, Subrata Modak wrote:
>> commit e62cee42e66dcca83aae02748535f62e0f564a0c solved the problem for
>> 2.6.34-rc6. However some other bad relocation warnings generated against
>> 2.6.35-rc5 on Power7/ppc64 below:
>> 
>> MODPOST 2004 modules^M
>> WARNING: 2 bad relocations^M
>> c000000000008590 R_PPC64_ADDR32    .text+0x4000000000008460^M
>> c000000000008594 R_PPC64_ADDR32    .text+0x4000000000008598^M
> 
> I think this is KVM + CONFIG_RELOCATABLE. Caused by:
> 
> .global kvmppc_trampoline_lowmem
> kvmppc_trampoline_lowmem:
> 	.long kvmppc_handler_lowmem_trampoline - CONFIG_KERNEL_START
> 
> .global kvmppc_trampoline_enter
> kvmppc_trampoline_enter:
> 	.long kvmppc_handler_trampoline_enter - CONFIG_KERNEL_START
> 
> Alex, can you turn these into 64-bit on ppc64 so the relocator
> can grok them ?

If I turn them into 64-bit, will the values be > RMA? In that case things would break anyways. How does relocation work on PPC? Are the first few megs copied over to low memory? Would I have to mask anything in the above code to make sure I use the real values?

Alex

