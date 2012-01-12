Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2ALRbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:31:21 -0500
Received: from mail2.shareable.org ([80.68.89.115]:56295 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2ALRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:31:19 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jan 2012 12:31:18 EST
Date: Thu, 12 Jan 2012 17:30:48 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
Message-ID: <20120112173048.GK7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org>
 <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <20120112161418.GA22360@redhat.com>
 <1326386324.7642.96.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326386324.7642.96.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2012-01-12 at 17:14 +0100, Oleg Nesterov wrote:
> 
> > May be this needs something like LSM_UNSAFE_SECCOMP, or perhaps
> > cap_bprm_set_creds() should take seccomp.mode == 2 into account, I dunno.
> > 
> > OTOH, currently seccomp.mode == 1 doesn't allow to exec at all.
> 
> I've never used seccomp, so I admit I'm totally ignorant on this topic.
> 
> But looking at seccomp from the outside, the biggest advantage to this
> would be the ability for normal processes to be able to limit tasks it
> kicks off. If I want to run a task in a sandbox, I don't want to be root
> to do so.
> 
> I guess a web browser doesn't perform an exec to run java programs.

Actually it does.  Firefox on Linux forks and execs the Java VM.
Same for Flash, using "plugin-container".

> But it would be nice if I could execute something from the command
> line that I could run in a sand box.

You can do this now, using ptrace().  It's horrible, but half of the
horribleness is needing to understand machine-dependent registers,
which this new patch doesn't address.  (The other half is a ton of
undocumented but important ptrace() behaviours on Linux.)

-- Jamie
