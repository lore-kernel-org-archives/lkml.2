Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1BOB3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:29:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1BOB3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:29:21 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=kpgHfoFBP4dsjBs90hoA:9 a=DoQ3bemvunjLn0JKUUUA:7 a=lA0Jeg_xs7T6tmDOA5V9lQ9eiNMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>,
        David Miller <davem@davemloft.net>, peterz@infradead.org,
        will.newton@gmail.com, jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <57049.94.211.195.167.1297729198.squirrel@gate.crashing.org>
References: <1297707868.5226.189.camel@laptop>
	 <1297718964.23343.75.camel@gandalf.stny.rr.com>
	 <1297719576.23343.80.camel@gandalf.stny.rr.com>
	 <20110214.134600.179933733.davem@davemloft.net>
	 <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
	 <BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl>
	 <20110214230902.GM2256@linux.vnet.ibm.com>
	 <BLU0-SMTP4599FAAD7330498472B87396D00@phx.gbl>
	 <57049.94.211.195.167.1297729198.squirrel@gate.crashing.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 20:29:16 -0500
Message-ID: <1297733356.23343.91.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 01:19 +0100, Segher Boessenkool wrote:
> >> What CPU family are we talking about here?  For cache coherent CPUs,
> >> cache coherence really is supposed to work, even for mixed atomic and
> >> non-atomic instructions to the same variable.
> >
> > I'm really curious to know which CPU families too. I've used git blame
> > to see where these lwz/stw instructions were added to powerpc, and it
> > points to:
> >
> > commit 9f0cbea0d8cc47801b853d3c61d0e17475b0cc89
> 
> > So let's ping the relevant people to see if there was any reason for
> > making these atomic read/set operations different from other
> > architectures in the first place.
> 
> lwz is a simple 32-bit load.  On PowerPC, such a load is guaranteed
> to be atomic (except some unaligned cases).  stw is similar, for stores.
> These are the normal insns, not ll/sc or anything.
> 
> At the time, volatile tricks were used to make the accesses atomic; this
> patch changed that.  Result is (or should be!) better code generation.
> 
> Is there a problem with it?

I guess Mathieu was just getting confused.

But we are looking at seeing if we can make atomic_read() a generic
function instead of defining it for all archs. Just something that we
could do to fix the include header hell when a static inline contains
atomic_read() and happens to be included by kernel.h. Then we have
atomic.h needing to include kernel.h which needs to include atomic.h
first and so on.

Although, it may be just best if we can do some #ifdef magic to prevent
all this mess anyway.

-- Steve


