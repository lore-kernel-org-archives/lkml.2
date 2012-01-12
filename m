Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2ALRgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:36:39 -0500
Received: from mail2.shareable.org ([80.68.89.115]:35533 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:36:36 -0500
Date: Thu, 12 Jan 2012 17:36:17 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
Message-ID: <20120112173617.GL7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org>
 <1326383015.7642.77.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326383015.7642.77.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2012-01-11 at 11:25 -0600, Will Drewry wrote:
> 
> > Filter programs may _only_ cross the execve(2) barrier if last filter
> > program was attached by a task with CAP_SYS_ADMIN capabilities in its
> > user namespace.  Once a task-local filter program is attached from a
> > process without privileges, execve will fail.  This ensures that only
> > privileged parent task can affect its privileged children (e.g., setuid
> > binary).
> 
> This means that a non privileged user can not run another program with
> limited features? How would a process exec another program and filter
> it? I would assume that the filter would need to be attached first and
> then the execv() would be performed. But after the filter is attached,
> the execv is prevented?

Ugly method: Using ptrace(), trap after the execve() and issue fake
syscalls to install the filter.  I feel dirty thinking it, in a good way.

LD_PRELOAD has been suggested.  It's not 100% reliable because not all
executables are dynamic (on some uClinux platforms none of them are),
but it will usually work.

-- Jamie
