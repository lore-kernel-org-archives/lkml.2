Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2GEORJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:17:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62720 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299Ab2GEORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:17:08 -0400
Date: Thu, 5 Jul 2012 15:17:00 +0100
From: Will Deacon <will.deacon@arm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120705141700.GI3399@mudshark.cambridge.arm.com>
References: <1341412376-6272-1-git-send-email-will.deacon@arm.com>
 <CAJd=RBAmF3dtb8wtEbS-A7BNT=RLsb5emQQWVU8ioeQOO8D7NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAmF3dtb8wtEbS-A7BNT=RLsb5emQQWVU8ioeQOO8D7NA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 01:37:46PM +0100, Hillf Danton wrote:
> On Wed, Jul 4, 2012 at 10:32 PM, Will Deacon <will.deacon@arm.com> wrote:
> > When allocating and returning clear huge pages to userspace as a
> > response to a fault, we may zero and return a mapping to a previously
> > dirtied physical region (for example, it may have been written by
> > a private mapping which was freed as a result of an ftruncate on the
> > backing file). On architectures with Harvard caches, this can lead to
> > I/D inconsistency since the zeroed view may not be visible to the
> > instruction stream.
> >
> > This patch solves the problem by flushing the region after allocating
> > and clearing a new huge page. Note that PowerPC avoids this issue by
> > performing the flushing in their clear_user_page implementation to keep
> > the loader happy, however this is closely tied to the semantics of the
> > PG_arch_1 page flag which is architecture-specific.
> >
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> 
> Thanks:)
> 
> Acked-by: Hillf Danton <dhillf@gmail.com>

Thanks Hillf. Which tree does this stuff usually go through?

Will
