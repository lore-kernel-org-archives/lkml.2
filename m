Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2LJSNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:13:02 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44372 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2LJSM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:12:57 -0500
MIME-Version: 1.0
In-Reply-To: <50C603F8.6070401@schaufler-ca.com>
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
 <20121210145950.GC8137@sergelap> <50C603F8.6070401@schaufler-ca.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Dec 2012 10:12:35 -0800
Message-ID: <CALCETrWNboHVRm_aZ-Fvqri6PW3C4FPfuLLe3-8q7+-vgEP2nw@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 7:47 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> Put an ACL on the program file.
> If you want different users to run with different privilege
> make two copies of the program and give them different
> ACLs and cap sets.
> If your program is so big that making a copy is a disk space issue
> it is too big to have privilege.
> If you can't deal with having the have different paths for different
> users write a shell script that redirects to the correct version
> based on user id.
>
> This is not rocket science. The kernel shouldn't be crammed
> with mechanism and complexity just because disto/"OS"/site
> developers can't be bothered with learning how the existing
> facilities work.

I agree.  But I think that the existing capability support is already
overcomplicated, and I'd rather make it simpler.  Sticking the
complexity in userspace is too difficult right now because it requires
fiddling with the file inheritable mask.

I think that the Windows approach is worth looking at.  See here:

http://msdn.microsoft.com/en-us/library/windows/desktop/aa375202%28v=vs.85%29.aspx

In the Windows model, each capability ("privilege") can be in one of
three states: enabled (i.e working right now), permitted (i.e.
available upon request but not currently enabled), or removed
(disallowed to this process and all of its children).  Permitted
privileges are always inherited when a child process is created.

This is *way* simpler than Linux's model, and it works just fine*.

--Andy

* In fairness, MS apparently forgot to add the ability to drop
permitted privileges until XP SP 2 or thereabouts.  Adding it was a
no-brainer, though, because Windows has no concept of setuid, so
sendmail-style attacks are impossible even in principle.
