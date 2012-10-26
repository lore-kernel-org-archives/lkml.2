Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2JZLLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:11:36 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54554 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab2JZLLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:11:15 -0400
Date: Fri, 26 Oct 2012 13:11:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
Message-ID: <20121026111109.GA8195@gmail.com>
References: <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351172849.12171.10.camel@twins>
 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
 <1351241389.12171.45.camel@twins>
 <20121026092421.GB628@gmail.com>
 <1351244130.16863.7.camel@twins>
 <20121026094207.GA2179@gmail.com>
 <1351245264.16863.12.camel@twins>
 <alpine.LFD.2.02.1210261208170.2756@ionos>
 <1351248244.16863.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351248244.16863.13.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> I had hoped the u128 stuff might be elsewise useful, but if we 
> don't want to go there, that's fine.

I think it needs a clearer usecase - and even then the 32-bit 
behavior still looks rather horrible ...

So if we can escape all that with reasonable restrictions then 
that's far better than taking on this kind of overhead for 
32-bit systems. 32-bit still matters, we do the ktime_t 
complications for 32-bit systems and that's for a far smaller 
effect.

[ Would be nice to also stick in a WARN_ONCE() in the key 
  place(s) just in case, to make sure the overflow cannot happen 
  silently in the future. ]

Thanks,

	Ingo
