Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab0DNMel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:34:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0DNMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:34:40 -0400
Date: Wed, 14 Apr 2010 14:34:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100414123439.GS18855@one.firstfloor.org>
References: <1271117878-19274-1-git-send-email-david@fromorbit.com> <20100413095815.GU25756@csn.ul.ie> <20100413111902.GY2493@dastard> <20100413193428.GI25756@csn.ul.ie> <20100413202021.GZ13327@think> <877hoa9wlv.fsf@basil.nowhere.org> <20100414112015.GO13327@think> <8739yy9qnf.fsf@basil.nowhere.org> <20100414133229.134264f0@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414133229.134264f0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 01:32:29PM +0100, Alan Cox wrote:
> > The only part of the 4K stack code that's good is the separate
> > interrupt stack, but that one should be just combined with a sane 8K 
> > process stack.
> 
> The reality is that if you are blowing a 4K process stack you are
> probably playing russian roulette on the current 8K x86-32 stack as well
> because of the non IRQ split. So it needs fixing either way

Yes I think the 8K stack on 32bit should be combined with a interrupt 
stack too. There's no reason not to have an interrupt stack ever. 

Again the problem with fixing it is that you won't have any safety net
for a slightly different stacking etc. path that you didn't cover.

That said extreme examples (like some of those Chris listed) definitely
need fixing by moving them to different threads. But even after that
you still want a safety net. 4K is just too near the edge.

Maybe it would work if we never used any indirect calls, but that's
clearly not the case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
