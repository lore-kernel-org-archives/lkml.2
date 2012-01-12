Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2ALR42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:56:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:56:25 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=CN4PQ-MNGcoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=DLUoVEY-H-CSIDTj2GQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326390981.7642.121.camel@gandalf.stny.rr.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Steven Rostedt <rostedt@goodmis.org>
To: Jamie Lokier <jamie@shareable.org>
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
Date: Thu, 12 Jan 2012 12:56:21 -0500
In-Reply-To: <20120112174433.GM7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	 <1326302710-9427-2-git-send-email-wad@chromium.org>
	 <1326383015.7642.77.camel@gandalf.stny.rr.com>
	 <20120112161418.GA22360@redhat.com>
	 <1326386324.7642.96.camel@gandalf.stny.rr.com>
	 <20120112173048.GK7180@jl-vm1.vm.bytemark.co.uk>
	 <1326390006.7642.114.camel@gandalf.stny.rr.com>
	 <20120112174433.GM7180@jl-vm1.vm.bytemark.co.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 17:44 +0000, Jamie Lokier wrote:

> > I like Alan's suggestion. Have userspace decide to allow execv or not,
> > and even let it decide if it should allow setuid execv's or not, but
> > still allow non-setuid execvs. If you allow the setuid execv, once that
> > happens, the same behavior will occur as with ptrace. A setuid execv
> > will lose all its filtering.
> 
> I like the idea of letting the tracer decide what it wants.

Right, and if we implement the suggestion that Linus made, to set a flag
to prevent a task from every getting privilege, then seccomp can add
that too.

That is, there can be a filter to say "prevent this task from doing
anything with privilege" and that will prevent execv from gaining setuid
privilege. Perhaps, it would still do the execv, but the program that is
executed will run as the normal user, and just fail when it tries to do
something that requires sys admin privilege.

Thus, execv will not be a "special" case here. Seccomp either allows it
or not. But also add a command to tell seccomp that this task will not
be allowed to do anything privileged.

-- Steve


