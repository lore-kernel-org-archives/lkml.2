Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0EXH1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:27:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57081 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab0EXH1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=OGgUFc6Wm5MMslkKZQRIXxfKmCa+35+IE+nr71l1CzggsZzJwYxhdH2nvwc7v7KhJ1
         8/TPVZAGNXA3dVqXNR+GFPeABzrpdHm3nlwNWcdk9rkd5R52lTApHEVDWQ+7xkzF1Lo5
         R4t2LRy8gMpyHYtlb9RRPQGWC2YLM2V1lu/do=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100524070552.GR23411@kernel.dk>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> 
	<20100522223838.ebca396a.akpm@linux-foundation.org> <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 
	<AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> 
	<20100524070552.GR23411@kernel.dk>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Mon, 24 May 2010 09:27:12 +0200
Message-ID: <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Jens Axboe <jens.axboe@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 9:05 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> The "at least" idea makes sense. So, I'd change my recommendation to:
>>
>> Pass the buffer size in and out in bytes (for consistency with other
>> APIs). Round the input (F_SETPIPE_SZ) value up as required by the
>> implementation. For the output (F_GETPIPE_SZ) value do one of the
>> following:
>> a) Return the value given on input.
>> b) Return the rounded up value actually used by the kernel.
>>
>> I suspect (b) might be more useful: if an application cares enough
>> about pipe size to want to change it, then at least some such
>> applications might care to know exactly the size that the kernel used.
>> (And: I can't see any downside to (b).)
>
> b definitely, since it's the real size (plus then we don't have to track
> the passed in size).

Okay.

>> One other comment about the interface. We have
>>
>>                 if (!capable(CAP_SYS_ADMIN) && arg > pipe_max_pages)
>>                         return -EINVAL;
>>
>> The usual error on a capability denied is EPERM. Please change.
>
> Right, that looks like a thinko.
>
> I'll submit a patch changing it to bytes and the agreed API and fix this
> -Eerror. Thanks for your comments and suggestions!

Thanks. And of course you are welcome. (Please CC linux-api@vger on
this patche (and all patches that change the API/ABI.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
