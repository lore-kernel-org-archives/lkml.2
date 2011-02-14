Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1BNQwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:52:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:34194 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab1BNQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:52:03 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <1297702013.23343.51.camel@gandalf.stny.rr.com>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <1297452328.5226.89.camel@laptop>
	 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
	 <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop>
	 <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins>
	 <20110214160437.GB2840@redhat.com>
	 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl>
	 <1297700754.5226.110.camel@laptop>  <20110214162947.GA3449@redhat.com>
	 <1297701438.5226.113.camel@laptop>
	 <1297702013.23343.51.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 17:53:14 +0100
Message-ID: <1297702394.5226.116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 11:46 -0500, Steven Rostedt wrote:
> On Mon, 2011-02-14 at 17:37 +0100, Peter Zijlstra wrote:
> 
> > We could of course cheat implement our own version of atomic_read() in
> > order to avoid the whole header mess, but that's not pretty at all
> 
> Oh God please no! ;)
> 
> atomic_read() is implemented per arch.

Ah, but it needn't be:

static inline int atomic_read(atomic_t *a)
{
	return ACCESS_ONCE(a->counter);
}

is basically it.

