Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0ETIhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:37:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40838 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0ETIhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:37:33 -0400
Date: Thu, 20 May 2010 10:37:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100520083732.GI25951@kernel.dk>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> <20100519180554.GY25951@kernel.dk> <20100519190510.GZ25951@kernel.dk> <E1OF1C0-0007mV-VZ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OF1C0-0007mV-VZ@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20 2010, Miklos Szeredi wrote:
> On Wed, 19 May 2010, Jens Axboe wrote:
> > On Wed, May 19 2010, Jens Axboe wrote:
> > > On Wed, May 19 2010, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > On Wed, 19 May 2010, Miklos Szeredi wrote:
> > > > > 
> > > > > One issue I see is that it's possible to grow pipes indefinitely.
> > > > > Should this be restricted to privileged users?
> > > > 
> > > > Yes. But perhaps only if it grows past the default (or perhaps "default*2" 
> > > > or similar). That way a normal user could shrink the pipe buffers, and 
> > > > then grow them again if he wants to.
> > > 
> > > That's still a bit arbitrary, I don't think allowing default*2 only for
> > > non-root is going to be hugely interesting. But limiting makes sense,
> > > but lets at least allow a larger max limit for the normal user. I'm
> > > suspecting that the media application that wants to use this will not be
> > > running as root, and we don't make the feature properly available to the
> > > ones that want to use it, then we may as well not do it.
> > > 
> > > Or we could expose a sysctl for instance that holds the max non-root
> > > size. And make that default to default*16 or something. How does that
> > > sound?
> > > 
> > > > Oh, and I think you need to also require that there be at least two 
> > > > buffers. Otherwise we can't guarantee POSIX behavior, I think.
> > > 
> > > Good point, and at least that part is easily doable :-)
> > 
> > So I updated the patch, that branch was pretty ancient... The fcntl pipe
> > numbers were also screwed up, so got that fixed. New patch is here:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=23dcb845246946aeda5a5e398c6911381ad28365
> 
> Not sure why you didn't take my updated patch.  Yours misses
> conversion of kernel/trace/trace.c as well as some hunks below (that
> renaming the "pages" and "partial" arrays and a compile test would
> have revealed).

Sorry, I missed that you had done extra changes. I had to rebase the
whole thing anyway, and as I said it was totally untested. I'll get it
updated.

The main reason I didn't push it before is that I wasn't completely sure
that we wanted to use fcntl() for this. But Linus doesn't seem to object
on that side at least.

-- 
Jens Axboe

