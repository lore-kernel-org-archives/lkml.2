Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LQXYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 18:24:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61229 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1LQXYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 18:24:17 -0500
Date: Sun, 18 Dec 2011 02:20:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Namhyung Kim <namhyung@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: fput() called in loop_clr_fd() may cause bd_mutex
 recursive locking
Message-ID: <20111217232053.GD3313@swordfish>
References: <20111217215333.GA3313@swordfish>
 <20111217221232.GA2203@ZenIV.linux.org.uk>
 <20111217221928.GB3313@swordfish>
 <20111217223033.GB2203@ZenIV.linux.org.uk>
 <20111217223745.GC3313@swordfish>
 <20111217225846.GC2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217225846.GC2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/17/11 22:58), Al Viro wrote:
> On Sun, Dec 18, 2011 at 01:37:45AM +0300, Sergey Senozhatsky wrote:
> > > Think of it for a minute - if we could run into the
> > > same bdev in that recursion, what would have happened on read() from
> > > that sucker? So yes, it is a false positive. 
> > 
> > I've tried read()/write() some time ago and it worked. Perhaps, I just
> > wasn't "lucky" enough to hit any problems.
> 
> Sure - exactly because of that loop prevention logics.  *If* we really
> had been able to set a loop0 -> loop1 -> loop2 -> loop0 or something of
> that sort, this warning wouldn't be a false positive.  But on any
> such setup, where would IO attempts end up doing?  

Thanks for your explanations.

> IOW, we have to prevent such setups anyway and not just because of
> problems on close() - they would be deadly on read() and write()...
> 

Preventing recursion in the first place? For example, in lo_open()?


	Sergey
