Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1LFQVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:21:16 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48693 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1LFQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:21:15 -0500
Date: Tue, 6 Dec 2011 21:51:00 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Steffen Persvold <sp@numascale.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        daniel@numascale-asia.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip] Fix build failure x86_default_fixup_cpu_id() with
 !CONFIG_SMP
Message-ID: <20111206162100.GC8567@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20111206104755.GA8567@linux.vnet.ibm.com>
 <4EDDFE79.9010109@linux.vnet.ibm.com>
 <4EDE002E.8040007@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4EDE002E.8040007@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120616-5564-0000-0000-00000065ABEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steffen Persvold <sp@numascale.com> [2011-12-06 12:44:46]:

> On 12/6/2011 12:37, Srivatsa S. Bhat wrote:
> >Hi Kamalesh,
> >
> >On 12/06/2011 04:17 PM, Kamalesh Babulal wrote:
> >
> >>Hi,
> >>
> >>tip (a4a7e7e29333) build fails, when compiled with !CONFIG_SMP.
> >>I have only build tested the patch.
> >>
> >>x86: Fix x86_default_fixup_cpu_id() build failure with !CONFIG_SMP
> >>
> >>arch/x86/kernel/cpu/common.c: In function 'x86_default_fixup_cpu_id':
> >>arch/x86/kernel/cpu/common.c:1149: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
> >>make[3]: *** [arch/x86/kernel/cpu/common.o] Error 1
> >>
> >>the code was introduced by commit 64be4c1c24. This patch
> >>introduced #ifdef to guard !SMP case.
> >>
> >>Signed-off-by: Kamalesh Babulal<kamalesh@linux.vnet.ibm.com>
> >>----
> >
> >
> >There was a similar build-fix patch by Steffen Persvold at:
> >https://lkml.org/lkml/2011/12/6/28
> >
> >That would solve your case too, right?
> >

Thanks for pointing out the patch.

> 
> I would hope so (I tested with !CONFIG_SMP also), albeit I used :
> 
> #ifdef CONFIG_NUMA
> 
> and not
> 
> #ifdef CONFIG_SMP
> 
> 
> but I don't think you can compile with CONFIG_NUMA without having
> CONFIG_SMP  (if I read the Kconfig correctly..).
> 
> I used CONFIG_NUMA because the code-path doesn't really make sense
> on non-numa nodes.

agree, cpuinfo_x86->phys_proc_id is protected within CONFIG_SMP but the
right way is to fix using CONFIG_NUMA as explained by you in 
https://lkml.org/lkml/2011/12/6/28.

Regards,
Kamalesh.

