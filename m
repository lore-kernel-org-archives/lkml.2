Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab2LISDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 13:03:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934297Ab2LISDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 13:03:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121208144944.GF12011@gmail.com>
References: <20121208144944.GF12011@gmail.com> <26921.1354542035@warthog.procyon.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo.kernel.org@gmail.com>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UAPI: Disintegrate arch/x86/include/asm
Date: Sun, 09 Dec 2012 18:02:50 +0000
Message-ID: <17310.1355076170@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> wrote:

>  arch/x86/include/asm/Kbuild           |   7 ++
>  arch/x86/include/asm/perf_regs.h      |  33 ---------
>  arch/x86/include/asm/svm.h            | 132 +---------------------------------
>  arch/x86/include/asm/vmx.h            |  89 +----------------------
>  arch/x86/include/uapi/asm/Kbuild      |   3 +
>  arch/x86/include/uapi/asm/perf_regs.h |  33 +++++++++
>  arch/x86/include/uapi/asm/svm.h       | 132 ++++++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/vmx.h       | 109 ++++++++++++++++++++++++++++
>  8 files changed, 289 insertions(+), 249 deletions(-)
> 
> What are these changes - it seems perf and KVM related.

Only in passing.  The header files you indicated are marked as being exported
to userspace in Kbuild - therefore they get disintegrated around __KERNEL__
conditionals just like all the other UAPI-relevant headers.

> Is the latest version above 100% bug-free, with no known 
> problems whatsoever?

It builds perf for me.  No idea if perf works, I've never used it.  I waved a
branch including the patch on top of all my perf patches towards Arnaldo and
others, but I don't know if they've tried it.

I've also checked that x86_64 allyesconfig and i386 allmodconfig build and
that an x86_64 kernel built with my test machine's usual config builds and
boots.

So, no known problems.

David
