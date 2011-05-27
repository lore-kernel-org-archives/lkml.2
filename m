Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1E0Pwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:52:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968Ab1E0Pwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110527083554.GA21386@elte.hu>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org> <20110526193946.GA6363@elte.hu>
 <20110526212805.GB30593@ghostprotocols.net> <20110527083554.GA21386@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 08:46:42 -0700
Message-ID: <BANLkTikiF8qUZL7tiVUgTyhiih0M=sQkpA@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf symbols: Handle /proc/sys/kernel/kptr_restrict
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com, eranian@google.com,
        tzanussi@gmail.com, penberg@cs.helsinki.fi, efault@gmx.de,
        peterz@infradead.org, davej@redhat.com, davem@davemloft.net,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 1:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I think the biggest problem is that it is yelling at us even when i'm
> root - and root can access all the pointer values just fine:

Instead of looking at the kptr_restrict file, please just look at the
addresses in the kallsyms file, and if they are all zero, you know
that it's not a usable kallsyms file (and you can pretty much assume
that it's due to kptr_restrict).

So I think the whole symbol__read_kptr_restrict() thing is just
pointless. Don't do it.

                     Linus
