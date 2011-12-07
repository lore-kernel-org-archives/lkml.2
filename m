Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1LGBXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:23:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36103 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1LGBXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:23:20 -0500
Date: Wed, 7 Dec 2011 01:23:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207012318.GR2203@ZenIV.linux.org.uk>
References: <20111206205346.GK2203@ZenIV.linux.org.uk>
 <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
 <20111207005253.GP2203@ZenIV.linux.org.uk>
 <CA+55aFxzZOL_TgQSvCUBNsm8OjR_UDHADL=bBeLe-xJ=3PsNhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxzZOL_TgQSvCUBNsm8OjR_UDHADL=bBeLe-xJ=3PsNhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 05:11:59PM -0800, Linus Torvalds wrote:

> It's
> *some* kind of root, but that's just about all the relevant
> information you'd ever want to know.

Damnit, it may very well be NOT ANY KIND OF ROOT AT ALL.  Which is what
I'd been trying to tell you all along.  You can race with umount -l.
In that case that thing might have been *INSIDE* your chroot jail.
Anywhere in it.

We raced with umount -l /mnt.  And what would be /mnt/1/2/foo/bar/baz
had shown up as /foo/bar/baz.  A few cycles earlier or later it could
be /1/2/foo/bar/baz or /bar/baz.  And you are not in chroot jail at
all.  _That_ is what I have trouble with.  Because that sysadmin will
misinterpret it exactly the way you have...

See what I'm talking about?  I'm fine with giving the pathname to global
root.  It's doing that to *random* just-unmounted vfsmount that is not
a good thing.

And yes, we can avoid returning that struct vfsmount *.  Fortunately.
See the posting in another branch of that thread for details.
