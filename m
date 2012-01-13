Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2AMVNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:13:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62287 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215Ab2AMVN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:13:29 -0500
MIME-Version: 1.0
In-Reply-To: <1326485605.4342.19.camel@localhost>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
 <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
 <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
 <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com> <1326485605.4342.19.camel@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 13:13:06 -0800
X-Google-Sender-Auth: nQ8KCkZCMmSKShVZpYnonr3AkWg
Message-ID: <CA+55aFzRymH+QSd1wyHmGoHaQkr96myh2j7VZVXzwPOU0otJ5g@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Eric Paris <eparis@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, djm@mindrot.org,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:13 PM, Eric Paris <eparis@redhat.com> wrote:
>
> So you can't drop capabilities(7)?  If you come in with permission you
> can't get rid of it?  Ouch.

I really don't understand why people get confused about this.

No, you can't drop capabilities. You're in a sandbox, the whole point
is that you're running untrusted code, you had better not *have* any
capabilities that you worry about dropping.

The whole "drop capabilities" is a red herring. If you think you need
it, you're doing something wrong.

                        Linus
