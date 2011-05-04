Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1EDS7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:59:22 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:53094 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1EDS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:59:21 -0400
Date: Wed, 4 May 2011 20:59:03 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, yinghai@kernel.org, hpa@zytor.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page table high"
Message-ID: <20110504185903.GA29903@router-fw-old.local.net-space.pl>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com> <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com> <20110503005527.GA6735@router-fw-old.local.net-space.pl> <20110503151206.GA8868@dumpdata.com> <20110503195141.GA15775@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503195141.GA15775@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:51:41PM +0200, Daniel Kiper wrote:
> On Tue, May 03, 2011 at 11:12:06AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, May 03, 2011 at 02:55:27AM +0200, Daniel Kiper wrote:
> > > On Mon, May 02, 2011 at 01:22:21PM -0400, Konrad Rzeszutek Wilk wrote:

[...]

> > > I think that (Stefano please confirm or not) this patch was prepared
> > > as workaround for similar issues. However, I do not like this patch
> > > because on systems with small amount of memory it leaves huge (to some
> > > extent) hole between max_low_pfn and 4G. Additionally, it affects
> > > memory hotplug a bit because it allocates memory starting from current
> > > max_mfn. It also breaks memory hotplug on i386 (maybe also others
> > > thinks, however, I could not confirm that). If it stay for some
> > > reason it should be amended in follwing way:
> > >
> > > #ifdef CONFIG_X86_32
> > >         xen_extra_mem_start = mem_end;
> > > #else
> > >         xen_extra_mem_start = max((1ULL << 32), mem_end);
> > > #endif
> > >
> > > Regarding comment for this patch it should be mentioned that without this
> > > patch e820_end_of_low_ram_pfn() is not broken. It is not called simply.
> > >
> > > Last but least. I found that memory sizes below and including exactly 1 GiB and
> > > exactly 2 GiB, 3 GiB (maybe higher, i.e. 4 GiB, 5 GiB, ...; I was not able to test
> > > them because I do not have sufficient memory) are magic. It means that if memory
> > > is set with those sizes everything is working good (without 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> > > and 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 applied). It means that domU
> > > should be tested with sizes which are not power of two nor multiple of that.
> >
> > Hmm, I thought I did test 1500M.
>
> It does not work on my machine (24bdb0b62cc82120924762ae6bc85afc8c3f2b26
> removed and 4b239f458c229de044d6905c2b0f9fe16ed9e01e applied).

It does not work on my machine (x86_64) with Linux Kernel Ver. 2.6.39-rc6 without
git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
e820 region at an addr lower than 4G). As I said ealier bug introduced by git
commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table
high) is probably hidden (repaird/workarounded ???) by git commit
24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
e820 region at an addr lower than 4G).

Konrad, Stefano could you confirm that ??? If it is true
how could I help you in removing this bug ???

Daniel
