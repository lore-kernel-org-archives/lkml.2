Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1EPHrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:47:14 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:38649 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1EPHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:47:13 -0400
Date: Mon, 16 May 2011 09:46:54 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, stefano.stabellini@eu.citrix.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] arch/x86/xen/setup: Fix for incorrect xen_extra_mem_start initialization ifdef CONFIG_X86_32
Message-ID: <20110516074654.GA6393@router-fw-old.local.net-space.pl>
References: <20110511203438.GA21034@router-fw-old.local.net-space.pl> <20110512185808.GA26281@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512185808.GA26281@dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:58:08PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 11, 2011 at 10:34:38PM +0200, Daniel Kiper wrote:
> > git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create
> > the extra e820 region at an addr lower than 4G) does not take into
> > account that ifdef CONFIG_X86_32 instead of e820_end_of_low_ram_pfn()
> > find_low_pfn_range() is called (both calls are from arch/x86/kernel/setup.c).
> > find_low_pfn_range() behaves correctly and does not require change in
> > xen_extra_mem_start initialization. Additionally, if xen_extra_mem_start
> > is initialized in the same way as ifdef CONFIG_X86_64 then memory hotplug
> > support for Xen balloon driver (under development) is broken.
>
> in linux-next.

Thanks. Additionally, I would like to mention that git commit 279b706bf800b5967037f492dbe4fc5081ad5d0f
(x86,xen: introduce x86_init.mapping.pagetable_reserve) which fixes bug introduced by
git commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table
high) works on my machine.

Daniel
