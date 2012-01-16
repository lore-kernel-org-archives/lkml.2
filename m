Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2APApz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:45:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62176 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2APApy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:45:54 -0500
MIME-Version: 1.0
In-Reply-To: <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
References: <cover.1326673414.git.luto@amacapital.net> <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Jan 2012 16:45:31 -0800
X-Google-Sender-Auth: n_noBNHYEr_idYsSdcHrNEqMmT8
Message-ID: <CA+55aFybUcL2M9qZ91MF-PAwNSO6AdEfHXv_i00sftHyTb3ocQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
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

On Sun, Jan 15, 2012 at 4:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Chroot can easily be used to subvert setuid programs.  If no_new_privs,
> then setuid programs don't gain any privilege, so allow chroot.
>
> Because chroot is an easy way to break out of chroot jail, CAP_SYS_ADMIN
> is still required if the caller is already chrooted.

So I think this whole chroot thing needs more people looking at it. I
brought up chroot as an example, but there may be other reasons why
you don't want user chrooting things than just the setuid confusion.

There's also the whole issue with doing things like local non-root
bind mounts, which are arguably more useful than chroot, and which are
disallowed for similar reasons. So I don't think chroot is all that
special.

                         Linus
