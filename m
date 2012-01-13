Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2AMTNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:13:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51648 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab2AMTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:13:00 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 11:12:37 -0800
X-Google-Sender-Auth: P6A3afl6033_uin_8CbmcUrvZww
Message-ID: <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 11:00 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Changing it to fail the exec when a transition would occur will make
> seccomp considerably less useful to selinux users -- the presence of
> MAC policy on a program (regardless of what that policy is) will make
> it unusable inside a sandbox.

I don't agree. I think that's exactly what we want sandboxing for, to
avoid any kind of subtle security issues.

And in 99.99% of all sandboxes, you would never ever want to execute
something with a different MAC policy on it. In fact, most of the
whole point of the sandboxing tends to be to make sure that the user
stays inside the exact *small* environment that was provided just for
that thing.

So I bet the google chrome people are not at all interested in
"running random binaries", and might want execve() very much for
"running some specific binaries that we ship with or install from the
browser".

So I really think that the *only* valid model is the "fail the execve
on any changes", not the "mnt-nosuid" approach of trying to run things
with the wrong permissions and get perhaps odd results. And I think it
works even - and perhaps *especially* - in models like selinux or
apparmor that do have a lot of "implicit MAC knowledge" on specific
binaries.

                    Linus
