Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab1CCVhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:37:21 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:58396 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:37:18 -0500
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
Date: Fri, 04 Mar 2011 06:37:15 +0900
In-Reply-To: <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 3 Mar 2011 13:02:50 -0800")
Message-ID: <87lj0v9984.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Mar 3, 2011 at 12:46 PM, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
>>
>> But, some commands see i_nlink (IIRC, it's checking i_nlink == 2, to
>> know empty dir or not).
>
> Actually, that would be a serious bug in the application.
>
> The traditional rule of thumb is that a directory with i_nlink==1 has
> a "I'm not counting at all".
>
> For example, I think that's the rule that 'find' uses to decide if a
> directory can have subdirectories (and when it could try to stop
> scanning early): i_nlink == 1 means that yes, it _can_ have
> subdirectories, we just don't know how many.

Yes. I think it is.

> So checking i_nlink==2 is actually a user-level bug.

We can call it's the user-level bug, but like you know, we will receive
many complain if old behavior was broken. If you are saying i_nlink == 2
is meaning the undefine, it sounds strange. (I was thinking it's why
isofs is using i_nlink == 1 always. I.e. i_nlink >= 2 is defined
behavior. Actually the reason would be "find" was checking i_nlink == 2
though)

>> So we have to simulate some levels. I guess you
>> are not saying we don't need to care it at all though.
>
> I'm saying that it should just work to set i_nlink=1 and not do
> anything at all. Ever. It's a valid model for directory counts.
>
> Seriously - that's what isofs does, for example. It does mean that
> 'find' for certain cases gets bit more expensive, but on the other
> hand, other operations are a lot _less_ expensive.
>
> We might well try that as a FAT mount option, to let people decide
> whether they really do want the "scan directories all the time" or
> only the "let 'find' scan directories when it needs to" behavior.

Yes. i_nlink == 1 is ok, IIRC (I checked last time at least. And I used
i_nlink == 1 for exFAT).  And I agree with you almost all, but isofs is
read-only, the read-only is why I was not really sure.

And I can't only see is why you refuse to make consistent behavior (if
you are saying it). It's why I said if it's _really easy_.

Thanks
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
