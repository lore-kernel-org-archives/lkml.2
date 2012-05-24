Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472Ab2EXWBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:01:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab2EXWA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:00:59 -0400
Date: Thu, 24 May 2012 15:00:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com, hpa@zytor.com,
        indan@nul.nu, netdev@parisplace.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org
Subject: Re: [RFC PATCH 0/3] move the secure_computing call
Message-Id: <20120524150057.86c14b35.akpm@linux-foundation.org>
In-Reply-To: <1337875681-20717-1-git-send-email-wad@chromium.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
	<1337875681-20717-1-git-send-email-wad@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 11:07:58 -0500
Will Drewry <wad@chromium.org> wrote:

> This is an RFC based on the comments from Al Viro and Eric Paris
> regarding ptrace()rs being able to change the system call the kernel
> sees after the seccomp enforcement has occurred (for mode 1 or 2).

Perhaps you could repeat those comments in this changelog.

> With this series applied, a (p)tracer of a process with seccomp enabled
> will be unable to change the tracee's system call number after the
> secure computing check has been performed.
> 
> The x86 change is tested, as is the seccomp.c change.  For other arches,
> it is not (RFC :).  Given that there are other inconsistencies in this
> code across architectures, I'm not sure if it makes sense to attempt to
> fix them all at once or to roll through as I attempt to add seccomp
> filter support.
> 
> As is, the biggest benefit of this change is just setting consistent
> expectations in what the ptrace/seccomp interactions should be.  The
> current ability for ptrace to "bypass" secure computing (by remapping
> allowed system calls) is not necessarily a problem, but it is not
> necessarily intuitive behavior.
> 

Because my take on the above reasoning is "why did you bother writing
these patches"!

