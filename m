Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1L0Rw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:52:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61161 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1L0Rwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:52:54 -0500
Date: Tue, 27 Dec 2011 09:52:49 -0800
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        oleg@redhat.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111227175249.GE17712@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111223014043.GC12738@redhat.com>
 <20111222175834.66559c8b.akpm@linux-foundation.org>
 <20111223025629.GE12738@redhat.com>
 <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KAMEZAWA.

On Mon, Dec 26, 2011 at 03:05:31PM +0900, KAMEZAWA Hiroyuki wrote:
> From 433b56fd5644d4b1e695bc16bbf8dd78842999fd Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Mon, 26 Dec 2011 15:06:21 +0900
> Subject: [PATCH] percpu_counter: add lazy init
> 
> percpu_counter calls alloc_percpu(). This means percpu_counter_init()
> assumes GFP_KERNEL context. This may call vmalloc() in percpu_counter
> allocation and will have locks.
> 
> If a caller doesn't want to assume GFP_KERNEL, we need some tricks.
> This patch adds percpu_counter_init_lazy().
> 
> At lazy allocation, the function leaves fbc->counters as NULL and
> init fbc->counters by workqueue. This work item handling is done
> by fbc->list, so, the struct size of 'fbc' will not increase if
> a user configs CONFIG_HOTPLUG_CPU.

This is essentially more specialized form of the mempool approach.  It
doesn't seem any simpler to me while being less generic.  I don't see
what the upside would be.

Thanks.

-- 
tejun
