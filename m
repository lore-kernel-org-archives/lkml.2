Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab1BNSXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:23:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:47392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1BNSXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:23:19 -0500
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
In-Reply-To: <AANLkTi=jz+mGru--+YA62EeER17Tuq2DocrkKNaU2k+1@mail.gmail.com>
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
	 <1297705428.5226.142.camel@laptop>
	 <AANLkTi=jz+mGru--+YA62EeER17Tuq2DocrkKNaU2k+1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 19:24:28 +0100
Message-ID: <1297707868.5226.189.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 17:50 +0000, Will Newton wrote:
> 
> It would observe a stale value, but that value would only be updated
> when the cache line was reloaded from main memory which would have to
> be triggered by either eviction or cache flushing. So it could get
> pretty stale. Whilst that's probably within the spec. of atomic_read I
> suspect it would lead to problems in practice. I could be wrong
> though. 

Right, so the typical scenario that could cause pain is something like:

while (atomic_read(&foo) != n)
  cpu_relax();

and the problem is that cpu_relax() doesn't know which particular
cacheline to flush in order to make things go faster, hm?



