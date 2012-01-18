Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2ARPGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:06:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab2ARPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:06:21 -0500
Message-ID: <1326899083.2937.14.camel@localhost>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Date: Wed, 18 Jan 2012 10:04:43 -0500
In-Reply-To: <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com>
	 <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
	 <20120117164523.GA17070@redhat.com>
	 <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
	 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
	 <20120117170512.GB17070@redhat.com>
	 <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
	 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
	 <20120118015013.GR11715@one.firstfloor.org>
	 <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	 <20120118022217.GS11715@one.firstfloor.org>
	 <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
	 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 22:25 -0800, Linus Torvalds wrote:

> Of course, limiting things so that you cannot map the same page
> executably *and* writably is one solution - and a good idea regardless
> - so secure environments can still exist. But even then you could have
> races in a multi-threaded environment (they'd just be *much* harder to
> trigger for an attacker).

Gratuitous SELinux for the win e-mail!  (Feel free to delete now)  We
typically, for all confined domains, do not allow mapping anonymous
memory both W and X.  Actually you can't even map it W and then map it
X...

Now if there is file which you have both W and X SELinux permissions
(which is rare, but not impossible) you could map it in two places.  So
we can (and do) build SELinux sandboxes which address this.

