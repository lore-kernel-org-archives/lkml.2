Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0EJMff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:35:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41937 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab0EJMfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:35:34 -0400
Date: Mon, 10 May 2010 14:35:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Block: Check major number before allocate the buffer
	in   register_blkdev()
Message-ID: <20100510123532.GC27497@kernel.dk>
References: <20100510061602.GB2858@localhost.localdomain> <20100510115642.GB27497@kernel.dk> <AANLkTilVZpXlY294vzHS5gVf4f1M4fuz_vN17LOpoRxc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilVZpXlY294vzHS5gVf4f1M4fuz_vN17LOpoRxc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please don't top post when replying to emails, I fixed this one up for
you.

On Mon, May 10 2010, wzt wzt wrote:
> On Mon, May 10, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, May 10 2010, wzt.wzt@gmail.com wrote:
> >> Check major number before allocate the buffer, if the major number is not exist,
> >> and the register_blkdev() called many times, kmalloc()/kfree() will be no need
> >> to invoked many times. So check the major number before use kmalloc() to allocate
> >> the buffer will be better.
> >
> > This would generally be sound advice for performance oriented code, but
> > I can't see it making any difference here.
>
> the original code use kmalloc() to allocate struct blk_major_name
> buffer first,  then find the major number in major_names array. if
> found it,  it will kfree() the unused struct blk_major_name buffer,
> if register_blkdev() called many times like:
> register_blkdev(22, "aa");
> ....
> register_blkdev(22, "aa");
> kmalloc()/kfree() will be no need to invoked many times, my point is
> that find the major number first, then allocate the buffer will be
> better. this patch can handle the special case.

Yes I realize how it works and what your patch does, my point is that it
seems pointless to change code like that. Your 'test case' above isn't a
valid one. If register_blkdev() was called tons of times per second and
hence would be a hot code path, and it additionally most of the time
ended up freeing the buffer, then there would be a case for changing it.

-- 
Jens Axboe

