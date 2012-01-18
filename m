Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2ARSYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:24:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58320 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2ARSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:24:14 -0500
Date: Wed, 18 Jan 2012 19:24:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Martin Mares <mj@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Jamie Lokier <jamie@shareable.org>,
        Andi Kleen <andi@firstfloor.org>, Indan Zupancic <indan@nul.nu>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120118182411.GT11715@one.firstfloor.org>
References: <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com> <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFyVTh4SQjjcf3x9BSzULttNVcmG9FyaKzhok=2_804xWA@mail.gmail.com> <20120118023114.GA9643@alboin.amr.corp.intel.com> <CA+55aFyEde=PLkgsx+FECRrX-dSsOSQkeY_by5=+hnkQhj5hFw@mail.gmail.com> <mj+md-20120118.134958.22774.nikam@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mj+md-20120118.134958.22774.nikam@ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not everybody. There are programs which try hard to distinguish between
> int80 and syscall. One such example is a sandbox for programming contests
> I wrote several years ago. It analyses the instruction before EIP and as
> it does not allow threads nor executing writeable memory, it should be
> correct.

There are other ways to break it, like using the syscall itself to change
input arguments or using ptrace from another process and other ways.

Generally there are so many races with ptrace that if you want to do
things like that it's better to use a LSM. That's what they are for.

-Andi

