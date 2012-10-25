Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2JYFVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:21:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:36811 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2JYFVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	<1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
Date: Thu, 25 Oct 2012 07:21:38 +0200
X-Google-Sender-Auth: Oonvi9lq0f8pW5UPtBJd7tExlDs
Message-ID: <CAMuHMdXUg-gzTD1NyBH=cfreg8vqN-dDpVGiEkj_pkS-4a1odg@mail.gmail.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:53 PM, Juri Lelli <juri.lelli@gmail.com> wrote:
> +#ifdef __SIZEOF_INT128__ /* gcc-4.6+ */
> +       unsigned __int128 val;
> +#endif

So the definition of val depends on (gcc) __SIZEOF_INT128__...

> +/*
> + * Make usage of __int128 dependent on arch code so they can
> + * judge if gcc is doing the right thing for them and can over-ride
> + * any funnies.
> + */
> +
> +#ifndef ARCH_HAS_INT128

... but all generic users depend on (Kconfig) ARCH_HAS_INT128?

How can Kconfig know if gcc supports this?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
