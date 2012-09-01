Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2IAIhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 04:37:09 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:38857 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2IAIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 04:37:07 -0400
Date: Sat, 1 Sep 2012 10:20:18 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hugh Dickins <hughd@google.com>
Cc: David Madore <david+ml@madore.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109 __alloc_pages_nodemask+0x1d4/0x68c()
Message-ID: <20120901082018.GA16762@electric-eye.fr.zoreil.com>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net> <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hughd@google.com> :
> [ Cc'ing original mail to netdev as the problem may be recognized there ]
[...]
> Francois is right that a GFP_ATOMIC allocation from pskb_expand_head()
> is failing, which can easily happen, and cause your "failed to reallocate
> TX buffer" errors; but it's well worth looking up what's actually on
> lines 2108 and 2109 of mm/page_alloc.c in 3.2.27:
> 
> 	if (order >= MAX_ORDER) {
> 		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));

You are right. The wifi Tx path error is not related.

I overlooked it was using SLUB btw.

> That was probably not a sane allocation request, it has gone out of range:
> maybe the skb header is even corrupted.  If you're lucky, it might be
> something that netdev will recognize as already fixed.

Afaics nothing related to mv643xx_eth.c, nor pskb_expand_head nor
ip6_forward, at least nothing trivially close. Eric may provide a
better answer.

-- 
Ueimor
