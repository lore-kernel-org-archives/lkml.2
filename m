Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0EXHFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:05:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44161 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab0EXHFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:05:53 -0400
Date: Mon, 24 May 2010 09:05:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: mtk.manpages@gmail.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100524070552.GR23411@kernel.dk>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> <AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> <20100522223838.ebca396a.akpm@linux-foundation.org> <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> <20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> <20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The "at least" idea makes sense. So, I'd change my recommendation to:
> 
> Pass the buffer size in and out in bytes (for consistency with other
> APIs). Round the input (F_SETPIPE_SZ) value up as required by the
> implementation. For the output (F_GETPIPE_SZ) value do one of the
> following:
> a) Return the value given on input.
> b) Return the rounded up value actually used by the kernel.
> 
> I suspect (b) might be more useful: if an application cares enough
> about pipe size to want to change it, then at least some such
> applications might care to know exactly the size that the kernel used.
> (And: I can't see any downside to (b).)

b definitely, since it's the real size (plus then we don't have to track
the passed in size).

> One other comment about the interface. We have
> 
>                 if (!capable(CAP_SYS_ADMIN) && arg > pipe_max_pages)
>                         return -EINVAL;
> 
> The usual error on a capability denied is EPERM. Please change.

Right, that looks like a thinko.

I'll submit a patch changing it to bytes and the agreed API and fix this
-Eerror. Thanks for your comments and suggestions!

-- 
Jens Axboe

