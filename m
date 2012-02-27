Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab2B0SQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:16:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2B0SQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:16:26 -0500
Date: Mon, 27 Feb 2012 19:08:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <mcgrathr@google.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v11 08/12] signal, x86: add SIGSYS info and make it
	synchronous.
Message-ID: <20120227180847.GA13264@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org> <1330140111-17201-8-git-send-email-wad@chromium.org> <20120227172208.GC10608@redhat.com> <CAB=4xhpXB7K88sJXur5VK_-0BA0ZrSeT6UDQv3PS+FyjrSFsOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=4xhpXB7K88sJXur5VK_-0BA0ZrSeT6UDQv3PS+FyjrSFsOw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Roland McGrath wrote:
>
> On Mon, Feb 27, 2012 at 9:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > SYNCHRONOUS_MASK just tells dequeue_signal() "pick them first".
> > This is needed to make sure that the handler for, say SIGSEGV,
> > can use ucontext->ip as a faulting addr.
>
> It's desireable to have these signals handled first just so that the thread
> state that provoked the signal is not obscured by an unrelated asynchronous
> signal having its handler setup done beforehand.

OK, then probably it makes sense to update the changelog, "To ensure that
SIGSYS delivery occurs on return from the triggering system call" looks
confusing imho.

Not that I really understand why "setup_rt_frame() first" really matters
in this case, siginfo should carry all necessary info. IOW, may be "run
this handler first" makes more sense but this change makes the opposite.

OK, I won't argue, just I was confused by the changelog.

Oleg.

