Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2A3XP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:15:28 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46608 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2A3XPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <1327965046.5355.16.camel@lenny>
References: <cover.1327858005.git.luto@amacapital.net> <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
 <1327960736.5355.5.camel@lenny> <CALCETrWqOsWjnJOLD5TytOiSSiRE7wAwo6dRj5A7-jP-zEGa3A@mail.gmail.com>
 <1327963309.5355.7.camel@lenny> <CALCETrVMYaz0F9N5aecLJCo3da6zAE3hw+kEH+UFBoajjVu0sw@mail.gmail.com>
 <1327965046.5355.16.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jan 2012 15:15:02 -0800
Message-ID: <CALCETrXRjR0zHrKuLhbvCfgReO1sWnjQ-EVTRhH7=AMSJ6N-=g@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
To: Colin Walters <walters@verbum.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 3:10 PM, Colin Walters <walters@verbum.org> wrote:
> On Mon, 2012-01-30 at 14:43 -0800, Andy Lutomirski wrote:
>
>> You don't need a setuid binary.  Just have an initscript set up the bind mounts.
>
> The point is that dchroot is already setuid root, and calls chroot, so
> it gains nothing from the ability to do it unprivileged.
>
> (And wow, I just looked at the source, it's a setuid C++ binary!  Using
> boost.  Ugh...)

Exactly!

You can accomplish the same thing *without a scary setuid binary*.
The use case doesn't even need a new complicated userspace tool.  You
would set up an initscript or some /etc/fstab entries and then:

no_new_privs chroot /var/chroot/ubuntu_oneiric/ /bin/bash

et voila.  (Where no_new_privs would be a really simple tool that does
PR_SET_NO_NEW_PRIVS and then execs its argument.)

Maybe it's just me, but I think this is useful and I would, in fact,
use it in my regular workflow.

--Andy
