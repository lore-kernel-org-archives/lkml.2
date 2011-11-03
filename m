Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1KCAAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:00:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57964 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1KCAAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <20111102134900.GB4377@one.firstfloor.org>
References: <20111102134900.GB4377@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Nov 2011 17:00:29 -0700
X-Google-Sender-Auth: p4NLK3x6TJrDj37UMD9KXwHTiiM
Message-ID: <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
Subject: Re: REGRESSION: "perf: Add PM notifiers ..." breaks resume
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Ingo, ping?

Quite frankly, I'm inclined to revert that patch just for being
horribly ugly and apparently broken regardless of the fact that it
also causes a regression.

*Notifiers* for doing something like this? smp_call_function? That's
just utter sh*t, guys.

If it is CPU state, then it should damn well be suspended and resumed
as part of CPU suspend and resume. No IPI cross-calls to ask other
CPU's to do random work, no crap like that.

Comments? Should I just revert the thing (silence is obviously "yes"
in cases like this where we are talking about regressions anyway)?

                   Linus

On Wed, Nov 2, 2011 at 6:49 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Resume stopped working on my Acer Aspire 1830T post 3.1. The screen
> just stays black after wakeup.
>
> I bisected it down to
>
> commit 144060fee07e9c22e179d00819c83c86fbcbf82c
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Aug 1 12:49:14 2011 +0200
>
>    perf: Add PM notifiers to fix CPU hotplug races
>
> Reverting this patch fixes the problem for me.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
