Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2ALXjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:39:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37405 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab2ALXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120112232735.5fa251e3@pyramind.ukuu.org.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <20120112161418.GA22360@redhat.com> <1326386324.7642.96.camel@gandalf.stny.rr.com>
 <20120112173048.GK7180@jl-vm1.vm.bytemark.co.uk> <1326390006.7642.114.camel@gandalf.stny.rr.com>
 <20120112174433.GM7180@jl-vm1.vm.bytemark.co.uk> <1326390981.7642.121.camel@gandalf.stny.rr.com>
 <20120112232735.5fa251e3@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 15:38:39 -0800
X-Google-Sender-Auth: z4IldmdYcRPWwpxZBR4osd_ZVNs
Message-ID: <CA+55aFy+qV4DGFqJX=dXsYhiTdR02HK-6xvxZJuZN5OMJt9=Rg@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jamie Lokier <jamie@shareable.org>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 3:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> It's a change of user context. Things like ptrace and file permissions
> basically mean you can't build a barrier between stuff running as the
> same uid to a great extent except with heavy restricting, but saying
> "you can't become someone else" is very useful.

Not just "someone else".

The guarantee basically has to be "you can't change your security
context". Where "become somebody else" is part of it, but any
capability changes etc would be part of it too. So it should disable
all games with capabilities etc.

And I don't think selinux really should be all that much of a problem
- we should just make sure that selinux would honor such a bit, and
refuse to do any op that would change any selinux capabilities either.
Same goes for other security models.

And that may include restricting the ways a binary can be executed
totally outside of suid/sgid bits. For example, if you consider
binaries under /home to have different selinxu rules than system
binaries in /usr/bin, then a cross-execute from one to the other may
not work, regardless of whether it's suid or not.

I think that is the kind of guarantee a sandbox environment really
wants: "I'm setting up a sandbox, you'd better not change the
permissions on me regardless of what crazy things I do".

                       Linus
