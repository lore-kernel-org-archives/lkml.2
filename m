Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1IFPkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:40:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53527 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1IFPkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:40:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ian Kent <raven@themaw.net>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        autofs@linux.kernel.org
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
	<17416.1315240659@redhat.com> <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
	<1315281208.3210.26.camel@perseus.themaw.net>
	<87mxeixfaq.fsf@tucsk.pomaz.szeredi.hu>
	<1315319903.3210.51.camel@perseus.themaw.net>
Date: Tue, 06 Sep 2011 17:39:53 +0200
In-Reply-To: <1315319903.3210.51.camel@perseus.themaw.net> (Ian Kent's message
	of "Tue, 06 Sep 2011 22:38:23 +0800")
Message-ID: <87ipp5y912.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Tue, 2011-09-06 at 10:09 +0200, Miklos Szeredi wrote:
>> Ian Kent <raven@themaw.net> writes:
>> 
>> > On Mon, 2011-09-05 at 19:02 +0200, Miklos Szeredi wrote:
>> >> 
>> >> If automounting on lstat(2) is the correct behavior (is it?  why?)  then at
>> >> least it should be enabled by a global switch or mount option, IMO.
>> >
>> > Ideally we wouldn't need to take special precautions for these
>> > operations at all but we can't, especially for GUI environments that
>> > constantly scan file systems on mount/umount activity.
>> >
>> > Historically for autofs, neither stat(2) or lstat(2) would trigger a
>> > mount. With the current implementation stat(2) now does but lstat(2)
>> > doesn't which is a step in the right direction IMHO. So, I recommend we
>> > continue to encourage user space to make the needed changes so we
>> > continue to move in the right direction, and yes, I acknowledge it is a
>> > pain but it'll never get done otherwise.
>> 
>> I'm not quite convinced.  What's the advantage of triggering automount
>> on stat(2)?
>
> You get the information of the directory of the mounted fs and for many
> peoples purposes automounting should be transparent so that would be
> best.

The same is true for lstat(2).

>  
>> 
>> Has anybody complained that stat(2) on the mountpoint doesn't cause an
>> automount?
>
> Yes, based on the reasoning above.

Would any of those complaints go away if stat(2) did cause an
automount and lstat(2) didn't?

With AT_NO_AUTOMOUNT I can agree with, that's a flag specifically about
not automounting.  Unlike AT_SYMLINK_NOFOLLOW which is about following
symlinks and hasn't got a lot to do with automounts.

Thanks,
Miklos
