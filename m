Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2DSSlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:41:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab2DSSlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:41:00 -0400
Date: Thu, 19 Apr 2012 20:40:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cred: change keyctl_session_to_parent() to use
	task_work_add()
Message-ID: <20120419184013.GA31862@redhat.com>
References: <20120419173431.GA27066@redhat.com> <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com> <23383.1334854333@redhat.com> <25695.1334858133@redhat.com> <20120419181010.GA29793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419181010.GA29793@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Oleg Nesterov wrote:
>
> On 04/19, David Howells wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > But I certainly do not want to put these changes in 3/3 or in this series.
> >
> > Why not?  It seems the correct place for them.
>
> I wanted to discuss the functional changes first, then send the trivial
> cleanups. And the changes in arch/ are always painful. And, "remove
> tracehook_notify_resume" is a bit off-topic, but I do not want to change
> the same code in arch/ twice.

That said, if you do not agree with 3/3 without "remove the call sites",
I'll send v6 which doesn't rename key_replace_session_keyring() but
updates the old callers:

	 arch/alpha/kernel/signal.c     |    2 -
	 arch/arm/kernel/signal.c       |    2 -
	 arch/avr32/kernel/signal.c     |    2 -
	 arch/blackfin/kernel/signal.c  |    2 -
	 arch/c6x/kernel/signal.c       |    2 -
	 arch/cris/kernel/ptrace.c      |    2 -
	 arch/frv/kernel/signal.c       |    2 -
	 arch/h8300/kernel/signal.c     |    2 -
	 arch/hexagon/kernel/signal.c   |    3 +-
	 arch/ia64/kernel/process.c     |    2 -
	 arch/m32r/kernel/signal.c      |    2 -
	 arch/mips/kernel/signal.c      |    2 -
	 arch/mn10300/kernel/signal.c   |    2 -
	 arch/openrisc/kernel/signal.c  |    2 -
	 arch/parisc/kernel/signal.c    |    2 -
	 arch/powerpc/kernel/signal.c   |    2 -
	 arch/s390/kernel/signal.c      |    2 -
	 arch/sh/kernel/signal_32.c     |    2 -
	 arch/sh/kernel/signal_64.c     |    2 -
	 arch/sparc/kernel/signal_32.c  |    2 -
	 arch/sparc/kernel/signal_64.c  |    2 -
	 arch/tile/kernel/process.c     |    2 -
	 arch/unicore32/kernel/signal.c |    2 -
	 arch/x86/kernel/signal.c       |    2 -
	 include/linux/key.h            |    4 --
	 include/linux/sched.h          |    2 -
	 kernel/cred.c                  |    9 -----
	 security/keys/internal.h       |    2 +
	 security/keys/keyctl.c         |   73 +++++++++++++++++++---------------------
	 security/keys/process_keys.c   |   20 ++++-------
	 30 files changed, 45 insertions(+), 114 deletions(-)

I am not going to argue, but honestly I don't think it is a good
idea to mix the functional changes in keyctl.c and the simple
(but obviously untested) cleanups.

Oleg.

