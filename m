Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0FAP1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:27:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab0FAP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:27:12 -0400
Date: Tue, 1 Jun 2010 08:22:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
cc: mtk.manpages@gmail.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
In-Reply-To: <20100601074805.GM1660@kernel.dk>
Message-ID: <alpine.LFD.2.00.1006010813440.3637@i5.linux-foundation.org>
References: <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> <20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> <20100524070552.GR23411@kernel.dk>
 <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> <20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> <20100524175649.GV23411@kernel.dk> <AANLkTinHkWCdrOGZHbVGN4ooen9--z5rl5UL65wXcFEy@mail.gmail.com>
 <20100601074805.GM1660@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Jens Axboe wrote:
> 
> > Also, the minuimum size of the buffer is 2 pages. Why is it not 1?
> > (Notwithstanding Linus's assertion, a buffer size of 1 page did give
> > us POSIX compliance in kernels before 2.6.10.)
> 
> I'll defer to Linus on that, I remember some emails on that part from
> way back when. As far as I can tell, POSIX wants atomic writes of "less
> than a page size", which would make more sense as "of a page size and
> less". And since it should not be a page size from either side on a
> uni-directional pipe, then 1 page seems enough for that guarantee at
> least.

Hmm. You guys may well be right that a single slot is sufficient. It still 
gives us PIPE_BUF worth of data for writing atomically. I had this memory 
that we needed two because of the merging logic (we have that special case 
for re-using the previous page, so that we don't use waste of memory for 
lots of small writes), but looking at the code there is no reason at all 
for me to hav thought so.

So I don't know why I thought we needed the extra slot, and a single slot 
(if anybody really wants slow writes) looks to be fine.

		Linus
