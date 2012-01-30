Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2A3WtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:49:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33035 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab2A3WtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:49:14 -0500
X-Sasl-enc: sDxR9OOtUATRZveqzayc9mwQhuyXDeD5wYXKgs5Bm1Bw 1327963753
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
From: Colin Walters <walters@verbum.org>
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Date: Mon, 30 Jan 2012 17:48:49 -0500
In-Reply-To: <CABqD9habGczrDUxGUWpRQ1=bREjCx-6rPeYArnGXe76fW3K2zw@mail.gmail.com>
References: <cover.1327858005.git.luto@amacapital.net>
	 <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
	 <1327960736.5355.5.camel@lenny>
	 <1327961884.5882.11.camel@gandalf.stny.rr.com>
	 <CABqD9habGczrDUxGUWpRQ1=bREjCx-6rPeYArnGXe76fW3K2zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327963731.5355.12.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 16:38 -0600, Will Drewry wrote:
> On Mon, Jan 30, 2012 at 4:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2012-01-30 at 16:58 -0500, Colin Walters wrote:
> >> On Mon, 2012-01-30 at 08:17 -0800, Andy Lutomirski wrote:
> >> > Chroot can easily be used to subvert setuid programs.  If no_new_privs,
> >> > then setuid programs don't gain any privilege, so allow chroot.
> >>
> >> Is this needed/desired by anyone now, or are you just using it to "demo"
> >> NO_NEW_PRIVS?  I don't see it as very useful on its own, since in any
> >> "container"-type chroot you really want /proc and /dev, and your patch
> >> doesn't help with that.
> >>
> >> System daemons that do chroot for a modicum of security already start
> >> privileged, so this doesn't help them either.
> >
> > I thought this was all for sandboxing? If a browers (or user) wants to
> > run some untrusted code, perhaps a chroot is the best way to do so. It
> > just will break if it needs to access /proc or /dev.

I think you'll find your definition of "code" becomes very limited
without /dev/null, /dev/zero and /proc/cpuinfo for example, as used by
glibc.

Personally I find it amazing we're even debating putting new
security-relevant API in the kernel with no known userspace consumer.
It can always go in later if someone actually wants it.

> Interestingly, I believe this change would work for the Chromium
> setuid sandbox[1]. It uses a fancy clone trick (CLONE_FS) to start the
> process then chroot once all its dependencies are loaded. It then
> chroot()s to /proc/self/fd_info (or another empty process-specific
> directory). 

But...it's setuid, so it can call chroot already?  I'm not following how
this change would benefit the helper.


