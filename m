Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2APBEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 20:04:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41487 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2APBEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 20:04:39 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1326673414.git.luto@amacapital.net>
References: <cover.1326673414.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 15 Jan 2012 17:04:17 -0800
Message-ID: <CALCETrWWKpU3RHu25BO9sEWPZbBbemahfF9sjb8c_UfRrLcqVg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
To: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
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
        alan@lxorguk.ukuu.org.uk, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 4:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> To make the no_new_privs discussion more concrete, here is an updated
> series that is actually useful.  It adds PR_SET_NO_NEW_PRIVS with the
> same semantics as before (plus John Johansen's AppArmor fix and with
> improved bisectability).  It then allows some unshare flags and chroot
> (sometimes) when no_new_privs is set.

Here's another reason to allow setuid/setresuid when no_new_privs is set:

I'd like a pam_no_new_privs module that lets me set no_new_privs for
certain highly untrusted users.  The way to do it is:

PR_SET_NO_NEW_PRIVS
setuid(uid)
execve(the user's shell)

If setuid were disallowed, it would have to be:

setuid(uid)
PR_SET_NO_NEW_PRIVS
execve(the user's shell)

The latter is racy: the user can log in once, then log in a second
time and ptrace the login or sshd process between setuid and
PR_SET_NO_NEW_PRIVS.

--Andy
