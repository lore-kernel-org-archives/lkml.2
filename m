Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3AIImu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:42:50 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:42605 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab3AIIms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:42:48 -0500
Date: Wed, 9 Jan 2013 08:42:47 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <erdnetdev@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130109084247.GA6545@dcvr.yhbt.net>
References: <20130104160148.GB3885@suse.de>
 <20130106120700.GA24671@dcvr.yhbt.net>
 <20130107122516.GC3885@suse.de>
 <20130107223850.GA21311@dcvr.yhbt.net>
 <20130108224313.GA13304@suse.de>
 <20130108232325.GA5948@dcvr.yhbt.net>
 <1357697647.18156.1217.camel@edumazet-glaptop>
 <1357698749.27446.6.camel@edumazet-glaptop>
 <1357700082.27446.11.camel@edumazet-glaptop>
 <20130109035511.GA6857@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109035511.GA6857@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Eric Dumazet <erdnetdev@gmail.com> wrote:
> > On Tue, 2013-01-08 at 18:32 -0800, Eric Dumazet wrote:
> > > Hmm, it seems sk_filter() can return -ENOMEM because skb has the
> > > pfmemalloc() set.
> > 
> > > 
> > > One TCP socket keeps retransmitting an SKB via loopback, and TCP stack 
> > > drops the packet again and again.
> > 
> > sock_init_data() sets sk->sk_allocation to GFP_KERNEL
> > 
> > Shouldnt it use (GFP_KERNEL | __GFP_NOMEMALLOC) instead ?
> 
> Thanks, things are running good after ~35 minutes so far.
> Will report back if things break (hopefully I don't run out
> of laptop battery power :x).

Oops, I had to restart my test :x.  However, I was able to reproduce the
issue very quickly again with your patch.  I've double-checked I'm
booting into the correct kernel, but I do have more load on this
laptop host now, so maybe that made it happen more quickly...
