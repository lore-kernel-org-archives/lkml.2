Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1BNRml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:42:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1BNRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:42:40 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Peter Zijlstra <peterz@infradead.org>
To: Will Newton <will.newton@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Chris Metcalf <cmetcalf@tilera.com>, dhowells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "heiko.carstens" <heiko.carstens@de.ibm.com>,
        benh <benh@kernel.crashing.org>
In-Reply-To: <AANLkTi=pXqya2vaUv2XNwRr6T==MW8ZtQ_yg6V9sipcy@mail.gmail.com>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <1297452328.5226.89.camel@laptop>
	 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
	 <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop>
	 <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins>
	 <20110214160437.GB2840@redhat.com>
	 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl>
	 <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com>
	 <1297701438.5226.113.camel@laptop>
	 <1297702013.23343.51.camel@gandalf.stny.rr.com>
	 <1297703892.23343.71.camel@gandalf.stny.rr.com>
	 <1297704447.5226.127.camel@laptop>
	 <AANLkTi=pXqya2vaUv2XNwRr6T==MW8ZtQ_yg6V9sipcy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 18:43:48 +0100
Message-ID: <1297705428.5226.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 17:38 +0000, Will Newton wrote:
> On Mon, Feb 14, 2011 at 5:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> >> So all but a few have basically (as you said on IRC)
> >> #define atomic_read(v) ACCESS_ONCE(v)
> >
> > ACCESS_ONCE(v->counter), but yeah :-)
> 
> I maintain an out-of-tree architecture where that isn't the case
> unfortunately [1]. Not expecting any special favours for being
> out-of-tree of course, but just thought I would add that data point.
> 
> [1] Our atomic operations go around the cache rather than through it,
> so the value of an atomic cannot be read with a normal load
> instruction.

Cannot how? It would observe a stale value? That is acceptable for
atomic_read(). 

