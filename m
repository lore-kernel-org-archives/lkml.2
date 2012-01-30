Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2A3WmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:42:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60125 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2A3WmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7F-vXXbkj8-9xsrxETyUka5xQ0jD9teN_Li50QzRYZugw@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<1327706681-11959-2-git-send-email-wad@chromium.org>
	<c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
	<CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
	<13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
	<CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
	<CAObL_7F-vXXbkj8-9xsrxETyUka5xQ0jD9teN_Li50QzRYZugw@mail.gmail.com>
Date: Mon, 30 Jan 2012 16:42:10 -0600
Message-ID: <CABqD9hbwr4pB4NL-mpXP7FRax7NeNsdbN3ZburpdNZeNRSrO=w@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Indan Zupancic <indan@nul.nu>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 4:29 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> [not quoting anything because this is a more general question]
>
> How portable across architectures is this supposed to be?  At least
> syscall numbering varies widely, and calling conventions can be
> different (x86_64 has four of them, for example).  For all I know,
> argument order might be different in some cases.

>From my perspective, the raw filter ABI shouldn't strive to be
arch-independent.  However, it'd be really nice to minimize the user
pain, but I don't know that there is any guarantee that any given
syscall will exist on all arches nor that it will treat its arguments
the same way.

Since glibc already does mapping of syscall args and numbers, we know
that userspace can fill in any arch-specific gaps, but it is nice if
the filters "just work" for the majority of cases if __NR_* defines
are used.

cheers!
will
