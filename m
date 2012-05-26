Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2EZSrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 14:47:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61486 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2EZSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 14:47:21 -0400
Date: Sat, 26 May 2012 11:46:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Alex Shi <alex.shi@intel.com>
cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        cl@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        mgorman@suse.de, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@vger.kernel.org
Subject: Re: unnecessary tlb flush in mprotect
In-Reply-To: <4FBC2A23.9080605@intel.com>
Message-ID: <alpine.LSU.2.00.1205261140570.2173@eggly.anvils>
References: <4FB9FD1D.6000001@intel.com> <4FBAE71F.5000801@intel.com> <20120522163735.GB1906@tassilo.jf.intel.com> <4FBC2A23.9080605@intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Alex Shi wrote:
> On 05/23/2012 12:37 AM, Andi Kleen wrote:
> > On Tue, May 22, 2012 at 09:08:47AM +0800, Alex Shi wrote:
> >> On 05/21/2012 04:30 PM, Alex Shi wrote:
> >>
> >>> when mprotect just change prots of non-present pages, current mprotect
> >>> still do the tlb flush in check_protection().
> >>> but according to 4.10.2.3 Intel SDM V3A (
> >>> www.intel.com/Assets/ja_JP/PDF/manual/253668.pdf ) at that time, TLB has
> >>> no this lines for this page. So, tlb flush is just waste time. (for cr3
> >>> rewrite, flush all tlb, or invlpg, like a 'nop' in intel cpu)

Yes.

> >>>
> >>> Do we need to add the pte_present similar check here to prevent the
> >>> unnecessary tlb flushing? I mean, are there real case in word, User like
> >>> to change page prots before assign a physical page to it?

We have always simply assumed that mprotecting an entirely empty range
is too uncommon to bother with the slight complication of optimizing it.
Our assumption might be very wrong.

Hugh

> >>>
> >>
> >>
> >> Any comments from linux-mm emailing list?
> > 
> > I would be careful with TLB optimizations if it's not a clear performance
> > wins. A lot of these interactions are tricky and it's very easy to break
> > things in subtle and hard to debug ways.
> > 
> > -Andi
> 
> 
> Sure, functionality is fundamental.
