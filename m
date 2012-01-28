Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2A1TvC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 14:51:02 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44317 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2A1TvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 14:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7FAh27PU5koksh--v5yE9N7abz26=MQJ8np1U0PQDnP-w@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<1327706681-11959-2-git-send-email-wad@chromium.org>
	<CAObL_7FAh27PU5koksh--v5yE9N7abz26=MQJ8np1U0PQDnP-w@mail.gmail.com>
Date: Sat, 28 Jan 2012 11:50:57 -0800
Message-ID: <CABqD9hYbtR3ROU9RDG6=PxFz9mXZMJDNynU40SiOCEw+pct9dA@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 8:28 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Fri, Jan 27, 2012 at 3:24 PM, Will Drewry <wad@chromium.org> wrote:
>> Filter programs will be inherited across fork/clone and execve.
>> However, if the task attaching the filter is unprivileged
>> (!CAP_SYS_ADMIN) the no_new_privs bit will be set on the task.  This
>> ensures that unprivileged tasks cannot attach filters that affect
>> privileged tasks (e.g., setuid binary).
>
> This makes me nervous -- I don't think that the behavior of any new
> API should be different depending on privilege level -- adding a
> privilege should just make things work that would otherwise fail.  You
> might end up with bugs where a program is completely safe if run
> without CAP_SYS_ADMIN but, if run with CAP_SYS_ADMIN, bad things
> happen.  (The behavior of setuid(geteuid()) is an example of this
> problem.)
>
> One way to fix it is to make setting a filter program fail unless
> capable(CAP_SYS_ADMIN ) || no_new_privs.

Good call.  I'll upgrade the interaction with no_new_privs to be
explicit in the next revision.  It is certainly more transparent and
removes the risk of unintended consequences.

thanks!
