Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2ARC0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:26:14 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36530 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531Ab2ARC0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120118022217.GS11715@one.firstfloor.org>
References: <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 17 Jan 2012 18:25:50 -0800
X-Google-Sender-Auth: mLcoPIEh9B0s2I5g6WdrkJzSIt8
Message-ID: <CAObL_7Hkq3LG++Y4E3h6LQgRiY89kHpgpX8-Vfdf9M0F-237yA@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
To: Andi Kleen <andi@firstfloor.org>
Cc: Jamie Lokier <jamie@shareable.org>, Indan Zupancic <indan@nul.nu>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 6:22 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> I'm pretty sure this isn't about changing cs or far jumps
>
> He's assuming that code can only run on two code segments and
> not arbitarily switch between them which is a completely incorrect
> assumption.

I think all he needs is to figure out which type of syscall was just
intercepted.  (Obviously arguments in memory are a problem.)
