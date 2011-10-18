Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1JRUNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 16:13:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49524 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1JRUNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 16:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1110182146440.3240@ionos>
References: <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <1318847658.6594.40.camel@twins> <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
 <1318874090.4172.84.camel@twins> <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
 <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
 <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
 <20111018182046.GF1309@hostway.ca> <alpine.LFD.2.02.1110182146440.3240@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2011 13:12:41 -0700
X-Google-Sender-Auth: Ns6-MSH7EtVslKw8vlX07hZGrbw
Message-ID: <CA+55aFyk50v0hRNbtfF3cskAH7U-yWpHQzA+tRDFZVa6n-F_yw@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 12:48 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> It does not look related.

Yeah, the only lock held there seems to be the socket lock, and it
looks like all CPU's are spinning on it.

> Could you try to reproduce that problem with
> lockdep enabled? lockdep might make it go away, but it's definitely
> worth a try.

And DEBUG_SPINLOCK / DEBUG_SPINLOCK_SLEEP too. Maybe you're triggering
some odd networking thing.  It sounds unlikely, but maybe some error
case you get into doesn't release the socket lock.

I think PROVE_LOCKING already enables DEBUG_SPINLOCK, but the sleeping
lock thing is separate, iirc.

                    Linus
