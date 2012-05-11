Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2EKFDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:03:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57210 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2EKFDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:03:51 -0400
Date: Fri, 11 May 2012 01:03:39 -0400 (EDT)
Message-Id: <20120511.010339.375923873885534514.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 13/17] netvm: Set PF_MEMALLOC as appropriate during SKB
 processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-14-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<1336657510-24378-14-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 22:03:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 10 May 2012 14:45:06 +0100

> In order to make sure pfmemalloc packets receive all memory
> needed to proceed, ensure processing of pfmemalloc SKBs happens
> under PF_MEMALLOC. This is limited to a subset of protocols that
> are expected to be used for writing to swap. Taps are not allowed to
> use PF_MEMALLOC as these are expected to communicate with userspace
> processes which could be paged out.
> 
> [a.p.zijlstra@chello.nl: Ideas taken from various patches]
> [jslaby@suse.cz: Lock imbalance fix]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

This adds more code where we're modifying task->flags from software
interrupt context.  I'm not convinced that's safe.

Also, this starts to add new tests in the fast paths.

Most of the time they are not going to trigger at all.

Please use the static branch I asked you to add in a previous
patch to mitigate this.
