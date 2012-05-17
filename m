Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967715Ab2EQULY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:11:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34601 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966328Ab2EQULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:11:21 -0400
Date: Thu, 17 May 2012 16:11:09 -0400 (EDT)
Message-Id: <20120517.161109.1822721470409742316.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 09/17] netvm: Allow the use of __GFP_MEMALLOC by
 specific sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337266231-8031-10-git-send-email-mgorman@suse.de>
References: <1337266231-8031-1-git-send-email-mgorman@suse.de>
	<1337266231-8031-10-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 13:11:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 17 May 2012 15:50:23 +0100

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

Acked-by: David S. Miller <davem@davemloft.net>
