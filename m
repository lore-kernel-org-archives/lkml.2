Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab1CaVkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:40:40 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:49976 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab1CaVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:40:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMFAIzylE15LK5JTmdsb2JhbAClVQsBASADIyXANg2FXgQ
Date: Fri, 1 Apr 2011 08:40:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Message-ID: <20110331214033.GA2904@dastard>
References: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:00:26AM +0530, Balbir Singh wrote:
> 
> The following series implements page cache control,
> this is a split out version of patch 1 of version 3 of the
> page cache optimization patches posted earlier at
> Previous posting http://lwn.net/Articles/425851/ and analysis
> at http://lwn.net/Articles/419713/
> 
> Detailed Description
> ====================
> This patch implements unmapped page cache control via preferred
> page cache reclaim. The current patch hooks into kswapd and reclaims
> page cache if the user has requested for unmapped page control.
> This is useful in the following scenario
> - In a virtualized environment with cache=writethrough, we see
>   double caching - (one in the host and one in the guest). As
>   we try to scale guests, cache usage across the system grows.
>   The goal of this patch is to reclaim page cache when Linux is running
>   as a guest and get the host to hold the page cache and manage it.
>   There might be temporary duplication, but in the long run, memory
>   in the guests would be used for mapped pages.

What does this do that "cache=none" for the VMs and using the page
cache inside the guest doesn't acheive? That avoids double caching
and doesn't require any new complexity inside the host OS to
acheive...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
