Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2IXUgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:36:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab2IXUgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:36:23 -0400
Date: Mon, 24 Sep 2012 22:37:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH 1/4] task_work: make task_work_add() lockless
Message-ID: <20120924203750.GA28983@redhat.com>
References: <20120826191132.GA3743@redhat.com> <20120826191209.GA4221@redhat.com> <CAMuHMdU7D+SM=xCN9Yp0KuGwiod=RojWjkpdYT-Hw=v9iry66A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU7D+SM=xCN9Yp0KuGwiod=RojWjkpdYT-Hw=v9iry66A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Geert Uytterhoeven wrote:
>
> On Sun, Aug 26, 2012 at 9:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > +       while ((work = ACCESS_ONCE(*pprev))) {
> > +               read_barrier_depends();

Hmm. This should be smp_read_barrier_depends(), but this doesn't matter.

> Woops, h8300 doesn't have read_barrier_depends():
> kernel/task_work.c:38:3: error: implicit declaration of function
> 'read_barrier_depends' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[2]: *** [kernel/task_work.o] Error 1

Thanks...

> http://kisskb.ellerman.id.au/kisskb/buildresult/7238385/
>
> Perhaps an empty definition is fine? Most architectures have:
>
> #define read_barrier_depends() do { } while(0)

Yes. arch/h8300/include/asm/barrier.h has

	#define smp_read_barrier_depends()      read_barrier_depends()

so probably it should define read_barrier_depends() as well ?

Oleg.

