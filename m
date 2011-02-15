Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1BOPUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:20:21 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:38660 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1BOPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:20:18 -0500
Date: Tue, 15 Feb 2011 16:20:09 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Chris Metcalf <cmetcalf@tilera.com>, dhowells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        benh <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110215152009.GC2866@osiris.boeblingen.de.ibm.com>
References: <20110214155113.GA2840@redhat.com>
 <1297699024.2401.12.camel@twins>
 <20110214160437.GB2840@redhat.com>
 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl>
 <1297700754.5226.110.camel@laptop>
 <20110214162947.GA3449@redhat.com>
 <1297701438.5226.113.camel@laptop>
 <1297702013.23343.51.camel@gandalf.stny.rr.com>
 <1297703892.23343.71.camel@gandalf.stny.rr.com>
 <1297704447.5226.127.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297704447.5226.127.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 06:27:27PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-02-14 at 12:18 -0500, Steven Rostedt wrote:
> 
> > mn10300:
> > #define atomic_read(v)  ((v)->counter)
> 
> > tile:
> > static inline int atomic_read(const atomic_t *v)
> > {
> >        return v->counter;
> > }
> 
> Yeah, I already send email to the respective maintainers telling them
> they might want to fix this ;-)
> 
> 
> > So all but a few have basically (as you said on IRC)
> > #define atomic_read(v) ACCESS_ONCE(v)
> 
> ACCESS_ONCE(v->counter), but yeah :-)
> 
> > Those few are blackfin, s390, powerpc and tile.
> > 
> > s390 probably doesn't need that much of a big hammer with atomic_read()
> > (unless it uses it in its own arch that expects it to be such).
> 
> Right, it could just do the volatile thing..

The reason that the code on s390 looks like it is was that the volatile
cast was known to generate really bad code.
However I just tried a few variants (inline asm / ACCESS_ONCE / leave as is)
with gcc 4.5.2 and the resulting code was always identical.
So I'm going to change it to the ACCESS_ONCE variant so it's the same like
everywhere else.
