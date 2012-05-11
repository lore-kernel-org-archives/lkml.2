Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2EKEvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:51:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57111 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2EKEuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:50:46 -0400
Date: Fri, 11 May 2012 00:50:34 -0400 (EDT)
Message-Id: <20120511.005034.837005484911910521.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 09/17] netvm: Allow the use of __GFP_MEMALLOC by
 specific sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-10-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<1336657510-24378-10-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 21:50:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 10 May 2012 14:45:02 +0100

> Allow specific sockets to be tagged SOCK_MEMALLOC and use
> __GFP_MEMALLOC for their allocations. These sockets will be able to go
> below watermarks and allocate from the emergency reserve. Such sockets
> are to be used to service the VM (iow. to swap over). They must be
> handled kernel side, exposing such a socket to user-space is a bug.
> 
> There is a risk that the reserves be depleted so for now, the
> administrator is responsible for increasing min_free_kbytes as
> necessary to prevent deadlock for their workloads.
> 
> [a.p.zijlstra@chello.nl: Original patches]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

After sk_allocation() is adjusted to be sk_gfp_atomic() as I suggested
in my feedback for patch #8, this is fine.
