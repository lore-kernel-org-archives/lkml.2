Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2HUPXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:23:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:41476 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HUPXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:23:01 -0400
Date: Tue, 21 Aug 2012 17:22:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Attilio Rao <attilio.rao@citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done PVOPS and document the semantic
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
Message-ID: <alpine.LFD.2.02.1208211721250.2856@ionos>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Attilio Rao wrote:

> Currently the definition of x86_init.paging.pagetable_setup_start and
> x86_init.paging.pagetable_setup_done is twisted and not really well
> defined (in terms of prototypes desired). More specifically:
> pagetable_setup_start:
>  * it is a nop on x86_32
>  * it is a nop for the XEN case
>  * cleans up the boot time page table in the x86_64 case
> 
> pagetable_setup_done:
>  * it is a nop on x86_32
>  * sets up accessor functions for pagetable manipulation, for the
>    XEN case
>  * it is a nop on x86_64
> 
> Most of this logic can be skipped by creating a new PVOPS that can handle
> pagetable setup and pre/post operations on it.
> The new PVOPS must be called only once, during boot-time setup and
> after the direct mapping for physical memory is available.

Can you please refrain from naming that PVOPS? The setup function
pointers have nothing to do with PVOPS.

They are explicitely meant for platforms and XEN is just another
platform as is 32bit and 64bit.

Thanks,

	tglx
