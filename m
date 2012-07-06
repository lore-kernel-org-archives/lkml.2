Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2GFSM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:12:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:49935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2GFSMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:12:20 -0400
Message-ID: <1341598329.7709.57.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 06 Jul 2012 20:12:09 +0200
In-Reply-To: <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 09:29 -0700, Linus Torvalds wrote:
> On Thu, Jul 5, 2012 at 11:20 PM, tip-bot for Peter Zijlstra
> <a.p.zijlstra@chello.nl> wrote:
> >
> > Several perf interrupt handlers (PEBS,IBS,BTS) re-write regs->ip but
> > do not update the segment registers. So use an regs->ip based test
> > instead of an regs->cs/regs->flags based test.
> 
> Christ, people, YOU CANNOT DO THIS!
> 
> It is never *ever* valid to test the IP to see if you're in kernel
> space or user space. People can do various odd segments etc, the IP is
> totally meaningless.
> 
> If the perf handlers fake the IP information, they had better fake the
> CS/eflags information too. Because it is *wrong* to look at IP. Don't
> do it.

PEBS, BTS, LBR don't have CS. PEBS does have eflags.

If we cannot do this I'm not sure what we can do :/
