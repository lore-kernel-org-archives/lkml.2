Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0FAQnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:43:46 -0400
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:33093 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753449Ab0FAQno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:43:44 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 12:43:44 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] pipe: add support for shrinking and growing pipes
Date: Tue, 1 Jun 2010 12:36:33 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90BB30BAF@nsmail.netscout.com>
In-Reply-To: <alpine.LFD.2.00.1006010813440.3637@i5.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] pipe: add support for shrinking and growing pipes
Thread-Index: AcsBnvdvDoLcwBhLQB+nGiVKMGd8cQABwNIQ
References: <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> <20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> <20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> <20100524175649.GV23411@kernel.dk> <AANLkTinHkWCdrOGZHbVGN4ooen9--z5rl5UL65wXcFEy@mail.gmail.com> <20100601074805.GM1660@kernel.dk> <alpine.LFD.2.00.1006010813440.3637@i5.linux-foundation.org>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>
Cc: <mtk.manpages@gmail.com>, "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Jun 2010 16:36:35.0085 (UTC) FILETIME=[997423D0:01CB01A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Linus Torvalds
> Sent: June 01, 2010 11:22 AM
> 
> On Tue, 1 Jun 2010, Jens Axboe wrote:
> >
> > > Also, the minuimum size of the buffer is 2 pages. Why is it not 1?
> > > (Notwithstanding Linus's assertion, a buffer size of 1 page did
>     give us POSIX compliance in kernels before 2.6.10.)
> >
> > I'll defer to Linus on that, I remember some emails on that part
from
> > way back when. As far as I can tell, POSIX wants atomic writes of
> > "less than a page size", which would make more sense as "of a page
size and
> > less". And since it should not be a page size from either side on a
> > uni-directional pipe, then 1 page seems enough for that guarantee at
> > least.
> 
> Hmm. You guys may well be right that a single slot is sufficient. It
> still gives us PIPE_BUF worth of data for writing atomically. I had
this
> memory that we needed two because of the merging logic (we have that
special
> case for re-using the previous page, so that we don't use waste of
memory
> for lots of small writes), but looking at the code there is no reason
at
> all for me to hav thought so.
> 
> So I don't know why I thought we needed the extra slot, and a single
> slot (if anybody really wants slow writes) looks to be fine.
> 

Ok, I have a really dumb/basic question. The reason we are letting users
grow the pipe->buffers is to decrease the number of splice-calls. This
implies the user has fnctl'd(when he/she wants performance). Can we not
have an option where we don't have to 'alloc pipe->buffers' worth pages
every single time? As an example look at 'default_file_splice_read'. Is
it possible to enhance the existing functionality by defining a new cmd
and a flag(in struct pipe_xxx etc) and allowing an user to control that?
Something like 'fcntl->F_SETPIPE_SZ_AND_LOCK_PIPE_PAGES'? Does this make
sense?

regards
Chetan Loke
