Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0EXPn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:43:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39695 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0EXPnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=aghp5OC9QEKITA5zcw4KGBPeIaPgJSGDQ/0FYJDMFjGzVgwEt3b3HTDJbdTzFl/2dE
         ZV+6msMtHwIslNnA9uUOn3w+vwam6I7qMdUVBgX7cWr3IiRa1QrPJq2CCeMf815pG3as
         XgCqUuiBieFfLvzINUpYZeXYnwvYKu+pdWRWI=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <4BFA927A.8070305@athenacr.com>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <20100522223838.ebca396a.akpm@linux-foundation.org> 
	<AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 
	<20100524070416.GQ23411@kernel.dk> <AANLkTikwTa16lDh87zkI-L9SaI9jG1_eqZuo4z7dj2qP@mail.gmail.com> 
	<4BFA927A.8070305@athenacr.com>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Mon, 24 May 2010 17:43:32 +0200
Message-ID: <AANLkTilJqTEZwQdZOQiiwGzQRu_-d4voY5GlwpuW_epl@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Brian Bloniarz <bmb@athenacr.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 4:51 PM, Brian Bloniarz <bmb@athenacr.com> wrote:
> On 05/24/2010 03:28 AM, Michael Kerrisk wrote:
>> Actually, SO_*BUF is pretty weird. It returns double what was
>> supplied. It's not simply a matter of rounding up: it always doubles
>> what was supplied.
>
> Rationale in net/core/sock.c:
>
> set_rcvbuf:
>                sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
>                /*
>                 * We double it on the way in to account for
>                 * "struct sk_buff" etc. overhead.   Applications
>                 * assume that the SO_RCVBUF setting they make will
>                 * allow that much actual data to be received on that
>                 * socket.
>                 *
>                 * Applications are unaware that "struct sk_buff" and
>                 * other overheads allocate from the receive buffer
>                 * during socket buffer allocation.
>                 *
>                 * And after considering the possible alternatives,
>                 * returning the value we actually used in getsockopt
>                 * is the most desirable behavior.
>                 */
>                if ((val * 2) < SOCK_MIN_RCVBUF)
>                        sk->sk_rcvbuf = SOCK_MIN_RCVBUF;
>                else
>                        sk->sk_rcvbuf = val * 2;
>                break;
>
> I'm guessing pipes don't have this kind of wrinkle.

Yes, all of the above is understood. It's exposing these details to
userspace that's weird...

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
