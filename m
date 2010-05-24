Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0EXHqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:46:10 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53455 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0EXHqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:46:08 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
	<alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com>
	<20100522223838.ebca396a.akpm@linux-foundation.org>
	<AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com>
	<20100523070917.GO23411@kernel.dk>
	<AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com>
	<20100523174706.GP23411@kernel.dk>
	<87632e846m.fsf@devron.myhome.or.jp>
	<20100524070416.GQ23411@kernel.dk>
Date: Mon, 24 May 2010 16:46:03 +0900
In-Reply-To: <20100524070416.GQ23411@kernel.dk> (Jens Axboe's message of "Mon,
	24 May 2010 09:04:16 +0200")
Message-ID: <87bpc54u9w.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> >> I'd recommend this: Pass it in and out in bytes. Don't round to a
>> >> power of 2. Require the user to know what they are doing. Give an
>> >> error if the user doesn't supply a power-of-2 * page-size for
>> >> F_SETPIPE_SZ. (Again, consider the case of architectures  with
>> >> switchable page sizes.)
>> >
>> > But is there much point in erroring on an incorrect size? If the
>> > application says "I need at least 120kb of space in there", kernel
>> > returns "OK, you got 128kb". Would returning -1/EINVAL for that case
>> > really make a better API? Doesn't seem like it to me.
>> 
>> FWIW, my first impression of this was setsockopt(SO_RCV/SNDBUF) of unix
>> socket. Well, API itself wouldn't say "at least this size" or "exactly
>> this size", so, in here, important thing is consistency of interfaces, I
>> think. (And the both is sane API at least for me if those had
>> consistency in the system.)
>> 
>> Well, so how about set/get in bytes, and kernel will set "at least
>> specified size" actually like setsockopt(SO_RCV/SNDBUF)?
>
> Isn't that pretty much what I described?

Yes, probably. Well, 120kb was still multiple of page size. :)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
