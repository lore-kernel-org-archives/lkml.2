Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1LGCWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:22:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55935 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1LGCWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:22:16 -0500
MIME-Version: 1.0
In-Reply-To: <20111207013720.GS2203@ZenIV.linux.org.uk>
References: <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk> <20111207013720.GS2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 18:21:55 -0800
X-Google-Sender-Auth: Bcunp5OeDmdlvIH2-17M_7os5QE
Message-ID: <CA+55aFx7HZrZ=OxnRaCKnHJU0fYk5G7PY1o8eRBOaPZu7h-4kA@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 5:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Turns out that returning ERR_PTR(-EINVAL) is more convenient.
> All right, here's a variant that does *NOT* return any vfsmount/dentry
> pointers at all.  And it does best-sane-effort wrt returning the pathname;
> i.e. if it *is* something outside of chroot, that absolute pathname is
> what we'll get.

So I don't mind this patch, but I think the d_absolute_path() thing is
actually being a bit too nice to the two users of that new function.

Both users of that are just broken. And I think they should be fixed,
rather than pandered to. Both of them would be better off just
considering the "out of my mountspace" to be an error, rather than
using some random 'absolute' pathname (where "error" might obviously
mean "I will use another strategy entirely for this case").

Afaik, you really are trying to make crazy code continue to work in
ways that I'm not convinced is really required. Now, maybe it's a good
idea for this stage in the -rc process, but my gut feel is that we
could simply have broken it too. JJ seems willing to fix things up for
AppArmor, and I don't know of any big distro that uses Tomoyo, so...

But I don't actually have any real hatred of this patch. It definitely
falls into my acceptable range.

                      Linus
