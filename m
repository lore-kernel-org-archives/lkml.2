Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2ANUXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:23:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63920 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2ANUXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:23:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
 <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
 <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com> <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jan 2012 12:22:55 -0800
X-Google-Sender-Auth: 9NrDqoimPjiN3ATuIQY16UuPr4s
Message-ID: <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 5:30 AM, Jamie Lokier <jamie@shareable.org> wrote:
>
> Anyway the principle is there - CAP_NET_BIND doesn't necessarily mean
> the daemon code is trusted.

I really think all these arguments are *COMPLETELY* missing the point.

You don't have to use the new flag if you don't want to. Just let it go.

The point of the flag is to not allow security changes. It's that
easy. If you want something else, don't use it.

Because even "dropping capabilities" is quite often the wrong thing to
do. To one person it's "dropping capabilities", to another it is "no
longer running with the capabilities I need".

We've had security bugs that were *due* to dropped capabilities -
people dropped one capability but not another, and fooled code into
doing things they weren't expecting it to do. So quite frankly, I
believe that from a security standpoint it's a hell of a lot safer to
just keep the rules really simple.

Think of the "restrict" bit as "my universe will now run with this
*known* set of permissions".

And if you don't like it, don't use it. It really is that simple. But
don't make the model more complicated. Don't confuse it with "but but
capabilites" crap. The point of the patch is that it makes all of that
go away. There are no capabilities. There only is what you can do.

And yes, I really seriously do believe that is both safer and simpler
than some model that says "you can drop stuff", and then you have to
start making up rules for what "dropping" means.

Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
that no, we should not even allow that. It's simply all too "subtle".

(I don't think Andrew's patch actually touched any of those paths, but
I didn't check)

                      Linus
