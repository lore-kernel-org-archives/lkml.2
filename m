Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2AJQ2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:28:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40244 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2AJQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1326171444.6638.3.camel@edumazet-laptop> <1326171798.6638.4.camel@edumazet-laptop>
 <1326183371.6638.6.camel@edumazet-laptop> <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 08:28:12 -0800
X-Google-Sender-Auth: uGj6D_zsKFRw9MiXLTxdYb6if24
Message-ID: <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
Subject: Re: [BUG] kernel freezes with latest tree
To: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 8:13 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Here are two traces of the lockups, since I had some free time to reproduce the
> bug on current tree (plus a minor change in bnx2 driver to avoid a
> netconsole related stack trace)

Hmm. You have load_balance() and idle_balance() there in the trace, so
I'm getting more hopeful that it really is just the fact that
set_cpu_sd_state_idle() really needs to just be run with interrupts
disabled. That was my main concern about that merge, so if it's that,
I'll be relieved.

If you can please try that change out, that would be great.

[ And if that's not it - Ingo & co, please check out the traces on lkml ]

                       Linus
