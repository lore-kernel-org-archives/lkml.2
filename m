Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2ALQOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:14:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33189 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285Ab2ALQOr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <1326383015.7642.77.camel@gandalf.stny.rr.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 08:14:25 -0800
X-Google-Sender-Auth: SC8GEHhY-wx-BCLkeccqziOS4iQ
Message-ID: <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 7:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-01-11 at 11:25 -0600, Will Drewry wrote:
>
>> Filter programs may _only_ cross the execve(2) barrier if last filter
>> program was attached by a task with CAP_SYS_ADMIN capabilities in its
>> user namespace.  Once a task-local filter program is attached from a
>> process without privileges, execve will fail.  This ensures that only
>> privileged parent task can affect its privileged children (e.g., setuid
>> binary).
>
> This means that a non privileged user can not run another program with
> limited features? How would a process exec another program and filter
> it? I would assume that the filter would need to be attached first and
> then the execv() would be performed. But after the filter is attached,
> the execv is prevented?
>
> Maybe I don't understand this correctly.

Time to resurrect execve_nosecurity?  If so, then the rule could be
simplified to: seccomp programs cannot use normal execve at all.

The longer I linger on lists and see neat ideas like this, the more I
get annoyed that execve is magical.  I dream of a distribution that
doesn't use setuid, file capabilities, selinux transitions on exec, or
any other privilege changes on exec *at all*.  I think that the only
things missing in the kernel (other than something intelligent to do
about SELinux) are execve_nosecurity and the ability for a normal
program to wait for an unrelated program to finish (or some other way
that a program can ask a daemon to spawn a privileged program for it
and then to cleanly wait for that program to finish in a way that
could survive re-exec of the daemon).

--Andy

>
> -- Steve
>
>
