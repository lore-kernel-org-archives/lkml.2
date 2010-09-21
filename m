Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0IUPaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:30:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab0IUPaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:30:23 -0400
Date: Tue, 21 Sep 2010 17:29:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 08/10] jump label v11: x86 support
Message-ID: <20100921152957.GA23380@elte.hu>
References: <cover.1284733808.git.jbaron@redhat.com>
 <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
 <4C981BC4.90405@zytor.com>
 <20100921152525.GC2873@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921152525.GC2873@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> On Mon, Sep 20, 2010 at 07:43:16PM -0700, H. Peter Anvin wrote:
> > On 09/17/2010 08:09 AM, Jason Baron wrote:
> > > add x86 support for jump label. I'm keeping this patch separate so its clear to
> > > arch maintainers what was required for x86 support this new feature. hopefully,
> > > it wouldn't be too painful for other arches.
> > 
> > > +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> > 
> > Why?
> > 
> > 	-hpa
> > 
> 
> Hi,
> 
> >From the documentation patch:
> 
> " The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When 
> CC_OPTIMIZE_FOR_SIZE is set, gcc does not always out of line the not 
> taken label path in the same way that the "if unlikely()" paths are 
> made out of line. Thus, with CC_OPTIMIZE_FOR_SIZE set, this 
> optimization is not always optimal. This may be solved in subsequent 
> gcc versions, that allow us to move labels out of line, while still 
> optimizing for size. "

OTOH making a difficult optimization (HAVE_ARCH_JUMP_LABEL) dependent on 
compiler flags is really asking for trouble.

So how about enabling it unconditionally, and just chalk up the cost 
under CC_OPTIMIZE_FOR_SIZE as one of the costs it already has? This also 
has the advantage that future compilers can improve things without 
having to wait for yet another kernel patch that re-enables 
HAVE_ARCH_JUMP_LABEL.

Thanks,

	Ingo
