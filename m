Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0HNXmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 19:42:15 -0400
Received: from mail001.aei.ca ([206.123.6.130]:53868 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab0HNXmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 19:42:14 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35.2
Date: Sat, 14 Aug 2010 19:39:53 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.2x-crc+; KDE/4.4.5; x86_64; ; )
Cc: sedat.dilek@gmail.com, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, penberg@kernel.org, arthur@psw.ro,
        wylda@volny.cz
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com> <201008141547.08722.edt@aei.ca> <AANLkTinP3Kh4Gjnkx2ycr34W6SVqLsBh7yMsGuoU7pAD@mail.gmail.com>
In-Reply-To: <AANLkTinP3Kh4Gjnkx2ycr34W6SVqLsBh7yMsGuoU7pAD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008141939.54277.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 August 2010 17:56:58 Linus Torvalds wrote:
> On Sat, Aug 14, 2010 at 12:47 PM, Ed Tomlinson <edt@aei.ca> wrote:
> > On Saturday 14 August 2010 14:47:45 Linus Torvalds wrote:
> >>
> >> Just to verify: you have CONFIG_HIGHPTE enabled on a x86-32 kernel,
> >> right? I'd have expected this to not ever show up anywhere else, and
> >> I'm just verifying that there isn't anything else going on. I'm
> >> appending the commit message, the patch hasn't changed.
> >
> > No.  I have a x86-64 based kernel (amd64).
> 
> Hmm. On x86-64, pte_unmap() is a no-op. So moving it around should not
> matter one whit. We don't even have a debug mode to turn it into some
> kind of "check that we use it properly in an atomic region" which we
> _could_ do.
> 
> Can you send me the messages you saw without that patch? There's
> something odd going on here. I don't like the fact that the patch
> apparently makes a difference for you. It shouldn't.

Linus,

Not to worry - looks like the problems here were due to a bad inode.
I just did not hit it when restarting with the  patch added.  When I
rebuilt the kernel without the patch it hit the fs/inode problem during
boot.  A manual fsck seems to have fixed things.

Ed Tomlinson
