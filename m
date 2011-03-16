Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1CPSFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:05:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1CPSE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:04:58 -0400
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <20110316175310.GA2861@ghostprotocols.net>
References: <20110314205100.GG6139@nowhere>
	 <20110314210315.GC2388@ghostprotocols.net> <20110314212050.GH6139@nowhere>
	 <20110314215603.GD2388@ghostprotocols.net> <20110314224344.GA11443@nowhere>
	 <20110314230211.GG2388@ghostprotocols.net> <20110315185812.GB6605@nowhere>
	 <20110315192422.GF7011@ghostprotocols.net> <20110316010304.GB7760@nowhere>
	 <4D80DB75.6060408@hitachi.com>  <20110316175310.GA2861@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Mar 2011 19:02:37 +0100
Message-ID: <1300298557.2203.1810.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 14:53 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 17, 2011 at 12:47:01AM +0900, Masami Hiramatsu escreveu:
> > (2011/03/16 10:03), Frederic Weisbecker wrote:
> > > Doh you're right. && would have two meaning.
> > > No we should probably keep  a && b  has a meaning of we are
> > > in the range a AND in the range b. Both at the same time, with
> > > a evaluated first and then b. We also need to ensure than
> > > a && b  doesn't mean the same than  b && a. You're right, perhaps
> > > we need another operator to expression inclusion, or we need to
> > > assume that specific meaning of &&.
> > > 
> > > For what I wanted to express in the example above, || seem be the
> > > right choice: -e inst*@(..lock:*acquire(B) || lock:*release(B)..)
> > > 
> > > So || would mean union and && would mean inclusion.
> > 
> > Hmm, would we really need that kind of complex rules?
> > It seems that we only need union case. If so, I'd suggest
> > you to use ',' to express that, instead of ||.
> > 
> > -e inst*@(..lock:*acquire(B),lock:*release(B)..)
> 
> Yeah, I somehow was avoiding the comma operator because it could be used
> to represent multiple events, but then its a different context, using it
> to represent a circular list of ranges in the @ (at, location) expression
> seems ok.
> 
> 1. '..lock:*acquire(B)' is armed, 'lock:*release(B)..' isn't
> 2. '..lock:*acquire(B)' trigers, which causes 'lock:*release(B)..' to be
>    armed
> 3. 'lock:*release(B)..' triggers, which causes '..lock:*acquire(B)' to
>    be armed, rinse, repeat

How about we start writing proper EBNF syntax rules for this stuff, its
getting seriously out of hand.
