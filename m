Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1JRTOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:14:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60051 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1JRTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:14:48 -0400
Date: Tue, 18 Oct 2011 15:12:28 -0400 (EDT)
Message-Id: <20111018.151228.2056792649526003804.davem@davemloft.net>
To: krkumar2@in.ibm.com
Cc: rusty@rustcorp.com.au, mst@redhat.com, Ian.Campbell@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Fix guest memory leak and panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>
References: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 18 Oct 2011 12:12:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>
Date: Tue, 18 Oct 2011 13:35:23 +0530

> Commit 86ee8130 ("virtionet: convert to SKB paged frag API")
> introduced a bug in guest. During RX testing, guest runs out
> of memory within seconds, causing oom-killer; which then
> panics the system: "Kernel panic - not syncing: Out of memory
> and no killable processes...". /proc/meminfo just before the
> panic shows MemFree is a few MB's:
> 
> 	MemFree:         1928544 kB	(starts here)
> 	...
> 	...
> 	MemFree:           27488 kB
> 	MemFree:           26248 kB
> 	MemFree:           24636 kB
> 	MemFree:           22632 kB
> 	MemFree:           19580 kB
> 	MemFree:           17928 kB
> 	MemFree:           15548 kB
> 		(Panic)
> 
> The extra reference to the fragment pages causes those pages to
> not get freed in skb_release_data(). The following patch fixes
> the bug. I have not checked if any other converted driver has
> the same issue.
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>

I'll wait for Ian's full audit, but Krishna please use more appropriate
subject lines in future patch submissions.

This patch is fixing a problem in the virtio_net driver, so please
mention that: "Subject: [PATCH] virtio_net: Fix guest memory leak and panic"
