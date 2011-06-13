Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1FMSeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:34:13 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55731 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1FMSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:34:10 -0400
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <alpine.DEB.2.00.1106131258300.3108@router.home>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
	 <alpine.DEB.2.00.1106131258300.3108@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 13 Jun 2011 21:34:08 +0300
Message-ID: <1307990048.11288.3.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:59 -0500, Christoph Lameter wrote:
> On Sun, 12 Jun 2011, Hugh Dickins wrote:
> 
> > 3.0-rc won't boot with SLUB on my PowerPC G5: kernel BUG at mm/slub.c:1950!
> > Bisected to 1759415e630e "slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery".
> >
> > After giving myself a medal for finding the BUG on line 1950 of mm/slub.c
> > (it's actually the
> > 	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));
> > on line 268 of the morass that is include/linux/percpu.h)
> > I tried the following alignment patch and found it to work.
> 
> Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
> alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
> was not applied? Pekka?

This patch?

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d4d84fef6d0366b585b7de13527a0faeca84d9ce

It's queued and will be sent to Linus soon.

			Pekka


