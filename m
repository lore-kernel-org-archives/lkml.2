Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2I1QkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:40:05 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:15704 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758601Ab2I1QkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:40:03 -0400
Date: Fri, 28 Sep 2012 16:40:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] make GFP_NOTRACK flag unconditional
In-Reply-To: <5065B42F.5010007@parallels.com>
Message-ID: <0000013a0dbfc498-6debffd5-cd68-404c-92a4-4f88d40cf41b-000000@email.amazonses.com>
References: <1348826194-21781-1-git-send-email-glommer@parallels.com> <0000013a0d475174-343e3b17-6755-42c1-9dae-a9287ad7d403-000000@email.amazonses.com> <5065B42F.5010007@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Glauber Costa wrote:

> On 09/28/2012 06:28 PM, Christoph Lameter wrote:
> > On Fri, 28 Sep 2012, Glauber Costa wrote:
> >
> >> There was a general sentiment in a recent discussion (See
> >> https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
> >> defined unconditionally. Currently, the only offender is GFP_NOTRACK,
> >> which is conditional to KMEMCHECK.
> >>
> >> This simple patch makes it unconditional.
> >
> > __GFP_NOTRACK is only used in context where CONFIG_KMEMCHECK is defined?
> >
> > If that is not the case then you need to define GFP_NOTRACK and substitute
> > it where necessary.
> >
>
> The flag is passed around extensively, but I was imagining the whole
> point of that is that having the flag itself is harmless, and will be
> ignored by the page allocator ?

Looking through it shows almost nothing that is affected.

One thing though is that defining __GFP_NOTRACK to 0 eliminates an "or"
operation in alloc_slab_page().

That is already on the slob path so I guess that is minimal

Acked-by: Christoph Lameter <cl@linux.com>

