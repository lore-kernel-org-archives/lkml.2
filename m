Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1JQUZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:25:23 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34473 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab1JQUZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:25:07 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Increment alloc and sleep_alloc only when page allocation succeeds.
Date: Mon, 17 Oct 2011 13:25:05 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org
References: <1318877852.10091.11.camel@localhost.localdomain> <201110171245.31256.dtor@vmware.com> <CADZ9YHinpV=7LMRVbwVH4NS_q5b_VhhedbJ5gE7KnKFkg1F1xw@mail.gmail.com>
In-Reply-To: <CADZ9YHinpV=7LMRVbwVH4NS_q5b_VhhedbJ5gE7KnKFkg1F1xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171325.06256.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011 01:17:02 PM Rakib Mullick wrote:
> On Tue, Oct 18, 2011 at 1:45 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> > On Monday, October 17, 2011 12:35:34 PM David Rientjes wrote:
> >> On Tue, 18 Oct 2011, Rakib Mullick wrote:
> >> >  While doing allocation statistics in vmballoon_reserve_page
> >> > function,
> >> > 
> >> > alloc and sleep_alloc has been incremented even if allocation
> >> > fails. But,
> >> > b->stats.alloc and b->stats.sleep_alloc supposed to increment only
> >> > when they succeed. This patch makes sure that, alloc and
> >> > sleep_alloc gets incremented when page allocation succeeds.
> >> 
> >> Dmitry could say for sure, but this seems to actually change the
> >> semantics.  If the allocations fail, it increments alloc_fail and
> >> sleep_alloc_fail accordingly so you could easily see 10 alloc and 5
> >> alloc_fail.  With your patch, it would be 5 alloc and 5 alloc_fail.
> >> 
> >> I don't know which one is best, but I would opt to stay with the
> >> semantics that alloc and sleep_alloc have already had rather than
> >> changing them.
> > 
> > Right, b->stats.alloc and b->stats.sleep_alloc show number of
> > allocation attempts and alloc_fail and sleep_alloc_fail show how many
> > of these attempts failed. This behavior matches behavior of the
> > driver we have been shipping out of the tree for many years and I
> > would prefer to keep it as is.
> 
> Then why b->stats.alloc and b->stats.sleep_alloc are not renamed as
> b->stats.alloc_attempted and b->stats.sleep_alloc_attempted
> respectively. Current naming is confusing, anyone looking at the alloc
> and sleep_alloc stat would easily think that, if 10 alloc and 5
> alloc_fail then 10 has been allocated and 5 times has been allocation
> fails. Isn't it?

I'd give you this point if they were named alloc_succeeded and
sleep_alloc_succeeded... but they are not.

Thanks,
Dmitry
