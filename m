Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0F3IFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:05:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:32803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0F3IFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:05:47 -0400
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
 base implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       jeremy.fitzhardinge@citrix.com, Ky Srinivasan <KSrinivasan@novell.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 10:05:33 +0200
Message-ID: <1277885133.1868.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:31 +0100, Jan Beulich wrote:
> Add optional (alternative instructions based) callout hooks to the
> contended ticket lock and the ticket unlock paths, to allow hypervisor
> specific code to be used for reducing/eliminating the bad effects
> ticket locks have on performance when running virtualized.

Uhm, I'd much rather see a single alternative implementation, not a
per-hypervisor lock implementation.

> For the moment, this isn't intended to be used together with pv-ops,
> but this is just to simplify initial integration. The ultimate goal
> for this should still be to replace pv-ops spinlocks.

So why not start by removing that?

> +config ENLIGHTEN_SPINLOCKS

Why exactly are these enlightened? I'd say CONFIG_UNFAIR_SPINLOCKS would
be much better.

> +#define X86_FEATURE_SPINLOCK_YIELD (3*32+31) /* hypervisor yield interface */

That name also sucks chunks, yield isn't a lock related term.

> +#define ALTERNATIVE_TICKET_LOCK \

But but but, the alternative isn't a ticket lock..!?
