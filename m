Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab0EYECB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 00:02:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57763 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0EYECA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 00:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=D8Nsm7nryb7/GIv0tPD42RddnXyVVkJLJ8fGDOBmZr/K0nJCsRqOfGSEM6jsD+iP+B
         TMvashLBR+TbkCF4kjZyy/jhLWrKK2/PsgleE0XDoSJrfjx0B5hRMIwl63sOC0xzo1JP
         gI/FyjVNI/YSSbQA0TcT3/E1C6JrIFdNs2Zxk=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100524175649.GV23411@kernel.dk>
References: <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 
	<AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> 
	<20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 
	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 
	<20100524175649.GV23411@kernel.dk>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Tue, 25 May 2010 06:01:37 +0200
Message-ID: <AANLkTinHkWCdrOGZHbVGN4ooen9--z5rl5UL65wXcFEy@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Jens Axboe <jens.axboe@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, May 24 2010, Michael Kerrisk wrote:
>> On Mon, May 24, 2010 at 7:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Mon, May 24 2010, Michael Kerrisk wrote:
>> >> > Right, that looks like a thinko.
>> >> >
>> >> > I'll submit a patch changing it to bytes and the agreed API and fix this
>> >> > -Eerror. Thanks for your comments and suggestions!
>> >>
>> >> Thanks. And of course you are welcome. (Please CC linux-api@vger on
>> >> this patche (and all patches that change the API/ABI.)
>> >
>> > The first change is this:
>> >
>> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b
>> >
>> > and the one dealing with the pages vs bytes API is this:
>> >
>> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29
>> >
>> > Not tested yet, will do so before sending in of course.
>>
>> Eyeballing it quickly, these changes look right.
>
> Good, thanks.
>
>> Do you have some test programs you can make available?
>
> Actually I don't, I test it by modifying fio's splice engine to set/get
> the pipe size and test the resulting transfers.

Two more questions: is the rationale for this feature written up
somewhere? I could not find it. Is it primarily intended for
splice/vmsplice/tee, with the effect for pipe(2) being a side effect?

Also, the minuimum size of the buffer is 2 pages. Why is it not 1?
(Notwithstanding Linus's assertion, a buffer size of 1 page did give
us POSIX compliance in kernels before 2.6.10.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
