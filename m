Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1D1N0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:26:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33028 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755824Ab1D1N0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:26:06 -0400
Date: Thu, 28 Apr 2011 15:25:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
Message-ID: <20110428132551.GA5701@ucw.cz>
References: <1303498136.8485.128.camel@localhost>
 <87hb9qnho4.fsf@devron.myhome.or.jp>
 <1303509408.8485.146.camel@localhost>
 <87bozxomqd.fsf@devron.myhome.or.jp>
 <1303558711.8485.166.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303558711.8485.166.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  For overwriting the
> > zeroed entry, why we have to check all entries until see next zeroed
> > (yeah, now, we allowed the crappy data after zeroed)?
> My point was not about checking all entries until the next zeroed entry,
> which is overcomplicating stuff. I meant that if we hit the end (i.e.
> the first zeroed entry) when searching for free slots, in that case we
> just clear the one entry directly following the inserted entries. This
> makes sure that no files magically appear. I *do* understand that

This sounds like a good idea, and costs nothing. I hope we can
convince Ogawa...

> In the end, there are two valid interpretations on the problem at hand:
>  - DOS/Windows is buggy in exposing the crap when filling the "hole",
> which is proven by chkdsk not complaining about the garbage in the
> directory, and we should not follow the bug in DOS/Windows
>  - chkdsk is buggy in not complaining about trailing garbage in
> directories, which are proven to be invalid by DOS/Windows messing up on
> them, and we shouldn't complicate our FAT implementation by trying to
> work around a bug in chkdsk.

I believe 2) is the case; but we should still work around that chkdsk
bug.

> I think the *most* important fact is to have at least dosfsck and linux
> consistent about directories with trailing garbage. So I won't even try
> to submit a patch to the Linux kernel that stops reading at the first
> unused directory entry if dosfsck will not accept to stop reading at the
> first unused directory entry.

They should *not* be consistent.

Kernel should stop at zero invalid entry.

fsck should consider any garbage past zero entry as an error, and zero
it out. (Complaining about duplicate blocks is unhelpful but better
than nothing.  It should really zero the garbage out.)
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
