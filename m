Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0FTHPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:15:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:60366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0FTHPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,447,1272870000"; 
   d="scan'208";a="528478809"
Date: Sun, 20 Jun 2010 15:14:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft
 page 	offlining
Message-ID: <20100620071446.GA21743@localhost>
References: <20091208211647.9B032B151F@basil.firstfloor.org>
 <AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com>
 <20100619132055.GK18946@basil.fritz.box>
 <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com>
 <20100619133000.GL18946@basil.fritz.box>
 <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com>
 <20100619140933.GM18946@basil.fritz.box>
 <AANLkTilF6m5YKMiDGaTNuoW6LxiA44oss3HyvkavwrOK@mail.gmail.com>
 <20100619195242.GS18946@basil.fritz.box>
 <AANLkTikMZu0GXwzs6IeMyoTuhETrnjZ1m5lI9FTauYBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikMZu0GXwzs6IeMyoTuhETrnjZ1m5lI9FTauYBA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 02:19:35PM +0800, Michael Kerrisk wrote:
> Hi Andi,
> On Sat, Jun 19, 2010 at 9:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> .TP
> >> .BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
> >> Soft offline the pages in the range specified by
> >> .I addr
> >> and
> >> .IR length .
> >> This memory of each page in the specified range is copied to a new page,
> >
> > Actually there are some cases where it's also dropped if it's cached page.
> >
> > Perhaps better would be something more fuzzy like
> >
> > "the contents are preserved"
> 
> The problem to me is that this gets so fuzzy that it's hard to
> understand the meaning (I imagine many readers will ask: "What does it
> mean that the contents are preserved"?). Would you be able to come up
> with a wording that is a little miore detailed?

That is, MADV_SOFT_OFFLINE won't lose data.

If a process writes "1" to some virtual address and then called
madvice(MADV_SOFT_OFFLINE) on that virtual address, it can continue
to read "1" from that virtual address.

MADV_SOFT_OFFLINE "transparently" replaces the underlying physical page
frame with a new one that contains the same data "1". The original page
frame is offlined, and the new page frame may be installed lazily.

Thanks,
Fengguang
