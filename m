Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1BNV3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 16:29:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1BNV3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 16:29:30 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4nhS0ASVNNpThf63vxYA:9 a=bsguCIjqvlTbnrEweIp5pdHNDFUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Newton <will.newton@gmail.com>, Jason Baron <jbaron@redhat.com>,
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
In-Reply-To: <1297707868.5226.189.camel@laptop>
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
	 <1297707868.5226.189.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 16:29:24 -0500
Message-ID: <1297718964.23343.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 19:24 +0100, Peter Zijlstra wrote:
> On Mon, 2011-02-14 at 17:50 +0000, Will Newton wrote:
> > 
> > It would observe a stale value, but that value would only be updated
> > when the cache line was reloaded from main memory which would have to
> > be triggered by either eviction or cache flushing. So it could get
> > pretty stale. Whilst that's probably within the spec. of atomic_read I
> > suspect it would lead to problems in practice. I could be wrong
> > though. 
> 
> Right, so the typical scenario that could cause pain is something like:
> 
> while (atomic_read(&foo) != n)
>   cpu_relax();
> 
> and the problem is that cpu_relax() doesn't know which particular
> cacheline to flush in order to make things go faster, hm?

But what about any global variable? Can't we also just have:

	while (global != n)
		cpu_relax();

?

-- Steve


