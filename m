Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab0FCGKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:10:44 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37786 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0FCGKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:10:41 -0400
Date: Thu, 3 Jun 2010 08:10:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: mtk.manpages@gmail.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100603061039.GD3564@kernel.dk>
References: <87632e846m.fsf@devron.myhome.or.jp> <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> <20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> <20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> <20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02 2010, Michael Kerrisk wrote:
> On Tue, Jun 1, 2010 at 9:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > On Thu, May 27 2010, Michael Kerrisk wrote:
> >> Jens,
> >>
> >> On Mon, May 24, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> > On Mon, May 24 2010, Michael Kerrisk wrote:
> >> >> On Mon, May 24, 2010 at 7:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> >> > On Mon, May 24 2010, Michael Kerrisk wrote:
> >> >> >> > Right, that looks like a thinko.
> >> >> >> >
> >> >> >> > I'll submit a patch changing it to bytes and the agreed API and fix this
> >> >> >> > -Eerror. Thanks for your comments and suggestions!
> >> >> >>
> >> >> >> Thanks. And of course you are welcome. (Please CC linux-api@vger on
> >> >> >> this patche (and all patches that change the API/ABI.)
> >> >> >
> >> >> > The first change is this:
> >> >> >
> >> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b
> >> >> >
> >> >> > and the one dealing with the pages vs bytes API is this:
> >> >> >
> >> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29
> >> >> >
> >> >> > Not tested yet, will do so before sending in of course.
> >> >>
> >> >> Eyeballing it quickly, these changes look right.
> >> >
> >> > Good, thanks.
> >> >
> >> >> Do you have some test programs you can make available?
> >> >
> >> > Actually I don't, I test it by modifying fio's splice engine to set/get
> >> > the pipe size and test the resulting transfers.
> >>
> >> An afterthought. Do there not also need to be fixes to the /proc
> >> interfaces. I don't think they were included in your revised patches.
> >
> > I think the proc part can be sanely left in pages, since it's just a
> > memory limiter.
> 
> I can't see any advantage to using two different units for these
> closely related APIs, and it does seem like it could be a source of
> confusion. Similar APIs that I can think of like RLIMIT_MEMLOCK and
> shmget() SHMMAX that impose per-process memory-related limits use
> bytes. Best to be consistent, don't you think?

But they are different interfaces.  I think the 'pass in required size,
return actual size' where actual size is >= required size makes sense
for the syscall part, but for an "admin" interface it is more logical to
deal in pages. Perhaps that's just me and the average admin does not
agree. So while it's just detail, it's also an interface so has some
importance. And if there's consensus that bytes is a cleaner interface
on the proc side as well, then lets change it.

-- 
Jens Axboe

