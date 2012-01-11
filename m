Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2AKQbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:31:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47369 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2AKQbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:31:35 -0500
MIME-Version: 1.0
In-Reply-To: <1326297936.2442.157.camel@twins>
References: <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
 <1326234230.2614.15.camel@edumazet-laptop> <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
 <4F0D2D9B.8030501@gmail.com> <1326272685.2442.120.camel@twins>
 <1326284711.2442.138.camel@twins> <20120111155658.GB26659@elte.hu> <1326297936.2442.157.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 08:31:12 -0800
X-Google-Sender-Auth: A981ttHlZH6Nr-pe9K8xCOIpbbI
Message-ID: <CA+55aFyyBpDR_oYu9EizwPf63q3Q=44Yw_jXd0Ozk0Ei1TtZJQ@mail.gmail.com>
Subject: Re: [BUG] kernel freezes with latest tree
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 8:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Ah, right! Silly me. One possibility is to rotate that list, except that
> won't work for the cgroup case where we have another iteration.

I just wonder whether you *really* need that loop at all?

If something went wrong with the attempted task move - you raced with
another cpu, or whatever - is there any real reason to even bother to
try again?

It's just a heuristic, after all, and we'll come back to balancing later.

The minimal patch looks good, but I did want to ask whether people
have considered just removing the looping entirely?

                           Linus
