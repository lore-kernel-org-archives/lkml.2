Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1LGAmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:42:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48639 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1LGAmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:42:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111207003922.GO2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 16:42:00 -0800
X-Google-Sender-Auth: TJgHe7kGx2hszj-qws4-Vh-u3m4
Message-ID: <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 4:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> IOW, I mean this:

Yeah, no.

> +       if (ancestor) {
> +               ancestor->mnt = mntget(vfsmnt);
> +               ancestor->dentry = dget(dentry);
> +       }

This part is still just pure and utter sh*t.

You have not explained why that information is *ever* valid. And I
claim it isn't.

We have a bug in our current __d_path(). And I claim that the
underlying cause of the bug is the crazy "let's return this
nonsensical and idiotic information that cannot possibly make sense to
anybody".

We shouldn't have done that in the first place. And we certainly
shouldn't *continue* doing that.

              Linus
