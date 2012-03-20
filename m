Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2CTRC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:02:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:60678 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab2CTRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:02:56 -0400
Date: Tue, 20 Mar 2012 18:02:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Serge Hallyn <serge.hallyn@canonical.com>
cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        kernel-hardening@lists.openwall.com, spender@grsecurity.net,
        mingo@kernel.org
Subject: Re: [PATCH] futex: do not leak robust list to unprivileged process
In-Reply-To: <20120320133141.GC2918@peqn>
Message-ID: <alpine.LFD.2.02.1203201758220.2542@ionos>
References: <20120319231253.GA20893@www.outflux.net> <20120320133141.GC2918@peqn>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012, Serge Hallyn wrote:

> Quoting Kees Cook (keescook@chromium.org):
> > It was possible to extract the robust list head address from a setuid
> > process if it had used set_robust_list(), allowing an ASLR info leak. This
> > changes the permission checks to be the same as those used for similar
> > info that comes out of /proc.
> > 
> > Running a setuid program that uses robust futexes would have had:
> >   cred->euid != pcred->euid
> >   cred->euid == pcred->uid
> > so the old permissions check would allow it. I'm not aware of any setuid
> > programs that use robust futexes, so this is just a preventative measure.
> > 
> > (This patch is based on changes from grsecurity.)
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> I like the change.  Much cleaner.  I'm not 100% sure though that
> there are no legitimate cases of robust futexes use which would now
> be forbidden.  (Explicitly cc:ing Ingo)

get_robust_list is not necessary for robust futexes. There is no
reference to get_robust_list in glibc.

I really wonder why we have this syscall at all.

Thanks,

	tglx
