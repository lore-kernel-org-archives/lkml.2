Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2B0R3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:29:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab2B0R3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:29:42 -0500
Date: Mon, 27 Feb 2012 18:22:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v11 08/12] signal, x86: add SIGSYS info and make it
	synchronous.
Message-ID: <20120227172208.GC10608@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org> <1330140111-17201-8-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330140111-17201-8-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Will Drewry wrote:
>
> To ensure that SIGSYS delivery occurs on return from the triggering
> system call, SIGSYS is added to the SYNCHRONOUS_MASK macro.

Hmm. Can't understand... please help.

>  #define SYNCHRONOUS_MASK \
>  	(sigmask(SIGSEGV) | sigmask(SIGBUS) | sigmask(SIGILL) | \
> -	 sigmask(SIGTRAP) | sigmask(SIGFPE))
> +	 sigmask(SIGTRAP) | sigmask(SIGFPE) | sigmask(SIGSYS))

Why?

SYNCHRONOUS_MASK just tells dequeue_signal() "pick them first".
This is needed to make sure that the handler for, say SIGSEGV,
can use ucontext->ip as a faulting addr.

But seccomp adds info->si_call_addr, this looks unneeded.

Oleg.

