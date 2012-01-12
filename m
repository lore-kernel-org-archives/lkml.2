Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2ALQ7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:59:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2ALQ7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:59:17 -0500
MIME-Version: 1.0
In-Reply-To: <1326383015.7642.77.camel@gandalf.stny.rr.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<1326383015.7642.77.camel@gandalf.stny.rr.com>
Date: Thu, 12 Jan 2012 10:59:15 -0600
Message-ID: <CABqD9hbOUy1qO0f+JFitRXH6c5EgLTWOh5eGdo8dTxeXJ40h2g@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 9:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
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

Yeah - it means tasks can filter themselves, but not each other.
However, you can inject a filter for any dynamically linked executable
using LD_PRELOAD.

> Maybe I don't understand this correctly.

You're right on.  This was to ensure that one process didn't cause
crazy behavior in another. I think Alan has a better proposal than
mine below.  (Goes back to catching up.)
