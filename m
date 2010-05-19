Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0ESSF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:05:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40114 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0ESSF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:05:56 -0400
Date: Wed, 19 May 2010 20:05:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100519180554.GY25951@kernel.dk>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19 2010, Linus Torvalds wrote:
> 
> 
> On Wed, 19 May 2010, Miklos Szeredi wrote:
> > 
> > One issue I see is that it's possible to grow pipes indefinitely.
> > Should this be restricted to privileged users?
> 
> Yes. But perhaps only if it grows past the default (or perhaps "default*2" 
> or similar). That way a normal user could shrink the pipe buffers, and 
> then grow them again if he wants to.

That's still a bit arbitrary, I don't think allowing default*2 only for
non-root is going to be hugely interesting. But limiting makes sense,
but lets at least allow a larger max limit for the normal user. I'm
suspecting that the media application that wants to use this will not be
running as root, and we don't make the feature properly available to the
ones that want to use it, then we may as well not do it.

Or we could expose a sysctl for instance that holds the max non-root
size. And make that default to default*16 or something. How does that
sound?

> Oh, and I think you need to also require that there be at least two 
> buffers. Otherwise we can't guarantee POSIX behavior, I think.

Good point, and at least that part is easily doable :-)

-- 
Jens Axboe

