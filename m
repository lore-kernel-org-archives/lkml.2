Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2ANQE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 11:04:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64816 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2ANQE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:04:56 -0500
MIME-Version: 1.0
In-Reply-To: <300903415.833492.1326554271998.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
References: <300903415.833492.1326554271998.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 14 Jan 2012 08:04:34 -0800
Message-ID: <CALCETrX8OOmCGFnOdFdxHRh=9vYROGg=qcK+c2G30FVbQhC4jQ@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Eric Paris <eparis@redhat.com>
Cc: jamie@shareable.org, torvalds@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, oleg@redhat.com, wad@chromium.org,
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

On Sat, Jan 14, 2012 at 7:17 AM, Eric Paris <eparis@redhat.com> wrote:
> -----Original Message-----
> From: Jamie Lokier [jamie@shareable.org]

> Andy Lutomirski wrote:
>
>> Is the current exec_no_trans check enough for you?  With my patch,
>> selinux can already block the execve if it wants.  (The policy is the
>> same as it would be if a program explicitly asked to run the new
>> executable with an unchanged security context.)  I'd be happy to fail
>> the exec in AppArmor, and then maybe AppArmor will change its mind
>> if/when users get annoyed :)
>
> Does SELinux block if userspace does exec entirely in userspace using
> mmap() and not execve()?  If not, why is execve() allowed to be different?
>
> Yes, we do (or can, and usually do in policy)
>

By blocking open, read, mmap, or mprotect?  And, more to the point, why?

I've always found it weird/annoying that selinux blocks things that
can neither be used to gain privilege nor to DoS the system.
Certainly a fully confined selinux program can emulate the execution
of anything it can read -- it just might be slow.

--Andy
