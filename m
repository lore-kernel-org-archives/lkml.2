Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1L1APT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 19:15:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39614 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1L1APQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 19:15:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Dec 2011 09:14:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        oleg@redhat.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111228091402.c45a08f6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111227175249.GE17712@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111223014043.GC12738@redhat.com>
	<20111222175834.66559c8b.akpm@linux-foundation.org>
	<20111223025629.GE12738@redhat.com>
	<20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20111227175249.GE17712@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 09:52:49 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, KAMEZAWA.
> 
> On Mon, Dec 26, 2011 at 03:05:31PM +0900, KAMEZAWA Hiroyuki wrote:
> > From 433b56fd5644d4b1e695bc16bbf8dd78842999fd Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Mon, 26 Dec 2011 15:06:21 +0900
> > Subject: [PATCH] percpu_counter: add lazy init
> > 
> > percpu_counter calls alloc_percpu(). This means percpu_counter_init()
> > assumes GFP_KERNEL context. This may call vmalloc() in percpu_counter
> > allocation and will have locks.
> > 
> > If a caller doesn't want to assume GFP_KERNEL, we need some tricks.
> > This patch adds percpu_counter_init_lazy().
> > 
> > At lazy allocation, the function leaves fbc->counters as NULL and
> > init fbc->counters by workqueue. This work item handling is done
> > by fbc->list, so, the struct size of 'fbc' will not increase if
> > a user configs CONFIG_HOTPLUG_CPU.
> 
> This is essentially more specialized form of the mempool approach.  It
> doesn't seem any simpler to me while being less generic.  I don't see
> what the upside would be.
> 

Hm, but this never causes -ENOMEM error, at all.

Thanks,
-Kame

