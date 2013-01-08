Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750804Ab3AHFBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:01:13 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60824 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3AHFBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:01:12 -0500
Date: Tue, 8 Jan 2013 12:55:19 +0800
From: Shaohua Li <shli@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, hughd@google.com
Subject: Re: [RFC]x86: clearing access bit don't flush tlb
Message-ID: <20130108045519.GB2459@kernel.org>
References: <20130107081213.GA21779@kernel.org>
 <50EAE66B.1020804@redhat.com>
 <50EB4CB9.9010104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EB4CB9.9010104@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 02:31:21PM -0800, H. Peter Anvin wrote:
> On 01/07/2013 07:14 AM, Rik van Riel wrote:
> > On 01/07/2013 03:12 AM, Shaohua Li wrote:
> >>
> >> We use access bit to age a page at page reclaim. When clearing pte
> >> access bit,
> >> we could skip tlb flush for the virtual address. The side effect is if
> >> the pte
> >> is in tlb and pte access bit is unset, when cpu access the page again,
> >> cpu will
> >> not set pte's access bit. So next time page reclaim can reclaim hot pages
> >> wrongly, but this doesn't corrupt anything. And according to intel
> >> manual, tlb
> >> has less than 1k entries, which coverers < 4M memory. In today's system,
> >> several giga byte memory is normal. After page reclaim clears pte
> >> access bit
> >> and before cpu access the page again, it's quite unlikely this page's
> >> pte is
> >> still in TLB. Skiping the tlb flush for this case sounds ok to me.
> > 
> > Agreed. In current systems, it can take a minute to write
> > all of memory to disk, while context switch (natural TLB
> > flush) times are in the dozens-of-millisecond timeframes.
> > 
> 
> I'm confused.  We used to do this since time immemorial, so if we aren't
> doing that now, that meant something changed somewhere along the line.
> It would be good to figure out if that was an intentional change or
> accidental.

I searched a little bit, the change (doing TLB flush to clear access bit) is
made between 2.6.7 - 2.6.8, I can't find the changelog, but I found a patch:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.7-rc2/2.6.7-rc2-mm2/broken-out/mm-flush-tlb-when-clearing-young.patch

The changelog declaims this is for arm/ppc/ppc64.

Thanks,
Shaohua

