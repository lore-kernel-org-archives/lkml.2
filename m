Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab1DWAGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:06:11 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35317 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab1DWAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:06:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
References: <1303498136.8485.128.camel@localhost>
	<87hb9qnho4.fsf@devron.myhome.or.jp>
	<1303509408.8485.146.camel@localhost>
Date: Sat, 23 Apr 2011 09:06:02 +0900
In-Reply-To: <1303509408.8485.146.camel@localhost> (Michael Karcher's message
	of "Fri, 22 Apr 2011 23:56:48 +0200")
Message-ID: <87bozxomqd.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> writes:

>> Windows will stop at 4, but if windows write new entry as 4, 5- will
>> show those up as crap like linux.
> You are right. Thanks for your input. This means Windows and mtools
> behave exactly the same way (and thus mtools can not really be
> considered buggy). I expected Windows to fix up the end, but it does
> not.
>
> I still would prefer greatly if Windows and Linux at least read media
> the same way (i.e. stop on the first zeroed entry), I even have a patch
> for that somewhere around I can dig out.
> I furthermore think it is quite important for dosfsck and the linux
> kernel to behave consistent (think of valid entries after the zeroed
> entry linking to "lost clusters"). If I prepare patches for the Linux
> kernel to
>  - terminate reading at the first zeroed entry

This is acceptable (stop at zero is an simply optimization), and I'll
just care about stability and cleanness about it.

>  - making sure that if a zeroed entry gets populated, the next entry
> gets zeroed unless we hit the end of the directory (deviating from
> Windows behaviour, intentionally, to keep the filesystem consistent)

This would be unacceptable. There are several FAT implementations like
this crap, I can't honor an one of those until to decide to try to
support all of craps.

I.e. This is the out of specs anymore. Why can you say those are invalid
entries even if Windows honors those entries? And the above is simulate
Windows implementation over specs, why isn't here? For overwriting the
zeroed entry, why we have to check all entries until see next zeroed
(yeah, now, we allowed the crappy data after zeroed)?

My state is simple - the current implement should be fine.
I.e. uninitialized directory is the simply bug. (However, I can honor to
stop at zero, because it is mentioned in spec as optimization.)

> And for dosfsck to
>  - terminate reading at the first zeroed entry
>  - offer filling the remainder of a directory cluster with zero bytes.
> Would this set of patches be acceptable?

Sorry. I can't say about dosfsck, I'm not maintainer of it. Ideas,
dosfstools maintainer?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
