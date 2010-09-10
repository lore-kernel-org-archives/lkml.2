Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0IJKCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:02:54 -0400
Received: from lo.gmane.org ([80.91.229.12]:32946 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0IJKCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:02:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: block cache replacement strategy?
Date: Fri, 10 Sep 2010 12:02:35 +0200
Message-ID: <20100910120235.455962c4@schatten.dmk.lab>
References: <20100907133429.GB3430@sig21.net>
	<20100909120044.GA27765@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: f053214237.adsl.alicedsl.de
In-Reply-To: <20100909120044.GA27765@sig21.net>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 14:00:44 +0200
Johannes Stezenbach <js@sig21.net> wrote:

> On Tue, Sep 07, 2010 at 03:34:29PM +0200, Johannes Stezenbach wrote:
> > 
> > during some simple disk read throughput testing I observed
> > caching behaviour that doesn't seem right.  The machine
> > has 2G of RAM and AMD Athlon 4850e, x86_64 kernel but 32bit
> > userspace, Linux 2.6.35.4.  It seems that contents of the
> > block cache are not evicted to make room for other blocks.
> > (Or something like that, I have no real clue about this.)
> > 
> > Since this is a rather artificial test I'm not too worried,
> > but it looks strange to me so I thought I better report it.
> 
> C'mon guys, please comment.  Is this a bug or not?
> Or is my question too silly?
> 
> 
> Johannes

Well I personally have  no clue about the block caching, but perhaps
that is an heuristic to prevent the cache from fluctuating too much?
Some minimum time a block is hold... in a big linear read the cache is
useless anyway most of the time, so it could make some sense...

You could try accessing random files after filling up the cache and
check if those evict the the cache.  That should rule out any
linear-read-detection heuristic. 

Cheers,
Flo

