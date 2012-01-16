Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2APV6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:58:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44784 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756885Ab2APV6J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:58:09 -0500
MIME-Version: 1.0
In-Reply-To: <1326750422.3467.31.camel@lenny>
References: <cover.1326673414.git.luto@amacapital.net> <1326746949.3467.16.camel@lenny>
 <CALCETrW3WyzaGBMJZzfohD=MRwdmeV9bAo4Leg1gaSnPL5URpg@mail.gmail.com> <1326750422.3467.31.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jan 2012 13:57:47 -0800
Message-ID: <CALCETrWCkX8DVRdyO5TEdeaobnW_+ic0OL7+8L6JeWwBcapNNw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
To: Colin Walters <walters@verbum.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Mon, Jan 16, 2012 at 1:47 PM, Colin Walters <walters@verbum.org> wrote:
> On Mon, 2012-01-16 at 13:25 -0800, Andy Lutomirski wrote:
>
>> The MS_NOSUID semantics are somewhat ridiculous for selinux,
>
> I don't see how they're ridiculous.

exec_sid is silently ignored.  So runcon will not switch context but
will still appear to succeed.

>
>> and I'd
>> rather not make them match for no_new_privs.
>
> Note your patch for selinux does exactly the same thing in the NOSUID
> case and your NO_NEW_PRIVS flag.  Right?
>
> -       if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> +       if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
> +           (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
>                new_tsec->sid = old_tsec->sid;
>

See several lines up.

>
>>  AppArmor completely
>> ignores MS_NOSUID,
>
> Ugh...well, I guess if it doesn't store any security data associated
> with files, only with file names, then there's nothing for it to do.

Nope.  It looks it up by file name or path, I think.

> Like I said before though, I think SELinux is the only sane LSM.

I think the fact that there is a bprm_set_creds hook at all is insane,
but maybe that's just me.  I think this is one of the things that
Windows does far better than POSIX.  On Windows, CreateProcess (the
moral equivalent of execve) never gains privileges.

--Andy
