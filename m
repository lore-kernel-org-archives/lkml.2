Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab1D1Po1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:44:27 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:52509 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab1D1PoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:44:23 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: Pavel Machek <pavel@ucw.cz>, dosfstools <daniel@debian.org>,
        mtools <Alain@linux.lu>, linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
References: <1303498136.8485.128.camel@localhost>
	<87hb9qnho4.fsf@devron.myhome.or.jp>
	<1303509408.8485.146.camel@localhost>
	<87bozxomqd.fsf@devron.myhome.or.jp>
	<1303558711.8485.166.camel@localhost> <20110428132551.GA5701@ucw.cz>
	<1303998185.8188.18.camel@localhost>
Date: Fri, 29 Apr 2011 00:44:16 +0900
In-Reply-To: <1303998185.8188.18.camel@localhost> (Michael Karcher's message
	of "Thu, 28 Apr 2011 15:43:05 +0200")
Message-ID: <87d3k6idnz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> writes:

> Am Donnerstag, den 28.04.2011, 15:25 +0200 schrieb Pavel Machek:
>> > >  For overwriting the
>> > > zeroed entry, why we have to check all entries until see next zeroed
>> > > (yeah, now, we allowed the crappy data after zeroed)?
>> > My point was not about checking all entries until the next zeroed entry,
>> > which is overcomplicating stuff. I meant that if we hit the end (i.e.
>> > the first zeroed entry) when searching for free slots, in that case we
>> > just clear the one entry directly following the inserted entries. This
>> > makes sure that no files magically appear. I *do* understand that
>> This sounds like a good idea, and costs nothing. I hope we can
>> convince Ogawa...
>
> I am going to implement that and publish a patch. If the patch is clean
> enough, maybe we can convince him. But the freedom of open source can't
> prevent me from using a patch like that, of course. And maybe it also
> helps when the patch gets some testing.

Of course, it's good to publish. However if you can't detect buggy or
corrupted directory, I wouldn't ack to help buggy stuff.

So it can be the mount option, but I can't see at all the point it is
in-kernel as FS.

>> Kernel should stop at zero invalid entry.

I'm not complaining to stop at zero. Rather I acked already if it didn't
overwrite after zeroed entry.

>> fsck should consider any garbage past zero entry as an error, and zero
>> it out. (Complaining about duplicate blocks is unhelpful but better
>> than nothing.  It should really zero the garbage out.)
>
> In fact, what you describe is something I would call "consistent". I was
> not implying that kernel and dosfsck should do exactly the same thing,
> but I was implying that the kernel and dosfsck should either both or
> none consider entries past the gap as existing file.
> Current state is: both consider past-gap entries valid. Your described
> state will be: none consider past-gap entries valid. The behaviour you
> describe is exactly what I would imagine as best way to go. Maybe fsck
> should ask for "shift post-gap entries/create a dummy deleted entry"
> vs. "clear post-gap entries".

Yes. Also my opinion is the fsck should get ack from user to overwrite
data or salvage (has possibility to salvage) if interactive mode, then
fixes it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
