Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1LGCCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:02:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1LGCCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <20111207012318.GR2203@ZenIV.linux.org.uk>
References: <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk> <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
 <20111207005253.GP2203@ZenIV.linux.org.uk> <CA+55aFxzZOL_TgQSvCUBNsm8OjR_UDHADL=bBeLe-xJ=3PsNhg@mail.gmail.com>
 <20111207012318.GR2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 18:02:22 -0800
X-Google-Sender-Auth: sFAIzY9nlsjS-X39uSjJ3qxJwxQ
Message-ID: <CA+55aFzz7M=SoPwzACxQK+mc8BZRHy03z-T-Q_4mmcCQ0YhtJg@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 5:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Damnit, it may very well be NOT ANY KIND OF ROOT AT ALL.  Which is what
> I'd been trying to tell you all along.  You can race with umount -l.
> In that case that thing might have been *INSIDE* your chroot jail.
> Anywhere in it.

AND NOBODY CARES.

That's the deeper point here. IT DOES NOT MATTER.

Why do you try to convince people that it does. Nobody uses the
information that you claim is so magically important.

You are the only one who seems to think that it matters. No code
agrees with you except for the clearly broken AppArmor code that
everybody agrees should just go the f*ck away.

> See what I'm talking about?  I'm fine with giving the pathname to global
> root.  It's doing that to *random* just-unmounted vfsmount that is not
> a good thing.

It *never* matters. The pathname should never be used at all.

We want to *see* what the pathname is, but no code should ever use it.

The *only* valid use for the broken pathname is for a "show user debug
information". That's all I've ever claimed. The "where it was mounted
- or *if* it was mounted" part is pointless.

Why do you keep on harping on this totally useless issue? Seriously?

                 Linus
