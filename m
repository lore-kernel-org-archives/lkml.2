Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1CFVuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 16:50:23 -0500
Received: from sh.osrg.net ([192.16.179.4]:51034 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab1CFVuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 16:50:20 -0500
Date: Mon, 7 Mar 2011 06:49:38 +0900
To: maximlevitsky@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
        oakad@yahoo.com
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1299424470.22378.9.camel@maxim-laptop>
References: <1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
	<20110306162859E.fujita.tomonori@lab.ntt.co.jp>
	<1299424470.22378.9.camel@maxim-laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110307064900X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 07 Mar 2011 06:49:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Mar 2011 17:14:30 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Sun, 2011-03-06 at 16:29 +0900, FUJITA Tomonori wrote:
> > On Fri,  4 Mar 2011 06:16:50 +0200
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > While developing memstick driver for legacy memsticks
> > > I found the need in few helpers that I think should be
> > > in common scatterlist library
> > > 
> > > The functions that were added:
> > > 
> > > * sg_nents/sg_total_len - iterate over scatterlist to figure
> > > out total length of memory it covers / number of entries.
> > 
> > You should invent a data structure per I/O request, something like
> > msb_request structure. Then you can store nents and total_len in
> > that.
> > 
> > That's what block subsystems and drivers do. I took a look at your
> > driver but I can't see why your driver can't do the same.
> I also need to break the request into small grained chunks.
> If I invent such structure, I will end up writing these helpers for it.
> 
> The I have this lifetime of a request:
> 
> I get arbitary sized request from block layer (I can of course control
> maximum size/number of segments in it, etc).
> 
> I break it into eraseblock sized chunks, and for each I translate the
> the LBA, into flash address.
> 
> Then I break it into flash page sized requests (512 bytes), and yet its
> better not to assume that such requests always contained in one sg
> entry.
> 
> Worse than that, I have to pass an sg list that spans always one 512
> page to lowlevel driver, because thats how Alex defined the interface.

This restriction is due to hardware specification or the software
design (e.g. memstick layer)? If it is due to the latter, why can't
you fix that?

Why can't the block layer split requests for you? It's better to let
the block layer handle that.


> Folks, really what the status of this, when to expect it to be merged?
> 
> If you think some of helper functions don't belong to scatterlist.c,
> just tell me to move them back to ms_block.c.
> 
> Andrew, please note again that richoh lowlevel driver doesn't need any
> helper functions, its patch is standalone and thus should be merged
> regardless.

I think that we need to make the design of the driver easily
understandable to kernel developers and maintainable by them. I don't
think that this is 'standalone or not' issue.

Adding a doc about why the driver is designed in such odd way would be
helpful. But I still think that we could design the driver in a better
way.
