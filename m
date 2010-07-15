Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab0GOBsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:48:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50844 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab0GOBsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:48:06 -0400
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device memory management
References: <4C3C0032.5020702@codeaurora.org>
	<20100713150311B.fujita.tomonori@lab.ntt.co.jp>
	<20100713121420.GB4263@codeaurora.org>
	<20100714104353B.fujita.tomonori@lab.ntt.co.jp>
	<20100714201149.GA14008@codeaurora.org>
	<20100714220536.GE18138@n2100.arm.linux.org.uk>
	<20100715012958.GB2239@codeaurora.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 14 Jul 2010 18:47:34 -0700
In-Reply-To: <20100715012958.GB2239@codeaurora.org> (Zach Pfeffer's message of "Wed\, 14 Jul 2010 18\:29\:58 -0700")
Message-ID: <m1mxttiki1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Pfeffer <zpfeffer@codeaurora.org> writes:

> On Wed, Jul 14, 2010 at 11:05:36PM +0100, Russell King - ARM Linux wrote:
>> On Wed, Jul 14, 2010 at 01:11:49PM -0700, Zach Pfeffer wrote:
>> > If the DMA-API contained functions to allocate virtual space separate
>> > from physical space and reworked how chained buffers functioned it
>> > would probably work - but then things start to look like the VCM API
>> > which does graph based map management.
>> 
>> Every additional virtual mapping of a physical buffer results in
>> additional cache aliases on aliasing caches, and more workload for
>> developers to sort out the cache aliasing issues.
>> 
>> What does VCM to do mitigate that?
>
> The VCM ensures that all mappings that map a given physical buffer:
> IOMMU mappings, CPU mappings and one-to-one device mappings all map
> that buffer using the same (or compatible) attributes. At this point
> the only attribute that users can pass is CACHED. In the absence of
> CACHED all accesses go straight through to the physical memory.
>
> The architecture of the VCM allows these sorts of consistency checks
> to be made since all mappers of a given physical resource are
> tracked. This is feasible because the physical resources we're
> tracking are typically large.

On x86 this is implemented in the pat code, and could reasonably be
generalized to be cross platform.

This is controlled by HAVE_PFNMAP_TRACKING and with entry points
like track_pfn_vma_new.

Given that we already have an implementation that tracks the cached
vs non-cached attribute using the dma api.  I don't see that the
API has to change.  An implementation of the cached vs non-cached
status for arm and other architectures is probably appropriate.

It is definitely true that getting your mapping caching attributes
out of sync can be a problem.

Eric

