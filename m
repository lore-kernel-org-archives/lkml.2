Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028Ab2JZSe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:34:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:35550 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965944Ab2JZSe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:34:27 -0400
Date: Fri, 26 Oct 2012 20:34:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
In-Reply-To: <1351276134.8467.62.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1210262033300.2756@ionos>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>   <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>   <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>   <1351172849.12171.10.camel@twins>  
 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>   <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>   <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>   <1351245264.16863.12.camel@twins>  
 <alpine.LFD.2.02.1210261208170.2756@ionos>   <1351248244.16863.13.camel@twins> <1351256204.16863.56.camel@twins>  <508AD291.1010803@gmail.com> <1351276134.8467.62.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, Steven Rostedt wrote:

> On Fri, 2012-10-26 at 11:12 -0700, Juri Lelli wrote:
> 
> > - scale down (right by 10) incoming parameters as to do internal
> >    math with ~1us resolution (and scale up outgoing params)
> 
> Would scaling down by 9 be sufficient? That way the resolution is still
> just less than 1us.

You have to do rounding anyway. So it does not matter whether you
chose 10 or 9.
