Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab1CCXPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:15:03 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:35408 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947Ab1CCXPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:15:00 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
	<AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
	<20110303060352.GK22723@ZenIV.linux.org.uk>
	<AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
	<87tyfk7x0c.fsf@devron.myhome.or.jp>
	<AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
	<87lj0v9984.fsf@devron.myhome.or.jp>
	<AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
	<87hbbj96yh.fsf@devron.myhome.or.jp>
	<AANLkTintTRHmAfvBwFszNyqbssbX91k17u=0kh+V7N7D@mail.gmail.com>
Date: Fri, 04 Mar 2011 08:14:55 +0900
In-Reply-To: <AANLkTintTRHmAfvBwFszNyqbssbX91k17u=0kh+V7N7D@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 3 Mar 2011 14:37:36 -0800")
Message-ID: <87d3m794pc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Mar 3, 2011 at 2:26 PM, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
>>
>> I don't know much about NFS though, I imaged the NFS just fill the
>> stat.st_nlink to return to userland by 0 if sillyrenamed dentry? (of
>> course, I'm not saying let's emulate "i_nlink >= 1" on all
>> filesystems. just about i_nlink == 0) I was thinking Al is working for
>> it...
>
> So even if we did that, WHAT WOULD BE THE UPSIDE?
>
> Code that cares wouldn't run on any other Unix, or on any older
> version of Linux.
>
> And I claim that there is not a single reason to do it anyway. That
> whole "code that cares" is totally theoretical. Such code simply
> doesn't exist.
>
> If you just opened a directory, and then did a "rmdir()" on that
> directory, then you're just a f*cking moron if you go around saying
> "ok, let me now do an fstat() on that fd to see if it really got
> deleted or not". That's just _stupid_.
>
> Really. There is absolutely no point in introducing a new rule that
> nobody cares about, that we haven't followed ourselves historically,
> and that would require us to play insane hacky games.
>
> WHY DO IT? WHY CARE? WHY, WHY, WHY?

The reason is simple, I'm not sure it is true or not though. Because the
undefined behavior makes the unfixable bug or hard to fix bug (just
because of backward compatibiliy reason). In my experience, I was
bothered many times with that, and why I want to make define state
(well, now I think we define as "we don't care it". that's fine). I hate
it and it is why from me.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
