Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab0FKH6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:58:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab0FKH6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:58:42 -0400
Date: Fri, 11 Jun 2010 09:58:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100611075811.GA16293@elte.hu>
References: <cover.1276116186.git.jbaron@redhat.com>
 <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
 <1276171930.2077.200.camel@twins>
 <20100610121440.GA20130@elte.hu>
 <4C11D51E.3080909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C11D51E.3080909@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/10/2010 05:14 AM, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> >> On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> >>> +       select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> >>
> >> That deserves a comment somewhere, it basically makes OPTIMIZE_FOR_SIZE 
> >> useless...
> > 
> > Hm, we need more than a comment for that - distros enable 
> > CC_OPTIMIZE_FOR_SIZE all the time, for the massive kernel image (and 
> > hotpath cache footprint) savings. Is this fixable?
> 
> Actually the current reports from the gcc community is that gcc 4.5.0 + -Os 
> produces a broken kernel even without asm goto:
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44129

Well, most distros havent switched to gcc 4.5 yet (even rawhide is still on 
4.4 + backports) and i guess the lack of testing shows. New GCC versions have 
a long history of causing bugs in the kernel.

Thanks,

	Ingo
