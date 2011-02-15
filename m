Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1BOWWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:22:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:53990 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab1BOWWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:22:22 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: simoneau@ele.uri.edu, will.newton@gmail.com, hpa@zytor.com,
        matt@console-pimps.org, rostedt@goodmis.org, peterz@infradead.org,
        jbaron@redhat.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <20110215.132702.39199169.davem@davemloft.net>
References: <4D59B891.8010300@zytor.com>
	 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	 <20110215211123.GA3094@ele.uri.edu>
	 <20110215.132702.39199169.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 16:20:18 -0600
Message-ID: <1297808418.2460.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 13:27 -0800, David Miller wrote:
> From: Will Simoneau <simoneau@ele.uri.edu>
> Date: Tue, 15 Feb 2011 16:11:23 -0500
> 
> > Note how the cache and cache coherence protocol are fundamental parts of this
> > operation; if these instructions simply bypassed the cache, they *could not*
> > work correctly - how do you detect when the underlying memory has been
> > modified?
> 
> The issue here isn't L2 cache bypassing, it's local L1 cache bypassing.
> 
> The chips in question aparently do not consult the local L1 cache on
> "ll" instructions.
> 
> Therefore you must only ever access such atomic data using "ll"
> instructions.

Note that it's actually a reasonable design choice to not consult the L1
in these case .... as long as you invalidate it on the way. That's how
current powerpcs do it afaik, they send a kill to any matching L1 line
along as reading from the L2. (Of course, L1 has to be write-through for
that to work).

Cheers,
Ben.


