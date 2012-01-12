Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2ALQUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:20:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57856 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2ALQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:20:43 -0500
Date: Thu, 12 Jan 2012 16:18:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
 BPF
Message-ID: <20120112161806.21a09335@pyramind.ukuu.org.uk>
In-Reply-To: <1326302710-9427-2-git-send-email-wad@chromium.org>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Filter programs may _only_ cross the execve(2) barrier if last filter
> program was attached by a task with CAP_SYS_ADMIN capabilities in its
> user namespace.  Once a task-local filter program is attached from a
> process without privileges, execve will fail.  This ensures that only
> privileged parent task can affect its privileged children (e.g., setuid
> binary).

I think this model is wrong. The rest of the policy rules all work on the
basis that dumpable is the decider (the same rules for not dumping, not
tracing, etc). A user should be able to apply filter to their own code
arbitarily. Any setuid app should IMHO lose the trace subject to the usual
uid rules and capability rules. That would seem to be more flexible and
also the path of least surprise.

[plus you can implement non setuid exec entirely in userspace so it's
a rather meaningless distinction you propose]

> be tackled separately via separate patchsets. (And at some point sharing
> BPF JIT code!)

A BPF jit ought to be trivial and would be a big win.

In general I like this approach. It's simple, it's compact and it offers
interesting possibilities for solving some interesting problem spaces,
without the full weight of SELinux, SMACK etc which are still needed for
heavyweight security.

Alan
