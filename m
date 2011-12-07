Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1LGBMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:12:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59028 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1LGBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <20111207005253.GP2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk> <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
 <20111207005253.GP2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 17:11:59 -0800
X-Google-Sender-Auth: I-j0o5cAD9cSGDRDcK7-A_yRcoY
Message-ID: <CA+55aFxzZOL_TgQSvCUBNsm8OjR_UDHADL=bBeLe-xJ=3PsNhg@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 4:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> But why do you want that ancestor thing?
>
> Because the path is useless without some idea where it starts?

No.

You're thinking about this wrong, and you have gotten stuck thinking that way.

The "where it starts" doesn't help you in any way. It has absolutely
zero new information, apart from the "it's unreachable from your
current root" part.

> "It was /foo/bar/baz counting from some point; might have
> been global root, might have been any random mountpoint if we'd
> raced with umount and you've got no way to tell one from another"
> is not particulary useful in logs.

Umm. Think it through. NOBODY WILL EVER SEE ANYTHING ELSE *ANYWAY*.

There is no valid information in that "where it starts". There's
nothing more you can tell about it. So why return it?

The "it was /foo/bar/baz" part is undeniabty useful. People do
actually want that part, but they want it for printouts to the
sysadmin or the user, who will then go "Ahh, I see what's up, they're
in a chroot environment and they still have access to /foo/bar/baz
from outside".

But no possible user would ever actually care about that "ancestor"
thing. There is absolutely nothing useful you can say about it. It's
*some* kind of root, but that's just about all the relevant
information you'd ever want to know.

Equally importantly, no existing users actually use that information.
Sure, AppArmor looked at it, but it looked at it *WRONG*. What
AppArmor does doesn't actually make any sense to do.

So why make excuses for it? It's useless and unused information that
only complicates the interface. The only thing anybody *ever* actually
wants to know is that one single bit of information: "was it reachable
or not?"

                           Linus
