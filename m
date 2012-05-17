Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967705Ab2EQUNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:13:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447Ab2EQUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:12:59 -0400
Date: Thu, 17 May 2012 16:12:45 -0400 (EDT)
Message-Id: <20120517.161245.2279668542058844372.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337266231-8031-11-git-send-email-mgorman@suse.de>
References: <1337266231-8031-1-git-send-email-mgorman@suse.de>
	<1337266231-8031-11-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 13:12:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 17 May 2012 15:50:24 +0100

> Change the skb allocation API to indicate RX usage and use this to fall
> back to the PFMEMALLOC reserve when needed. SKBs allocated from the
> reserve are tagged in skb->pfmemalloc. If an SKB is allocated from
> the reserve and the socket is later found to be unrelated to page
> reclaim, the packet is dropped so that the memory remains available
> for page reclaim. Network protocols are expected to recover from this
> packet loss.
> 
> [davem@davemloft.net: Use static branches, coding style corrections]
> [a.p.zijlstra@chello.nl: Ideas taken from various patches]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
