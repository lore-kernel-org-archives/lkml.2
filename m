Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab1D1Nms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:42:48 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:42680 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759730Ab1D1Nmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:42:46 -0400
Subject: Re: End of FAT directories
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110428132551.GA5701@ucw.cz>
References: <1303498136.8485.128.camel@localhost>
	 <87hb9qnho4.fsf@devron.myhome.or.jp> <1303509408.8485.146.camel@localhost>
	 <87bozxomqd.fsf@devron.myhome.or.jp> <1303558711.8485.166.camel@localhost>
	 <20110428132551.GA5701@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 15:43:05 +0200
Message-ID: <1303998185.8188.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 160.45.35.69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 28.04.2011, 15:25 +0200 schrieb Pavel Machek:
> > >  For overwriting the
> > > zeroed entry, why we have to check all entries until see next zeroed
> > > (yeah, now, we allowed the crappy data after zeroed)?
> > My point was not about checking all entries until the next zeroed entry,
> > which is overcomplicating stuff. I meant that if we hit the end (i.e.
> > the first zeroed entry) when searching for free slots, in that case we
> > just clear the one entry directly following the inserted entries. This
> > makes sure that no files magically appear. I *do* understand that
> This sounds like a good idea, and costs nothing. I hope we can
> convince Ogawa...

I am going to implement that and publish a patch. If the patch is clean
enough, maybe we can convince him. But the freedom of open source can't
prevent me from using a patch like that, of course. And maybe it also
helps when the patch gets some testing.

> > I think the *most* important fact is to have at least dosfsck and linux
> > consistent about directories with trailing garbage. So I won't even try
> > to submit a patch to the Linux kernel that stops reading at the first
> > unused directory entry if dosfsck will not accept to stop reading at the
> > first unused directory entry.
> They should *not* be consistent.
> 
> Kernel should stop at zero invalid entry.
> 
> fsck should consider any garbage past zero entry as an error, and zero
> it out. (Complaining about duplicate blocks is unhelpful but better
> than nothing.  It should really zero the garbage out.)

In fact, what you describe is something I would call "consistent". I was
not implying that kernel and dosfsck should do exactly the same thing,
but I was implying that the kernel and dosfsck should either both or
none consider entries past the gap as existing file. Current state is:
both consider past-gap entries valid. Your described state will be: none
consider past-gap entries valid. The behaviour you describe is exactly
what I would imagine as best way to go. Maybe fsck should ask for "shift
post-gap entries/create a dummy deleted entry" vs. "clear post-gap
entries".

Regards,
  Michael Karcher


