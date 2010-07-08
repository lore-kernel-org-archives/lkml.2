Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0GHLbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:31:24 -0400
Received: from shutemov.name ([188.40.19.243]:37551 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab0GHLbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:31:23 -0400
Date: Thu, 8 Jul 2010 14:31:22 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Anfei Zhou <anfei.zhou@gmail.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
 pre-ARMv6
Message-ID: <20100708113122.GA23854@shutemov.name>
References: <20100701221420.GA10481@shutemov.name>
 <20100701221728.GA12187@suse.de>
 <20100701222541.GB10481@shutemov.name>
 <20100701224837.GA27389@flint.arm.linux.org.uk>
 <20100701225911.GC10481@shutemov.name>
 <20100701231207.GB27389@flint.arm.linux.org.uk>
 <20100706130618.GA14177@shutemov.name>
 <20100706225815.GA21834@flint.arm.linux.org.uk>
 <20100707085601.GA18732@shutemov.name>
 <20100707223417.GA22673@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707223417.GA22673@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:34:18PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 07, 2010 at 11:56:01AM +0300, Kirill A. Shutemov wrote:
> > But it seems that the problem is more global. Potentially, any of
> > pmd_none() check may produce false results. I don't see an easy way to fix
> > it.
> 
> It isn't.  We normally guarantee that we always fill on both L1 entries.
> The only exception is for the mappings specified via create_mapping()
> which is used for the static platform mappings.
 
Why do not to change create_mapping() to follow the same rules?
I mean, create sections only if it asked for 2*SECTION_SIZE with
appropriate alignment. It reduces number of section mappings, but,
probably, will be a bit cleaner and less error-prune.

> > Does Linux VM still expect one PTE table per page?
> 
> Yes, and as far as I can see probably always will.  Hence why we need
> to put two L1 entries in one page and lie to the kernel about the sizes
> of the hardware entries.

Another option is leave half of page with PTE table free. Is it very bad
idea?

How other architectures handle it? Or only on ARM PTL table size is less
than page size?

-- 
 Kirill A. Shutemov
