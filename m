Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2GFQ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:29:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43472 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab2GFQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:29:54 -0400
MIME-Version: 1.0
In-Reply-To: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 09:29:33 -0700
X-Google-Sender-Auth: 8mMLpJkWPqvKw9HXxlMB9jHPMI0
Message-ID: <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:20 PM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
>
> Several perf interrupt handlers (PEBS,IBS,BTS) re-write regs->ip but
> do not update the segment registers. So use an regs->ip based test
> instead of an regs->cs/regs->flags based test.

Christ, people, YOU CANNOT DO THIS!

It is never *ever* valid to test the IP to see if you're in kernel
space or user space. People can do various odd segments etc, the IP is
totally meaningless.

If the perf handlers fake the IP information, they had better fake the
CS/eflags information too. Because it is *wrong* to look at IP. Don't
do it.

                Linus
