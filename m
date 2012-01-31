Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2AaAOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:14:04 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38706 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2AaAOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:14:01 -0500
MIME-Version: 1.0
In-Reply-To: <1327967744.5355.35.camel@lenny>
References: <cover.1327858005.git.luto@amacapital.net> <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
 <1327960736.5355.5.camel@lenny> <CALCETrWqOsWjnJOLD5TytOiSSiRE7wAwo6dRj5A7-jP-zEGa3A@mail.gmail.com>
 <1327963309.5355.7.camel@lenny> <CALCETrVMYaz0F9N5aecLJCo3da6zAE3hw+kEH+UFBoajjVu0sw@mail.gmail.com>
 <1327965046.5355.16.camel@lenny> <CALCETrXRjR0zHrKuLhbvCfgReO1sWnjQ-EVTRhH7=AMSJ6N-=g@mail.gmail.com>
 <1327967744.5355.35.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jan 2012 16:13:39 -0800
Message-ID: <CALCETrUUY8JcWA0xeK1Qt2S5V4kPFUCT3o7Nbfhc41CxRHJLEQ@mail.gmail.com>
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

On Mon, Jan 30, 2012 at 3:55 PM, Colin Walters <walters@verbum.org> wrote:
> On Mon, 2012-01-30 at 15:15 -0800, Andy Lutomirski wrote:
>
>> You can accomplish the same thing *without a scary setuid binary*.
>> The use case doesn't even need a new complicated userspace tool.  You
>> would set up an initscript or some /etc/fstab entries and then:
>
> That requires administrative access to the system and custom
> configuration; if you have that, you could just as easily set up a
> wrapper script to run sudo + shell script to do whatever you want for
> example.
>
> That's the role schroot fills now - basically pre-canned scripts, but
> you don't get out of custom configuration or needing root access to set
> it up.   And as I mentioned in https://lkml.org/lkml/2011/12/9/213, it's
> not as interesting as you might think even in the model of
> "pre-configure, give out access to regular users", because if you allow
> uploading .debs, it's just an elaborate root shell.
>
> The most interesting thing to me is an entire setup that doesn't require
> administrative access, so you can do it on any server or workstation,
> and I have that with linux-user-chroot.
>
>> no_new_privs chroot /var/chroot/ubuntu_oneiric/ /bin/bash
>>
>> et voila.  (Where no_new_privs would be a really simple tool that does
>> PR_SET_NO_NEW_PRIVS and then execs its argument.)
>>
>> Maybe it's just me, but I think this is useful and I would, in fact,
>> use it in my regular workflow.
>
> workflow for what?  Building software?  Let's try to narrow down the
> problem we're solving here.

Building software.  I run Fedora and I write software and generate
binaries that need to work on Ubuntu.  So I keep an Ubuntu chroot
around.  On the occasions when I update the chroot, I have no problem
sudoing from the Fedora side (although this is suboptimal).  I
certainly don't need the NSS databases kept in sync, and I'd rather
minimize the complexity of things that run setuid root.

no_new_privs chroot /var/chroot/ubuntu /bin/bash is sufficient for my needs.

If we could have a full fakeroot-like setup supported, that would be
even better.  But that isn't likely to happen with a 44-line patch.


Like I said, the chroot patch is an example.  I think it has enough
valid usecases to more than justify its minimal complexity.  I also
think it's far less important than the core no_new_privs patch, which
enables lots of things beyond just chroot.

--Andy
