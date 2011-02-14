Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1BNM2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:28:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab1BNM2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:28:05 -0500
Date: Mon, 14 Feb 2011 13:27:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110214122728.GC15860@elte.hu>
References: <cover.1294239591.git.jbaron@redhat.com>
 <1297452328.5226.89.camel@laptop>
 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
 <1297460297.5226.99.camel@laptop>
 <1297536465.5226.108.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297536465.5226.108.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2011-02-11 at 22:38 +0100, Peter Zijlstra wrote:
> > 
> > So why can't we make that jump_label_entry::refcount and
> > jump_label_key::state an atomic_t and be done with it? 
> 
> So I had a bit of a poke at this because I didn't quite understand why
> all that stuff was as it was. I applied both Jason's patches and then
> basically rewrote kernel/jump_label.c just for kicks ;-)
> 
> I haven't tried compiling this, let alone running it, but provided I
> didn't actually forget anything the storage per key is now 16 bytes when
> modules are disabled and 24 * (1 + mods) bytes for when they are
> enabled. The old code had 64 + 40 * mods bytes.
> 
> I still need to clean up the static_branch_else bits and look at !x86
> aside from the already mentioned bits.. but what do people think?

[...]

>  15 files changed, 333 insertions(+), 456 deletions(-)

The diffstat win alone makes me want this :-)

Thanks,

	Ingo
